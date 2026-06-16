# fix-univpn-route.ps1

这个脚本用于解决的是在使用 vpn 软件是导致的代理软件不能使用的问题。

由于特殊环境需要，我们往往需要使用 vpn(如 univpn) 来连接实验室的资源，但是往往 vpn 软件会劫持流量，导致代理软件无法使用。

同时由于作者的电脑 tun 模式一直莫名其妙无法使用且作者使用的是机场自研的软件，这里无法通过通用的配置和检查日志来修改配置，故需要自己对路由进行调整。

### 具体使用

在开启代理软件和 vpn 的 windows 环境同目录下，以终端管理员运行
```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\fix-univpn-route.ps1
```
其中
```powershell
$CorpRoutes = @(
    "192.168.88.220/32"
)
```
需要根据自己特定的网段调整。

也可以配置成一个函数，终端管理员下
```powershell
notepad $PROFILE
```
加入
```powershell
function useunivpn {
     Set-ExecutionPolicy -Scope Process Bypass
     .\fix-univpn-route.ps1
}
```
之后以 useunivpn 运行
