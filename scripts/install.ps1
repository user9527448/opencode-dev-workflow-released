#========================================
# OpenCode 开发工作流 - 安装脚本
# 适用于 Windows (PowerShell)
#========================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Green = "`e[0;32m"
$Yellow = "`e[1;33m"
$Blue = "`e[0;34m"
$Red = "`e[0;31m"
$NC = "`e[0m" # No Color

Write-Host ""
Write-Host "${Blue}========================================${NC}"
Write-Host "${Blue}  OpenCode 开发工作流 - 安装脚本${NC}"
Write-Host "${Blue}========================================${NC}"
Write-Host ""

# 检测 OpenCode
$opencodePath = Get-Command opencode -ErrorAction SilentlyContinue
if ($opencodePath) {
    Write-Host "${Green}✓ OpenCode 已安装${NC}"
    opencode --version
} else {
    Write-Host "${Yellow}⚠ OpenCode 未安装${NC}"
    Write-Host "请先安装 OpenCode: https://opencode.ai/"
    $continue = Read-Host "是否继续？（可能无法使用部分功能）[y/N]"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

# 获取当前脚本目录
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir

Write-Host "${Blue}项目目录: $ProjectRoot${NC}"
Write-Host ""

# 1. 创建目录结构
Write-Host "${Yellow}[1/5] 创建项目目录结构...${NC}"

New-Item -ItemType Directory -Force -Path "$ProjectRoot\.opencode\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$ProjectRoot\.opencode\commands" | Out-Null

Write-Host "${Green}✓ 目录结构创建完成${NC}"

# 2. 复制配置模板
Write-Host "${Yellow}[2/5] 复制配置模板...${NC}"

$agentsTemplate = "$ProjectRoot\config\AGENTS.md.template"
if (Test-Path $agentsTemplate) {
    Copy-Item $agentsTemplate "$ProjectRoot\AGENTS.md" -Force
    Write-Host "${Green}✓ AGENTS.md 已创建${NC}"
}

$opencodeJsonTemplate = "$ProjectRoot\config\opencode.json.template"
if (Test-Path $opencodeJsonTemplate) {
    Copy-Item $opencodeJsonTemplate "$ProjectRoot\opencode.json" -Force
    Write-Host "${Green}✓ opencode.json 已创建${NC}"
}

# 3. 初始化 progress.txt
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

Set-Content -Path "$ProjectRoot\progress.txt" -Value $progressContent -Encoding UTF8

Write-Host "${Green}✓ progress.txt 已创建${NC}"

# 4. 安装 Skills
Write-Host "${Yellow}[4/6] 安装核心 Skills (addyosmani/agent-skills)...${NC}"

# 检查 npx
$npxPath = Get-Command npx -ErrorAction SilentlyContinue
if (-not $npxPath) {
    Write-Host "${Red}✗ npx 未安装，跳过 Skills 安装${NC}"
    Write-Host "${Yellow}请手动安装 Node.js 后重试${NC}"
} else {
    Write-Host "正在安装核心 Skills..."

    # 核心 Skills 列表
    $coreSkills = @(
        "spec-driven-development",
        "writing-plans",
        "incremental-implementation",
        "test-driven-development",
        "code-review-and-quality",
        "debugging-and-error-recovery",
        "context-engineering"
    )

    # 增强 Skills 列表
    $enhancedSkills = @(
        "frontend-ui-engineering",
        "security-and-hardening"
    )

    # 安装核心 Skills
    Write-Host "${Blue}安装核心 Skills...${NC}"
    foreach ($skill in $coreSkills) {
        Write-Host "  安装 $skill..." -NoNewline
        try {
            npx skills add "https://github.com/addyosmani/agent-skills" --skill $skill 2>$null
            Write-Host " ${Green}✓${NC}"
        } catch {
            Write-Host " ${Red}✗${NC}"
        }
    }

    # 询问是否安装增强 Skills
    Write-Host ""
    $installEnhanced = Read-Host "是否安装增强 Skills？（前端、安全等）[Y/n]"
    if ($installEnhanced -eq "y" -or $installEnhanced -eq "Y" -or $installEnhanced -eq "") {
        Write-Host "${Blue}安装增强 Skills...${NC}"
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

# 5. 复制文档模板（可选）
Write-Host "${Yellow}[5/6] 复制文档模板...${NC}"

$copyTemplates = Read-Host "是否复制文档模板到项目？（BACKEND_STRUCTURE.md, FRONTEND_GUIDELINES.md）[Y/n]"
if ($copyTemplates -eq "y" -or $copyTemplates -eq "Y" -or $copyTemplates -eq "") {
    # 复制保留的模板文件
    if (Test-Path "$ProjectRoot\templates\BACKEND_STRUCTURE.md") {
        Copy-Item "$ProjectRoot\templates\BACKEND_STRUCTURE.md" "$ProjectRoot\"
        Write-Host "${Green}✓ BACKEND_STRUCTURE.md 已创建${NC}"
    }

    if (Test-Path "$ProjectRoot\templates\FRONTEND_GUIDELINES.md") {
        Copy-Item "$ProjectRoot\templates\FRONTEND_GUIDELINES.md" "$ProjectRoot\"
        Write-Host "${Green}✓ FRONTEND_GUIDELINES.md 已创建${NC}"
    }
}

# 6. 复制自定义 Skills
Write-Host "${Yellow}[6/6] 复制自定义 Skills...${NC}"

$copyCustom = Read-Host "是否复制自定义 Skills 到项目？[Y/n]"
if ($copyCustom -eq "y" -or $copyCustom -eq "Y" -or $copyCustom -eq "") {
    # 复制 skill-self-update
    if (Test-Path "$ProjectRoot\skills-template\skill-self-update") {
        Copy-Item "$ProjectRoot\skills-template\skill-self-update" "$ProjectRoot\.opencode\skills\" -Recurse -Force
        Write-Host "${Green}✓ skill-self-update 已安装${NC}"
    }

    # 复制 skill-recommendation
    if (Test-Path "$ProjectRoot\skills-template\skill-recommendation") {
        Copy-Item "$ProjectRoot\skills-template\skill-recommendation" "$ProjectRoot\.opencode\skills\" -Recurse -Force
        Write-Host "${Green}✓ skill-recommendation 已安装${NC}"
    }

    # 复制 skills-config.json
    if (Test-Path "$ProjectRoot\skills-template\skills-config.json") {
        Copy-Item "$ProjectRoot\skills-template\skills-config.json" "$ProjectRoot\.opencode\"
        Write-Host "${Green}✓ skills-config.json 已创建${NC}"
    }
}

# 7. 完成
Write-Host ""
Write-Host "${Blue}========================================${NC}"
Write-Host "${Blue}  安装完成！${NC}"
Write-Host "${Blue}========================================${NC}"
Write-Host ""
Write-Host "后续步骤："
Write-Host "  1. 编辑 AGENTS.md 中的项目信息"
Write-Host "  2. 如需手动文档，编辑 BACKEND_STRUCTURE.md 或 FRONTEND_GUIDELINES.md"
Write-Host "  3. 运行 opencode 开始开发"
Write-Host ""
Write-Host "更多信息请查看 README.md"
Write-Host ""

exit 0