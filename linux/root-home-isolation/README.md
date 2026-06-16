# 单一用户下隔离开发环境

## 背景

某些服务器只提供单一用户账号(以 root 用户为例)，但不希望修改 `.gitconfig`、`.ssh`、`.bashrc` 等全局环境。

本方法在不创建新 Linux 用户的情况下，把开发环境隔离到 `/home/abc`。

## 特点

- 仍然使用 root 用户
- 不修改 `/root` 下的配置
- Git 配置放在 `/home/abc/.gitconfig`
- Git 凭证放在 `/home/abc/.git-credentials`
- SSH 配置放在 `/home/abc/.ssh`
- Shell 配置放在 `/home/abc/.bashrc`

## 使用

```bash
chmod +x setup.sh
./setup.sh