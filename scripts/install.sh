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

# 4. 安装 Skills（可选）
echo -e "${YELLOW}[4/5] 安装 Skills...${NC}"

read -p "是否安装推荐 Skills 包？（推荐）[Y/n] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    echo "正在克隆 farmage/opencode-skills..."

    # 检查是否有 git
    if ! command -v git &> /dev/null; then
        echo -e "${RED}✗ git 未安装，跳过 Skills 安装${NC}"
    else
        # 克隆 Skills 到临时目录
        TEMP_SKILLS=$(mktemp -d)
        git clone --depth 1 https://github.com/farmage/opencode-skills.git "$TEMP_SKILLS" 2>/dev/null || {
            echo -e "${RED}✗ 无法克隆 Skills 仓库${NC}"
            rm -rf "$TEMP_SKILLS"
        }

        if [ -d "$TEMP_SKILLS/skills" ]; then
            cp -r "$TEMP_SKILLS/skills/"* "$PROJECT_ROOT/.opencode/skills/"
            echo -e "${GREEN}✓ Skills 已安装到 .opencode/skills/${NC}"
        fi

        rm -rf "$TEMP_SKILLS"
    fi
fi

# 5. 显示完成信息
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  安装完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "后续步骤："
echo -e "  1. 编辑 AGENTS.md 中的项目信息"
echo -e "  2. 复制模板文件到你的项目："
echo -e "     - templates/PRD.md"
echo -e "     - templates/APP_FLOW.md"
echo -e "     - templates/TECH_STACK.md"
echo -e "     - 等等..."
echo -e "  3. 运行 opencode 开始开发"
echo ""
echo -e "更多信息请查看 README.md"
echo ""

exit 0