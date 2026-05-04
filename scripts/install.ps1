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
Write-Host "${Yellow}[4/5] 安装 Skills...${NC}"

$installSkills = Read-Host "是否安装推荐 Skills 包？（推荐）[Y/n]"
if ($installSkills -eq "y" -or $installSkills -eq "Y" -or $installSkills -eq "") {

    # 检查 git
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitPath) {
        Write-Host "${Red}✗ git 未安装，跳过 Skills 安装${NC}"
    } else {
        Write-Host "正在克隆 farmage/opencode-skills..."

        $tempDir = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString())
        New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

        try {
            git clone --depth 1 https://github.com/farmage/opencode-skills.git $tempDir 2>$null

            if (Test-Path "$tempDir\skills") {
                Copy-Item "$tempDir\skills\*" "$ProjectRoot\.opencode\skills\" -Recurse -Force
                Write-Host "${Green}✓ Skills 已安装到 .opencode/skills/${NC}"
            }
        } catch {
            Write-Host "${Red}✗ 无法克隆 Skills 仓库${NC}"
        }

        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 5. 完成
Write-Host ""
Write-Host "${Blue}========================================${NC}"
Write-Host "${Blue}  安装完成！${NC}"
Write-Host "${Blue}========================================${NC}"
Write-Host ""
Write-Host "后续步骤："
Write-Host "  1. 编辑 AGENTS.md 中的项目信息"
Write-Host "  2. 复制模板文件到你的项目："
Write-Host "     - templates/PRD.md"
Write-Host "     - templates/APP_FLOW.md"
Write-Host "     - templates/TECH_STACK.md"
Write-Host "     - 等等..."
Write-Host "  3. 运行 opencode 开始开发"
Write-Host ""
Write-Host "更多信息请查看 README.md"
Write-Host ""

exit 0