# OpenClaw 一键安装脚本 (Windows)
# 作者: @Go8888I
# 版本: 1.0.0

Write-Host "🎀 OpenClaw 一键安装脚本 (Windows)" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠️  警告: 建议以管理员身份运行此脚本" -ForegroundColor Yellow
    Write-Host "   右键点击 PowerShell -> 以管理员身份运行" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "是否继续? (y/n)"
    if ($continue -ne "y") {
        exit
    }
}

# 1. 检查并安装 Node.js
Write-Host "📦 步骤 1/4: 检查 Node.js..." -ForegroundColor Green
try {
    $nodeVersion = node -v
    Write-Host "✅ Node.js 已安装 ($nodeVersion)" -ForegroundColor Green
} catch {
    Write-Host "⏳ Node.js 未安装，正在下载安装程序..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "请按照以下步骤手动安装 Node.js:" -ForegroundColor Yellow
    Write-Host "1. 访问: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host "2. 下载 LTS 版本 (推荐)" -ForegroundColor Yellow
    Write-Host "3. 运行安装程序，使用默认设置" -ForegroundColor Yellow
    Write-Host "4. 安装完成后，重启 PowerShell" -ForegroundColor Yellow
    Write-Host "5. 重新运行此脚本" -ForegroundColor Yellow
    Write-Host ""
    
    # 尝试打开下载页面
    Start-Process "https://nodejs.org/"
    
    Write-Host "❌ 请先安装 Node.js，然后重新运行此脚本" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 2. 检查并安装 pnpm
Write-Host "📦 步骤 2/4: 检查 pnpm..." -ForegroundColor Green
try {
    $pnpmVersion = pnpm -v
    Write-Host "✅ pnpm 已安装 ($pnpmVersion)" -ForegroundColor Green
} catch {
    Write-Host "⏳ 正在安装 pnpm..." -ForegroundColor Yellow
    npm install -g pnpm
    
    # 检查安装
    try {
        $pnpmVersion = pnpm -v
        Write-Host "✅ pnpm 安装完成 ($pnpmVersion)" -ForegroundColor Green
    } catch {
        Write-Host "❌ pnpm 安装失败" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 3. 安装 OpenClaw
Write-Host "📦 步骤 3/4: 安装 OpenClaw..." -ForegroundColor Green
Write-Host "⏳ 正在安装 openclaw..." -ForegroundColor Yellow
pnpm install -g openclaw

# 检查安装
try {
    $openclawVersion = openclaw --version 2>$null
    if (-not $openclawVersion) {
        $openclawVersion = "unknown"
    }
    Write-Host "✅ OpenClaw 安装完成 ($openclawVersion)" -ForegroundColor Green
} catch {
    Write-Host "❌ OpenClaw 安装失败" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 4. 初始化配置
Write-Host "📦 步骤 4/4: 初始化配置..." -ForegroundColor Green
Write-Host "⏳ 创建配置目录..." -ForegroundColor Yellow

$openclawDir = "$env:USERPROFILE\.openclaw"
$workspaceDir = "$openclawDir\workspace"
$extensionsDir = "$openclawDir\extensions"

New-Item -ItemType Directory -Force -Path $openclawDir | Out-Null
New-Item -ItemType Directory -Force -Path $workspaceDir | Out-Null
New-Item -ItemType Directory -Force -Path $extensionsDir | Out-Null

Write-Host "✅ 配置目录创建完成" -ForegroundColor Green
Write-Host ""

# 显示安装信息
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "🎉 OpenClaw 安装完成！" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 安装位置：" -ForegroundColor White
Write-Host "   - OpenClaw: $(Get-Command openclaw -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)" -ForegroundColor Gray
Write-Host "   - 配置目录: $openclawDir" -ForegroundColor Gray
Write-Host "   - 工作目录: $workspaceDir" -ForegroundColor Gray
Write-Host ""
Write-Host "🚀 快速开始：" -ForegroundColor White
Write-Host "   1. 启动 Gateway:" -ForegroundColor Gray
Write-Host "      openclaw gateway start" -ForegroundColor Yellow
Write-Host ""
Write-Host "   2. 检查状态:" -ForegroundColor Gray
Write-Host "      openclaw gateway status" -ForegroundColor Yellow
Write-Host ""
Write-Host "   3. 查看帮助:" -ForegroundColor Gray
Write-Host "      openclaw --help" -ForegroundColor Yellow
Write-Host ""
Write-Host "📚 文档：" -ForegroundColor White
Write-Host "   - 官方文档: https://docs.openclaw.ai" -ForegroundColor Gray
Write-Host "   - GitHub: https://github.com/openclaw/openclaw" -ForegroundColor Gray
Write-Host "   - Discord: https://discord.com/invite/clawd" -ForegroundColor Gray
Write-Host ""
Write-Host "💡 提示：" -ForegroundColor White
Write-Host "   - 如果命令未找到，请重启 PowerShell" -ForegroundColor Gray
Write-Host "   - 需要配置 API 密钥，请参考官方文档" -ForegroundColor Gray
Write-Host "   - Windows Defender 可能会拦截，请添加信任" -ForegroundColor Gray
Write-Host ""
Write-Host "🎀 安装脚本由 @Go8888I 制作" -ForegroundColor Magenta
Write-Host ""

# 询问是否立即启动
$startNow = Read-Host "是否立即启动 OpenClaw Gateway? (y/n)"
if ($startNow -eq "y") {
    Write-Host ""
    Write-Host "⏳ 正在启动 OpenClaw Gateway..." -ForegroundColor Yellow
    openclaw gateway start
}
