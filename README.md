# OpenClaw 一键安装器

一键安装 OpenClaw 及其依赖环境，支持 Windows、macOS 和 Linux。

## 支持的系统

- ✅ Windows 10/11 (PowerShell)
- ✅ macOS (Bash)
- ✅ Linux (Bash)

## 功能特性

- 🚀 一键安装所有依赖
- 📦 自动安装 Node.js、pnpm
- 🔧 自动配置环境
- 📝 详细的安装日志
- ✅ 安装验证

## 快速开始

### Windows

1. **以管理员身份运行 PowerShell**
   - 右键点击 PowerShell
   - 选择"以管理员身份运行"

2. **允许执行脚本**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **运行安装脚本**
   ```powershell
   # 下载脚本
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Maxcilo/openclaw-installer/main/install-windows.ps1" -OutFile "install-windows.ps1"
   
   # 运行脚本
   .\install-windows.ps1
   ```

### macOS

1. **打开终端**

2. **运行安装脚本**
   ```bash
   # 下载并运行
   curl -fsSL https://raw.githubusercontent.com/Maxcilo/openclaw-installer/main/install-macos.sh | bash
   
   # 或者下载后运行
   curl -O https://raw.githubusercontent.com/Maxcilo/openclaw-installer/main/install-macos.sh
   chmod +x install-macos.sh
   ./install-macos.sh
   ```

### Linux

```bash
# 下载并运行
curl -fsSL https://raw.githubusercontent.com/Maxcilo/openclaw-installer/main/install-linux.sh | bash

# 或者下载后运行
curl -O https://raw.githubusercontent.com/Maxcilo/openclaw-installer/main/install-linux.sh
chmod +x install-linux.sh
./install-linux.sh
```

## 安装内容

### 1. Node.js
- Windows: 引导用户手动下载安装
- macOS: 通过 Homebrew 自动安装
- Linux: 通过包管理器自动安装

### 2. pnpm
- 通过 npm 全局安装

### 3. OpenClaw
- 通过 pnpm 全局安装

### 4. 配置目录
- `~/.openclaw/` - 主配置目录
- `~/.openclaw/workspace/` - 工作目录
- `~/.openclaw/extensions/` - 扩展目录

## 安装后

### 启动 Gateway

```bash
openclaw gateway start
```

### 检查状态

```bash
openclaw gateway status
```

### 查看帮助

```bash
openclaw --help
```

## 故障排查

### Windows

**问题：无法运行脚本**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**问题：命令未找到**
- 重启 PowerShell
- 检查环境变量 PATH

**问题：Windows Defender 拦截**
- 添加 OpenClaw 到信任列表

### macOS

**问题：Homebrew 安装失败**
- 检查网络连接
- 手动安装：https://brew.sh/

**问题：命令未找到**
```bash
source ~/.zprofile
```

### Linux

**问题：权限不足**
```bash
sudo ./install-linux.sh
```

**问题：包管理器不支持**
- 手动安装 Node.js：https://nodejs.org/

## 系统要求

- **Node.js:** >= 20.0.0
- **pnpm:** >= 8.0.0
- **磁盘空间:** >= 500 MB
- **内存:** >= 2 GB

## 卸载

### Windows
```powershell
pnpm uninstall -g openclaw
Remove-Item -Recurse -Force $env:USERPROFILE\.openclaw
```

### macOS/Linux
```bash
pnpm uninstall -g openclaw
rm -rf ~/.openclaw
```

## 更新

```bash
pnpm update -g openclaw
```

## 文档

- 官方文档: https://docs.openclaw.ai
- GitHub: https://github.com/openclaw/openclaw
- Discord: https://discord.com/invite/clawd

## 作者

[@Go8888I](https://twitter.com/Go8888I)

大富小姐姐 🎀

## 许可证

MIT License

## 更新日志

### v1.0.0 (2026-03-11)
- 初始版本
- 支持 Windows、macOS、Linux
- 自动安装所有依赖
- 详细的安装日志
