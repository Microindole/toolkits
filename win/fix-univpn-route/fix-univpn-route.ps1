# fix-univpn-route.ps1
# 管理员 PowerShell 运行
# 作用：让公网走本地网关，让指定公司内网走 UniVPN

$CorpRoutes = @(
    "192.168.88.220/32"
)

# 找 UniVPN 默认路由：通常是 metric 最低的 0.0.0.0/0
$DefaultRoutes = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4 |
    Where-Object { $_.NextHop -ne "0.0.0.0" }

$VpnDefault = $DefaultRoutes |
    Sort-Object RouteMetric |
    Select-Object -First 1

$LocalDefault = $DefaultRoutes |
    Where-Object { $_.InterfaceAlias -notmatch "TAP|VPN|Uni|本地连接" } |
    Sort-Object RouteMetric |
    Select-Object -First 1

if (-not $VpnDefault) {
    Write-Host "未找到 VPN 默认路由。" -ForegroundColor Red
    exit 1
}

if (-not $LocalDefault) {
    Write-Host "未找到本地网络默认网关。" -ForegroundColor Red
    exit 1
}

$VpnGateway   = $VpnDefault.NextHop
$LocalGateway = $LocalDefault.NextHop

Write-Host "VPN网关:  $VpnGateway"
Write-Host "本地网关: $LocalGateway"

# 降低 VPN 默认路由优先级
route change 0.0.0.0 mask 0.0.0.0 $VpnGateway metric 500

# 确保本地默认路由优先
route add 0.0.0.0 mask 0.0.0.0 $LocalGateway metric 1 2>$null
route change 0.0.0.0 mask 0.0.0.0 $LocalGateway metric 1

# 公司内网走 VPN
foreach ($Route in $CorpRoutes) {
    $parts = $Route.Split("/")
    $ip = $parts[0]
    $cidr = [int]$parts[1]

    if ($cidr -eq 32) {
        $mask = "255.255.255.255"
    } elseif ($cidr -eq 24) {
        $mask = "255.255.255.0"
    } elseif ($cidr -eq 16) {
        $mask = "255.255.0.0"
    } else {
        Write-Host "暂不支持 CIDR: $Route，请手动写 mask。" -ForegroundColor Yellow
        continue
    }

    route add $ip mask $mask $VpnGateway metric 1 2>$null
    route change $ip mask $mask $VpnGateway metric 1
}

Write-Host "`n完成。关键路由：" -ForegroundColor Green
route print | findstr "0.0.0.0 192.168"