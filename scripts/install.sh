#!/bin/bash

#========================================
# OpenCode 开发工作流 - 安装脚本
# 适用于 Linux / macOS
#========================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OpenCode 开发工作流 - 安装脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检测 OpenCode 是否已安装
if command -v opencode &> /dev/null; then
    echo -e "${GREEN}✓ OpenCode 已安装${NC}"
    opencode --version
else
    echo -e "${YELLOW}⚠ OpenCode 未安装${NC}"
    echo "请先安装 OpenCode: https://opencode.ai/"
    read -p "是否继续？（可能无法使用部分功能）[y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 获取当前目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}项目目录: $PROJECT_ROOT${NC}"
echo ""

# 1. 创建项目目录结构
echo -e "${YELLOW}[1/5] 创建项目目录结构...${NC}"

mkdir -p "$PROJECT_ROOT/.opencode/skills"
mkdir -p "$PROJECT_ROOT/.opencode/commands"

echo -e "${GREEN}✓ 目录结构创建完成${NC}"

# 2. 复制配置模板
echo -e "${YELLOW}[2/5] 复制配置模板...${NC}"

# AGENTS.md
if [ -f "$PROJECT_ROOT/config/AGENTS.md.template" ]; then
    cp "$PROJECT_ROOT/config/AGENTS.md.template" "$PROJECT_ROOT/AGENTS.md"
    echo -e "${GREEN}✓ AGENTS.md 已创建${NC}"
fi

# opencode.json
if [ -f "$PROJECT_ROOT/config/opencode.json.template" ]; then
    cp "$PROJECT_ROOT/config/opencode.json.template" "$PROJECT_ROOT/opencode.json"
    echo -e "${GREEN}✓ opencode.json 已创建${NC}"
fi

# 3. 初始化 progress.txt
echo -e "${YELLOW}[3/5] 初始化进度跟踪文件...${NC}"

cat > "$PROJECT_ROOT/progress.txt" << 'EOF'
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
EOF

echo -e "${GREEN}✓ progress.txt 已创建${NC}"

# 4. 安装 Skills
echo -e "${YELLOW}[4/6] 安装核心 Skills (addyosmani/agent-skills)...${NC}"

# 检查 npx 是否可用
if ! command -v npx &> /dev/null; then
    echo -e "${RED}✗ npx 未安装，跳过 Skills 安装${NC}"
    echo -e "${YELLOW}请手动安装 Node.js 后重试${NC}"
else
    echo "正在安装核心 Skills..."

    # 核心 Skills 列表
    CORE_SKILLS=(
        "spec-driven-development"
        "writing-plans"
        "incremental-implementation"
        "test-driven-development"
        "code-review-and-quality"
        "debugging-and-error-recovery"
        "context-engineering"
    )

    # 增强 Skills 列表
    ENHANCED_SKILLS=(
        "frontend-ui-engineering"
        "security-and-hardening"
    )

    # 安装核心 Skills
    echo -e "${BLUE}安装核心 Skills...${NC}"
    for skill in "${CORE_SKILLS[@]}"; do
        echo -n "  安装 $skill..."
        if npx skills add "https://github.com/addyosmani/agent-skills" --skill "$skill" 2>/dev/null; then
            echo -e " ${GREEN}✓${NC}"
        else
            echo -e " ${RED}✗${NC}"
        fi
    done

    # 询问是否安装增强 Skills
    echo ""
    read -p "是否安装增强 Skills？（前端、安全等）[Y/n] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        echo -e "${BLUE}安装增强 Skills...${NC}"
        for skill in "${ENHANCED_SKILLS[@]}"; do
            echo -n "  安装 $skill..."
            if npx skills add "https://github.com/addyosmani/agent-skills" --skill "$skill" 2>/dev/null; then
                echo -e " ${GREEN}✓${NC}"
            else
                echo -e " ${RED}✗${NC}"
            fi
        done
    fi

    echo -e "${GREEN}✓ Skills 安装完成${NC}"
fi

# 5. 复制文档模板（可选）
echo -e "${YELLOW}[5/6] 复制文档模板...${NC}"

read -p "是否复制文档模板到项目？（BACKEND_STRUCTURE.md, FRONTEND_GUIDELINES.md）[Y/n] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    # 复制保留的模板文件
    if [ -f "$PROJECT_ROOT/templates/BACKEND_STRUCTURE.md" ]; then
        cp "$PROJECT_ROOT/templates/BACKEND_STRUCTURE.md" "$PROJECT_ROOT/"
        echo -e "${GREEN}✓ BACKEND_STRUCTURE.md 已创建${NC}"
    fi

    if [ -f "$PROJECT_ROOT/templates/FRONTEND_GUIDELINES.md" ]; then
        cp "$PROJECT_ROOT/templates/FRONTEND_GUIDELINES.md" "$PROJECT_ROOT/"
        echo -e "${GREEN}✓ FRONTEND_GUIDELINES.md 已创建${NC}"
    fi
fi

# 6. 复制自定义 Skills
echo -e "${YELLOW}[6/6] 复制自定义 Skills...${NC}"

read -p "是否复制自定义 Skills 到项目？[Y/n] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    # 复制 skill-self-update
    if [ -d "$PROJECT_ROOT/skills-template/skill-self-update" ]; then
        cp -r "$PROJECT_ROOT/skills-template/skill-self-update" "$PROJECT_ROOT/.opencode/skills/"
        echo -e "${GREEN}✓ skill-self-update 已安装${NC}"
    fi

    # 复制 skill-recommendation
    if [ -d "$PROJECT_ROOT/skills-template/skill-recommendation" ]; then
        cp -r "$PROJECT_ROOT/skills-template/skill-recommendation" "$PROJECT_ROOT/.opencode/skills/"
        echo -e "${GREEN}✓ skill-recommendation 已安装${NC}"
    fi

    # 复制 skills-config.json
    if [ -f "$PROJECT_ROOT/skills-template/skills-config.json" ]; then
        cp "$PROJECT_ROOT/skills-template/skills-config.json" "$PROJECT_ROOT/.opencode/"
        echo -e "${GREEN}✓ skills-config.json 已创建${NC}"
    fi
fi

# 7. 显示完成信息
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  安装完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "后续步骤："
echo -e "  1. 编辑 AGENTS.md 中的项目信息"
echo -e "  2. 如需手动文档，编辑 BACKEND_STRUCTURE.md 或 FRONTEND_GUIDELINES.md"
echo -e "  3. 运行 opencode 开始开发"
echo ""
echo -e "更多信息请查看 README.md"
echo ""

exit 0