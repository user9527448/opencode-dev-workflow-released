#========================================
# OpenCode 开发工作流 - 卸载脚本
# 支持全局卸载和项目级卸载
# 适用于 Windows (PowerShell)
#========================================

param(
    [switch]$Global,
    [switch]$Project,
    [string]$Path,
    [switch]$KeepData,
    [switch]$Help
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 颜色定义
$Green = "`e[0;32m"
$Yellow = "`e[1;33m"
$Blue = "`e[0;34m"
$Red = "`e[0;31m"
$Cyan = "`e[0;36m"
$NC = "`e[0m"

# 全局安装目录
$GlobalDir = Join-Path $HOME ".opencode"

# 显示帮助
function Show-Help {
    Write-Host "${Blue}OpenCode 开发工作流 - 卸载脚本${NC}"
    Write-Host ""
    Write-Host "用法: .\uninstall.ps1 [选项] [路径]"
    Write-Host ""
    Write-Host "选项:"
    Write-Host "  -Global         卸载全局安装 (~/.opencode/)"
    Write-Host "  -Project        卸载当前目录的项目级安装"
    Write-Host "  -Project -Path PATH  卸载指定路径的项目级安装"
    Write-Host "  -KeepData       保留用户数据 (progress.txt, lessons.md)"
    Write-Host "  -Help           显示此帮助信息"
    Write-Host ""
}

# 检测安装类型
function Get-InstallType {
    param([string]$dir)
    $infoFile = Join-Path $dir ".opencode\install-info.json"
    if (Test-Path $infoFile) {
        $info = Get-Content $infoFile | ConvertFrom-Json
        return $info.install_type
    }
    return "unknown"
}

# 卸载核心函数
function Uninstall-Workflow {
    param(
        [string]$TargetDir,
        [bool]$KeepUserData
    )

    Write-Host ""
    Write-Host "${Blue}========================================${NC}"
    Write-Host "${Blue}  卸载 OpenCode 开发工作流${NC}"
    Write-Host "${Blue}  目标目录: $TargetDir${NC}"
    Write-Host "${Blue}========================================${NC}"
    Write-Host ""

    # 检测是否已安装
    $opencodeDir = Join-Path $TargetDir ".opencode"
    if (-not (Test-Path $opencodeDir)) {
        Write-Host "${Yellow}⚠ 未检测到安装，退出${NC}"
        exit 0
    }

    # 显示将要删除的内容
    Write-Host "${Yellow}将要删除以下内容：${NC}"
    Write-Host "  - $TargetDir\AGENTS.md"
    Write-Host "  - $TargetDir\opencode.json"
    Write-Host "  - $TargetDir\.opencode\"
    if (-not $KeepUserData) {
        Write-Host "  - $TargetDir\progress.txt"
        Write-Host "  - $TargetDir\lessons.md"
    } else {
        Write-Host "  ${Green}(保留 progress.txt, lessons.md)${NC}"
    }
    Write-Host ""

    $confirm = Read-Host "确认卸载？[y/N]"
    if ($confirm -ne "y" -and $confirm -ne "Y") {
        exit 1
    }

    # 执行卸载
    Write-Host "${Yellow}正在卸载...${NC}"

    # 删除配置文件
    $agentsMd = Join-Path $TargetDir "AGENTS.md"
    if (Test-Path $agentsMd) {
        Remove-Item $agentsMd -Force
        Write-Host "${Green}✓ 删除 AGENTS.md${NC}"
    }
    $opencodeJson = Join-Path $TargetDir "opencode.json"
    if (Test-Path $opencodeJson) {
        Remove-Item $opencodeJson -Force
        Write-Host "${Green}✓ 删除 opencode.json${NC}"
    }

    # 删除文档模板
    $backendStructure = Join-Path $TargetDir "BACKEND_STRUCTURE.md"
    if (Test-Path $backendStructure) {
        Remove-Item $backendStructure -Force
        Write-Host "${Green}✓ 删除 BACKEND_STRUCTURE.md${NC}"
    }
    $frontendGuidelines = Join-Path $TargetDir "FRONTEND_GUIDELINES.md"
    if (Test-Path $frontendGuidelines) {
        Remove-Item $frontendGuidelines -Force
        Write-Host "${Green}✓ 删除 FRONTEND_GUIDELINES.md${NC}"
    }

    # 删除用户数据（如果未保留）
    if (-not $KeepUserData) {
        $progressTxt = Join-Path $TargetDir "progress.txt"
        if (Test-Path $progressTxt) {
            Remove-Item $progressTxt -Force
            Write-Host "${Green}✓ 删除 progress.txt${NC}"
        }
        $lessonsMd = Join-Path $TargetDir "lessons.md"
        if (Test-Path $lessonsMd) {
            Remove-Item $lessonsMd -Force
            Write-Host "${Green}✓ 删除 lessons.md${NC}"
        }
    }

    # 删除 .opencode 目录
    if (Test-Path $opencodeDir) {
        Remove-Item $opencodeDir -Recurse -Force
        Write-Host "${Green}✓ 删除 .opencode\${NC}"
    }

    Write-Host ""
    Write-Host "${Green}========================================${NC}"
    Write-Host "${Green}  卸载完成！${NC}"
    Write-Host "${Green}========================================${NC}"
    Write-Host ""
}

# 显示帮助
if ($Help) {
    Show-Help
    exit 0
}

# 主流程
Write-Host "${Blue}========================================${NC}"
Write-Host "${Blue}  OpenCode 开发工作流 - 卸载程序${NC}"
Write-Host "${Blue}========================================${NC}"
Write-Host ""

# 确定卸载模式
$InstallMode = ""
$TargetDir = ""

if ($Global) {
    $InstallMode = "global"
    $TargetDir = $GlobalDir
} elseif ($Project) {
    $InstallMode = "project"
    if ($Path) {
        $TargetDir = $Path
    } else {
        $TargetDir = Get-Location
    }
}

# 如果没有指定模式，尝试自动检测
if (-not $InstallMode) {
    # 先检查当前目录
    $currentDirInfo = Join-Path (Get-Location) ".opencode\install-info.json"
    if (Test-Path $currentDirInfo) {
        $InstallMode = Get-InstallType (Get-Location)
        $TargetDir = Get-Location
    }
    # 再检查全局目录
    elseif (Test-Path (Join-Path $GlobalDir ".opencode\install-info.json")) {
        $InstallMode = "global"
        $TargetDir = $GlobalDir
    }
    else {
        Write-Host "${Yellow}未检测到安装，请指定卸载目标${NC}"
        Write-Host ""
        Write-Host "${Cyan}请选择卸载目标：${NC}"
        Write-Host ""
        Write-Host "  ${Green}1)${NC} 卸载当前目录的项目级安装"
        Write-Host "  ${Blue}2)${NC} 卸载全局安装 (~/.opencode/)"
        Write-Host ""
        $choice = Read-Host "请选择 [1/2]"
        switch ($choice) {
            "1" {
                $InstallMode = "project"
                $TargetDir = Get-Location
            }
            "2" {
                $InstallMode = "global"
                $TargetDir = $GlobalDir
            }
            default {
                Write-Host "${Red}无效选择，退出${NC}"
                exit 1
            }
        }
    }
}

# 确认卸载目录
Write-Host ""
Write-Host "${Cyan}卸载目录: ${TargetDir}${NC}"
Write-Host "${Cyan}安装类型: ${InstallMode}${NC}"
Write-Host ""

# 询问是否保留数据
$KeepUserData = $KeepData
if (-not $KeepUserData) {
    $keepDataChoice = Read-Host "是否保留用户数据（progress.txt, lessons.md）？[Y/n]"
    if ($keepDataChoice -eq "y" -or $keepDataChoice -eq "Y" -or $keepDataChoice -eq "") {
        $KeepUserData = $true
    }
}

# 执行卸载
Uninstall-Workflow -TargetDir $TargetDir -KeepUserData $KeepUserData