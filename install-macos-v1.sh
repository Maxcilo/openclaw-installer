#!/bin/bash
# OpenClaw 一键安装脚本 (macOS)
# 作者: @Go8888I
# 版本: 1.0.0

set -e

echo "🎀 OpenClaw 一键安装脚本 (macOS)"
echo "================================"
echo ""

# 检测系统
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ 此脚本仅支持 macOS 系统"
    echo "请使用 install-windows.ps1 (Windows) 或 install-linux.sh (Linux)"
    exit 1
fi

echo "✅ 检测到 macOS 系统"
echo ""

# 1. 检查并安装 Homebrew
echo "📦 步骤 1/5: 检查 Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "⏳ 正在安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 添加 Homebrew 到 PATH
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "✅ Homebrew 安装完成"
else
    echo "✅ Homebrew 已安装"
fi
echo ""

# 2. 安装 Node.js
echo "📦 步骤 2/5: 检查 Node.js..."
if ! command -v node &> /dev/null; then
    echo "⏳ 正在安装 Node.js..."
    brew install node
    echo "✅ Node.js 安装完成"
else
    NODE_VERSION=$(node -v)
    echo "✅ Node.js 已安装 ($NODE_VERSION)"
fi
echo ""

# 3. 安装 pnpm
echo "📦 步骤 3/5: 检查 pnpm..."
if ! command -v pnpm &> /dev/null; then
    echo "⏳ 正在安装 pnpm..."
    npm install -g pnpm
    echo "✅ pnpm 安装完成"
else
    PNPM_VERSION=$(pnpm -v)
    echo "✅ pnpm 已安装 ($PNPM_VERSION)"
fi
echo ""

# 4. 安装 OpenClaw
echo "📦 步骤 4/5: 安装 OpenClaw..."
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

# 5. 初始化配置
echo "📦 步骤 5/5: 初始化配置..."
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
echo "   - 如果命令未找到，请重启终端或运行: source ~/.zprofile"
echo "   - 需要配置 API 密钥，请参考官方文档"
echo ""
echo "🎀 安装脚本由 @Go8888I 制作"
echo ""
