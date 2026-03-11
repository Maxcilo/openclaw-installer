#!/bin/bash
# OpenClaw 一键安装脚本 (Linux)
# 作者: @Go8888I
# 版本: 1.0.0

set -e

echo "🎀 OpenClaw 一键安装脚本 (Linux)"
echo "================================"
echo ""

# 检测系统
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "❌ 此脚本仅支持 Linux 系统"
    echo "请使用 install-windows.ps1 (Windows) 或 install-macos.sh (macOS)"
    exit 1
fi

echo "✅ 检测到 Linux 系统"
echo ""

# 检测发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
    echo "📋 系统信息: $OS $VER"
else
    echo "⚠️  无法检测系统版本"
    OS="Unknown"
fi
echo ""

# 1. 安装 Node.js
echo "📦 步骤 1/4: 检查 Node.js..."
if ! command -v node &> /dev/null; then
    echo "⏳ 正在安装 Node.js..."
    
    # 检测包管理器
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        echo "📦 使用 apt-get 安装..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        echo "📦 使用 yum 安装..."
        curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
        sudo yum install -y nodejs
    elif command -v dnf &> /dev/null; then
        # Fedora
        echo "📦 使用 dnf 安装..."
        curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
        sudo dnf install -y nodejs
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "📦 使用 pacman 安装..."
        sudo pacman -S --noconfirm nodejs npm
    else
        echo "❌ 未检测到支持的包管理器"
        echo "请手动安装 Node.js: https://nodejs.org/"
        exit 1
    fi
    
    echo "✅ Node.js 安装完成"
else
    NODE_VERSION=$(node -v)
    echo "✅ Node.js 已安装 ($NODE_VERSION)"
fi
echo ""

# 2. 安装 pnpm
echo "📦 步骤 2/4: 检查 pnpm..."
if ! command -v pnpm &> /dev/null; then
    echo "⏳ 正在安装 pnpm..."
    npm install -g pnpm
    echo "✅ pnpm 安装完成"
else
    PNPM_VERSION=$(pnpm -v)
    echo "✅ pnpm 已安装 ($PNPM_VERSION)"
fi
echo ""

# 3. 安装 OpenClaw
echo "📦 步骤 3/4: 安装 OpenClaw..."
echo "⏳ 正在安装 openclaw..."
pnpm install -g openclaw

# 检查安装
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>/dev/null || echo "unknown")
    echo "✅ OpenClaw 安装完成 ($OPENCLAW_VERSION)"
else
    echo "❌ OpenClaw 安装失败"
    exit 1
fi
echo ""

# 4. 初始化配置
echo "📦 步骤 4/4: 初始化配置..."
echo "⏳ 创建配置目录..."
mkdir -p ~/.openclaw/workspace
mkdir -p ~/.openclaw/extensions

echo "✅ 配置目录创建完成"
echo ""

# 显示安装信息
echo "================================"
echo "🎉 OpenClaw 安装完成！"
echo "================================"
echo ""
echo "📍 安装位置："
echo "   - OpenClaw: $(which openclaw)"
echo "   - 配置目录: ~/.openclaw/"
echo "   - 工作目录: ~/.openclaw/workspace/"
echo ""
echo "🚀 快速开始："
echo "   1. 启动 Gateway:"
echo "      openclaw gateway start"
echo ""
echo "   2. 检查状态:"
echo "      openclaw gateway status"
echo ""
echo "   3. 查看帮助:"
echo "      openclaw --help"
echo ""
echo "📚 文档："
echo "   - 官方文档: https://docs.openclaw.ai"
echo "   - GitHub: https://github.com/openclaw/openclaw"
echo "   - Discord: https://discord.com/invite/clawd"
echo ""
echo "💡 提示："
echo "   - 如果命令未找到，请重启终端或运行: source ~/.bashrc"
echo "   - 需要配置 API 密钥，请参考官方文档"
echo ""
echo "🎀 安装脚本由 @Go8888I 制作"
echo ""
