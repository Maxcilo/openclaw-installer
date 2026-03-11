# OpenClaw 一键安装脚本 (Windows) - 改进版
# 作者: @Go8888I
# 版本: 1.1.0

# 设置错误处理
$ErrorActionPreference = "Stop"

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

# 检查网络连接
Write-Host "🌐 检查网络连接..." -ForegroundColor Green
try {
    $null = Test-Connection -ComputerName nodejs.org -Count 1 -Quiet
    Write-Host "✅ 网络连接正常" -ForegroundColor Green
} catch {
    Write-Host "❌ 网络连接失败，请检查网络后重试" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 1. 检查并安装 Node.js
Write-Host "📦 步骤 1/4: 检查 Node.js..." -ForegroundColor Green
try {
    $nodeVersion = node -v
    $nodeMajor = [int]($nodeVersion -replace 'v(\d+)\..*', '$1')
    
    if ($nodeMajor -lt 20) {
        Write-Host "⚠️  Node.js 版本过低 ($nodeVersion)，需要 >= 20.0.0" -ForegroundColor Yellow
        Write-Host "请手动升级 Node.js" -ForegroundColor Yellow
        Start-Process "https://nodejs.org/"
        exit 1
    }
    
    Write-Host "✅ Node.js 已安装 ($nodeVersion)" -ForegroundColor Green
} catch {
    Write-Host "⏳ Node.js 未安装" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "正在尝试自动下载 Node.js 安装程序..." -ForegroundColor Yellow
    
    # 检测系统架构
    $arch = if ([Environment]::Is64BitOperatingSystem) { "x64" } else { "x86" }
    $nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-$arch.msi"
    $installerPath = "$env:TEMP\node-installer.msi"
    
    try {
        Write-Host "⏳ 正在下载 Node.js..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $nodeUrl -OutFile $installerPath -UseBasicParsing
        
        Write-Host "⏳ 正在安装 Node.js..." -ForegroundColor Yellow
        Write-Host "   (请在安装向导中点击 '下一步' 完成安装)" -ForegroundColor Yellow
        Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qb" -Wait
        
        # 刷新环境变量
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # 验证安装
        try {
            $nodeVersion = node -v
            Write-Host "✅ Node.js 安装完成 ($nodeVersion)" -ForegroundColor Green
            
            # 清理安装文件
            Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        } catch {
            Write-Host "❌ Node.js 安装失败，请重启 PowerShell 后重试" -ForegroundColor Red
            Write-Host "   或手动安装: https://nodejs.org/" -ForegroundColor Yellow
            exit 1
        }
    } catch {
        Write-Host "❌ 自动安装失败" -ForegroundColor Red
        Write-Host ""
        Write-Host "请手动安装 Node.js:" -ForegroundColor Yellow
        Write-Host "1. 访问: https://nodejs.org/" -ForegroundColor Yellow
        Write-Host "2. 下载 LTS 版本 (推荐)" -ForegroundColor Yellow
        Write-Host "3. 运行安装程序，使用默认设置" -ForegroundColor Yellow
        Write-Host "4. 安装完成后，重启 PowerShell" -ForegroundColor Yellow
        Write-Host "5. 重新运行此脚本" -ForegroundColor Yellow
        
        Start-Process "https://nodejs.org/"
        exit 1
    }
}
Write-Host ""

# 2. 检查并安装 pnpm
Write-Host "📦 步骤 2/4: 检查 pnpm..." -ForegroundColor Green
try {
    $pnpmVersion = pnpm -v
    Write-Host "✅ pnpm 已安装 ($pnpmVersion)" -ForegroundColor Green
} catch {
    Write-Host "⏳ 正在安装 pnpm..." -ForegroundColor Yellow
    
    try {
        npm install -g pnpm
        
        # 刷新环境变量
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        # 验证安装
        $pnpmVersion = pnpm -v
        Write-Host "✅ pnpm 安装完成 ($pnpmVersion)" -ForegroundColor Green
    } catch {
        Write-Host "❌ pnpm 安装失败" -ForegroundColor Red
        Write-Host "   错误信息: $_" -ForegroundColor Red
        exit 1
    }
}
Write-Host ""

# 3. 安装 OpenClaw
Write-Host "📦 步骤 3/4: 安装 OpenClaw..." -ForegroundColor Green
Write-Host "⏳ 正在安装 openclaw..." -ForegroundColor Yellow

try {
    pnpm install -g openclaw
    
    # 刷新环境变量
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    
    # 验证安装
    try {
        $openclawVersion = openclaw --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ OpenClaw 安装完成 ($openclawVersion)" -ForegroundColor Green
        } else {
            throw "命令执行失败"
        }
    } catch {
        Write-Host "❌ OpenClaw 安装失败：命令未找到" -ForegroundColor Red
        Write-Host "   请尝试重启 PowerShell 后运行: openclaw --version" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ OpenClaw 安装失败" -ForegroundColor Red
    Write-Host "   错误信息: $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 4. 初始化配置
Write-Host "📦 步骤 4/4: 初始化配置..." -ForegroundColor Green
Write-Host "⏳ 创建配置目录..." -ForegroundColor Yellow

$openclawDir = "$env:USERPROFILE\.openclaw"
$workspaceDir = "$openclawDir\workspace"
$extensionsDir = "$openclawDir\extensions"

try {
    New-Item -ItemType Directory -Force -Path $openclawDir | Out-Null
    New-Item -ItemType Directory -Force -Path $workspaceDir | Out-Null
    New-Item -ItemType Directory -Force -Path $extensionsDir | Out-Null
    Write-Host "✅ 配置目录创建完成" -ForegroundColor Green
} catch {
    Write-Host "❌ 配置目录创建失败" -ForegroundColor Red
    Write-Host "   错误信息: $_" -ForegroundColor Red
}
Write-Host ""

# 显示安装信息
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "🎉 OpenClaw 安装完成！" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📍 安装位置：" -ForegroundColor White
$openclawPath = Get-Command openclaw -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
if ($openclawPath) {
    Write-Host "   - OpenClaw: $openclawPath" -ForegroundColor Gray
} else {
    Write-Host "   - OpenClaw: (请重启 PowerShell 后可用)" -ForegroundColor Yellow
}
Write-Host "   - Node.js: $(Get-Command node | Select-Object -ExpandProperty Source) ($nodeVersion)" -ForegroundColor Gray
Write-Host "   - pnpm: $(Get-Command pnpm | Select-Object -ExpandProperty Source) ($pnpmVersion)" -ForegroundColor Gray
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
Write-Host "   - 国内用户建议配置 npm 镜像: npm config set registry https://registry.npmmirror.com" -ForegroundColor Gray
Write-Host ""
Write-Host "🎀 安装脚本由 @Go8888I 制作" -ForegroundColor Magenta
Write-Host ""

# 询问是否立即启动
$startNow = Read-Host "是否立即启动 OpenClaw Gateway? (y/n)"
if ($startNow -eq "y") {
    Write-Host ""
    Write-Host "⏳ 正在启动 OpenClaw Gateway..." -ForegroundColor Yellow
    try {
        openclaw gateway start
    } catch {
        Write-Host "❌ 启动失败，请重启 PowerShell 后手动运行: openclaw gateway start" -ForegroundColor Red
    }
}
