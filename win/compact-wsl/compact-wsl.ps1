# compact-wsl.ps1

$VhdxPath = "D:\wsl\Ubuntu\ext4.vhdx"

if (-not (Test-Path $VhdxPath)) {
    Write-Error "找不到 VHDX 文件：$VhdxPath"
    exit 1
}

Write-Host "正在关闭 WSL..."
wsl --shutdown

$before = (Get-Item $VhdxPath).Length
Write-Host ("压缩前大小：{0:N2} GB" -f ($before / 1GB))

$diskpartScript = @"
select vdisk file="$VhdxPath"
attach vdisk readonly
compact vdisk
detach vdisk
exit
"@

$tempFile = Join-Path $env:TEMP "compact-wsl-diskpart.txt"
$diskpartScript | Set-Content -Path $tempFile -Encoding ASCII

Write-Host "正在压缩 WSL 虚拟磁盘..."
diskpart /s $tempFile

Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

$after = (Get-Item $VhdxPath).Length
$freed = $before - $after

Write-Host ""
Write-Host ("压缩后大小：{0:N2} GB" -f ($after / 1GB))
Write-Host ("释放空间：  {0:N2} GB" -f ($freed / 1GB))
Write-Host "完成。"