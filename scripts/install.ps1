#========================================
# OpenCode 开发工作流 - 安装脚本
# 支持全局安装和项目级安装
# 适用于 Windows (PowerShell)
#========================================

param(
    [switch]$Global,
    [switch]$Project,
    [string]$Path,
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

# 获取脚本所在目录（源目录）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceRoot = Split-Path -Parent $ScriptDir

# 全局安装目录
$GlobalDir = Join-Path $HOME ".opencode"

# 显示帮助
function Show-Help {
    Write-Host "${Blue}OpenCode 开发工作流 - 安装脚本${NC}"
    Write-Host ""
    Write-Host "用法: .\install.ps1 [选项] [路径]"
    Write-Host ""
    Write-Host "选项:"
    Write-Host "  -Global         全局安装到 ~/.opencode/"
    Write-Host "  -Project        项目级安装到当前目录"
    Write-Host "  -Project -Path PATH  项目级安装到指定路径"
    Write-Host "  -Help           显示此帮助信息"
    Write-Host ""
    Write-Host "示例:"
    Write-Host "  .\install.ps1                         # 交互式选择"
    Write-Host "  .\install.ps1 -Global                 # 全局安装"
    Write-Host "  .\install.ps1 -Project                # 项目级安装到当前目录"
    Write-Host "  .\install.ps1 -Project -Path C:\myapp # 项目级安装到指定目录"
    Write-Host ""
}

# 检测是否为项目目录
function Test-ProjectDir {
    param([string]$dir)
    (Test-Path (Join-Path $dir "package.json")) -or
    (Test-Path (Join-Path $dir ".git")) -or
    (Test-Path (Join-Path $dir "Cargo.toml")) -or
    (Test-Path (Join-Path $dir "go.mod")) -or
    (Test-Path (Join-Path $dir "pyproject.toml"))
}

# 检测 OpenCode
function Test-OpenCode {
    $opencodePath = Get-Command opencode -ErrorAction SilentlyContinue
    if ($opencodePath) {
        Write-Host "${Green}✓ OpenCode 已安装${NC}"
        opencode --version
        return $true
    } else {
        Write-Host "${Yellow}⚠ OpenCode 未安装${NC}"
        Write-Host "请先安装 OpenCode: https://opencode.ai/"
        $continue = Read-Host "是否继续？（可能无法使用部分功能）[y/N]"
        if ($continue -ne "y" -and $continue -ne "Y") {
            exit 1
        }
        return $false
    }
}

# 安装核心函数
function Install-Workflow {
    param(
        [string]$TargetDir,
        [string]$InstallType  # "global" 或 "project"
    )

    Write-Host ""
    Write-Host "${Blue}========================================${NC}"
    if ($InstallType -eq "global") {
        Write-Host "${Blue}  全局安装${NC}"
        Write-Host "${Blue}  目标目录: $TargetDir${NC}"
    } else {
        Write-Host "${Blue}  项目级安装${NC}"
        Write-Host "${Blue}  目标目录: $TargetDir${NC}"
    }
    Write-Host "${Blue}========================================${NC}"
    Write-Host ""

    # 创建目录结构
    Write-Host "${Yellow}[1/5] 创建目录结构...${NC}"
    New-Item -ItemType Directory -Force -Path "$TargetDir\.opencode\skills" | Out-Null
    New-Item -ItemType Directory -Force -Path "$TargetDir\.opencode\commands" | Out-Null
    Write-Host "${Green}✓ 目录结构创建完成${NC}"

    # 复制配置模板
    Write-Host "${Yellow}[2/5] 复制配置模板...${NC}"
    $agentsTemplate = Join-Path $SourceRoot "config\AGENTS.md.template"
    if (Test-Path $agentsTemplate) {
        Copy-Item $agentsTemplate "$TargetDir\AGENTS.md" -Force
        Write-Host "${Green}✓ AGENTS.md 已创建${NC}"
    }
    $opencodeJsonTemplate = Join-Path $SourceRoot "config\opencode.json.template"
    if (Test-Path $opencodeJsonTemplate) {
        Copy-Item $opencodeJsonTemplate "$TargetDir\opencode.json" -Force
        Write-Host "${Green}✓ opencode.json 已创建${NC}"
    }

    # 初始化 progress.txt
    Write-Host "${Yellow}[3/5] 初始化进度跟踪文件...${NC}"
    $progressContent = @"
# 项目进度

## 已完成
-

## 进行中
- 项目初始化

## 待开始
- 需求分析
- 技术选型
- 功能开发

## 已知 Bug
-

## 上次会话总结
- 项目初始化完成，等待需求输入
"@
    Set-Content -Path "$TargetDir\progress.txt" -Value $progressContent -Encoding UTF8
    Write-Host "${Green}✓ progress.txt 已创建${NC}"

    # 安装 Skills
    Write-Host "${Yellow}[4/5] 安装核心 Skills...${NC}"
    $npxPath = Get-Command npx -ErrorAction SilentlyContinue
    if (-not $npxPath) {
        Write-Host "${Red}✗ npx 未安装，跳过 Skills 安装${NC}"
        Write-Host "${Yellow}请手动安装 Node.js 后重试${NC}"
    } else {
        Write-Host "正在安装核心 Skills..."
        $coreSkills = @(
            "spec-driven-development",
            "writing-plans",
            "incremental-implementation",
            "test-driven-development",
            "code-review-and-quality",
            "debugging-and-error-recovery",
            "context-engineering"
        )
        foreach ($skill in $coreSkills) {
            Write-Host "  安装 $skill..." -NoNewline
            try {
                npx skills add "https://github.com/addyosmani/agent-skills" --skill $skill 2>$null
                Write-Host " ${Green}✓${NC}"
            } catch {
                Write-Host " ${Red}✗${NC}"
            }
        }

        Write-Host ""
        $installEnhanced = Read-Host "是否安装增强 Skills？（前端、安全等）[Y/n]"
        if ($installEnhanced -eq "y" -or $installEnhanced -eq "Y" -or $installEnhanced -eq "") {
            $enhancedSkills = @("frontend-ui-engineering", "security-and-hardening")
            foreach ($skill in $enhancedSkills) {
                Write-Host "  安装 $skill..." -NoNewline
                try {
                    npx skills add "https://github.com/addyosmani/agent-skills" --skill $skill 2>$null
                    Write-Host " ${Green}✓${NC}"
                } catch {
                    Write-Host " ${Red}✗${NC}"
                }
            }
        }
        Write-Host "${Green}✓ Skills 安装完成${NC}"
    }

    # 复制自定义 Skills 和模板
    Write-Host "${Yellow}[5/5] 复制自定义内容...${NC}"
    $copyCustom = Read-Host "是否复制文档模板和自定义 Skills？[Y/n]"
    if ($copyCustom -eq "y" -or $copyCustom -eq "Y" -or $copyCustom -eq "") {
        # 文档模板
        $backendTemplate = Join-Path $SourceRoot "templates\BACKEND_STRUCTURE.md"
        if (Test-Path $backendTemplate) {
            Copy-Item $backendTemplate "$TargetDir\"
            Write-Host "${Green}✓ BACKEND_STRUCTURE.md${NC}"
        }
        $frontendTemplate = Join-Path $SourceRoot "templates\FRONTEND_GUIDELINES.md"
        if (Test-Path $frontendTemplate) {
            Copy-Item $frontendTemplate "$TargetDir\"
            Write-Host "${Green}✓ FRONTEND_GUIDELINES.md${NC}"
        }
        # 自定义 Skills
        $skillSelfUpdate = Join-Path $SourceRoot "skills-template\skill-self-update"
        if (Test-Path $skillSelfUpdate) {
            Copy-Item $skillSelfUpdate "$TargetDir\.opencode\skills\" -Recurse -Force
            Write-Host "${Green}✓ skill-self-update${NC}"
        }
        $skillRecommendation = Join-Path $SourceRoot "skills-template\skill-recommendation"
        if (Test-Path $skillRecommendation) {
            Copy-Item $skillRecommendation "$TargetDir\.opencode\skills\" -Recurse -Force
            Write-Host "${Green}✓ skill-recommendation${NC}"
        }
        $skillsConfig = Join-Path $SourceRoot "skills-template\skills-config.json"
        if (Test-Path $skillsConfig) {
            Copy-Item $skillsConfig "$TargetDir\.opencode\"
            Write-Host "${Green}✓ skills-config.json${NC}"
        }
    }

    # 保存安装信息
    $installInfo = @{
        install_type = $InstallType
        install_date = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
        source_version = "1.0.0"
    } | ConvertTo-Json
    Set-Content -Path "$TargetDir\.opencode\install-info.json" -Value $installInfo -Encoding UTF8

    Write-Host ""
    Write-Host "${Blue}========================================${NC}"
    Write-Host "${Green}  安装完成！${NC}"
    Write-Host "${Blue}========================================${NC}"
    Write-Host ""
    Write-Host "后续步骤："
    Write-Host "  1. 编辑 AGENTS.md 中的项目信息"
    Write-Host "  2. 运行 opencode 开始开发"
    Write-Host ""
    Write-Host "更多信息请查看 README.md"
    Write-Host ""
}

# 显示帮助
if ($Help) {
    Show-Help
    exit 0
}

# 主流程
Write-Host "${Blue}========================================${NC}"
Write-Host "${Blue}  OpenCode 开发工作流 - 安装程序${NC}"
Write-Host "${Blue}========================================${NC}"
Write-Host ""

Test-OpenCode

# 确定安装模式
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

# 如果没有指定模式，交互式选择
if (-not $InstallMode) {
    Write-Host ""
    Write-Host "${Cyan}请选择安装类型：${NC}"
    Write-Host ""
    Write-Host "  ${Green}1)${NC} 项目级安装（推荐）"
    Write-Host "     安装到当前目录或指定项目目录"
    Write-Host "     适合：单个项目使用"
    Write-Host ""
    Write-Host "  ${Blue}2)${NC} 全局安装"
    Write-Host "     安装到 ~/.opencode/"
    Write-Host "     适合：所有项目共享配置"
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

# 确认安装目录
Write-Host ""
Write-Host "${Cyan}安装目录: ${TargetDir}${NC}"
if ($InstallMode -eq "project" -and (Test-ProjectDir $TargetDir)) {
    Write-Host "${Green}✓ 检测到项目目录${NC}"
}
$confirm = Read-Host "确认安装？[Y/n]"
if ($confirm -ne "y" -and $confirm -ne "Y" -and $confirm -ne "") {
    exit 1
}

# 执行安装
Install-Workflow -TargetDir $TargetDir -InstallType $InstallMode