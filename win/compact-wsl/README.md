# WSL 虚拟磁盘压缩脚本说明

## 用途

WSL2 使用 `ext4.vhdx` 虚拟磁盘保存 Linux 文件系统。

当你在 WSL 中删除大量文件后，Linux 内部的可用空间会增加，但 Windows 上的 `ext4.vhdx` 文件通常不会自动缩小，因此 D 盘空间不会立即恢复。

这个脚本用于压缩 `ext4.vhdx`，将 WSL 中已经释放的空间归还给 Windows。

---

## 文件说明

当前脚本默认使用的 WSL 虚拟磁盘路径：

```text
D:\wsl\Ubuntu\ext4.vhdx
```

如果你的 VHDX 文件位于其他位置，请修改脚本中的：

```powershell
$VhdxPath = "D:\wsl\Ubuntu\ext4.vhdx"
```

---

## 使用

### 1. 在 WSL 中执行 TRIM

建议在压缩之前先打开 Ubuntu，执行：

```bash
sudo fstrim -av
```

```bash
exit
```

---

### 2. 以管理员身份打开 PowerShell 执行压缩脚本

运行：

```powershell
powershell -ExecutionPolicy Bypass -File "D:\path\to\compact-wsl.ps1"
```
---

## 注意事项

 1. 压缩前保存 WSL 中的工作
 2. 不要在压缩过程中启动 WSL
 3. 压缩不会删除正常文件
 4. 不需要每次删除小文件都执行，没有必要频繁压缩。
