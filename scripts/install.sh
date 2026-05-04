#!/bin/bash

#========================================
# OpenCode 开发工作流 - 安装脚本
# 支持全局安装和项目级安装
#========================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 获取脚本所在目录（源目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(dirname "$SCRIPT_DIR")"

# 全局安装目录
GLOBAL_DIR="$HOME/.opencode"

# 显示帮助
show_help() {
    echo -e "${BLUE}OpenCode 开发工作流 - 安装脚本${NC}"
    echo ""
    echo "用法: ./install.sh [选项] [路径]"
    echo ""
    echo "选项:"
    echo "  --global        全局安装到 ~/.opencode/"
    echo "  --project       项目级安装到当前目录"
    echo "  --project PATH  项目级安装到指定路径"
    echo "  --help          显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  ./install.sh                    # 交互式选择"
    echo "  ./install.sh --global           # 全局安装"
    echo "  ./install.sh --project          # 项目级安装到当前目录"
    echo "  ./install.sh --project ~/myapp  # 项目级安装到指定目录"
    echo ""
}

# 检测是否为项目目录
is_project_dir() {
    local dir="$1"
    [ -f "$dir/package.json" ] || [ -f "$dir/.git/config" ] || [ -f "$dir/Cargo.toml" ] || [ -f "$dir/go.mod" ] || [ -f "$dir/pyproject.toml" ]
}

# 检测 OpenCode
check_opencode() {
    if command -v opencode &> /dev/null; then
        echo -e "${GREEN}✓ OpenCode 已安装${NC}"
        opencode --version
        return 0
    else
        echo -e "${YELLOW}⚠ OpenCode 未安装${NC}"
        echo "请先安装 OpenCode: https://opencode.ai/"
        read -p "是否继续？（可能无法使用部分功能）[y/N] " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] || exit 1
        return 1
    fi
}

# 安装核心函数
do_install() {
    local target_dir="$1"
    local install_type="$2"  # "global" 或 "project"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    if [ "$install_type" = "global" ]; then
        echo -e "${BLUE}  全局安装${NC}"
        echo -e "${BLUE}  目标目录: $target_dir${NC}"
    else
        echo -e "${BLUE}  项目级安装${NC}"
        echo -e "${BLUE}  目标目录: $target_dir${NC}"
    fi
    echo -e "${BLUE}========================================${NC}"
    echo ""

    # 创建目录结构
    echo -e "${YELLOW}[1/5] 创建目录结构...${NC}"
    mkdir -p "$target_dir/.opencode/skills"
    mkdir -p "$target_dir/.opencode/commands"
    echo -e "${GREEN}✓ 目录结构创建完成${NC}"

    # 复制配置模板
    echo -e "${YELLOW}[2/5] 复制配置模板...${NC}"
    if [ -f "$SOURCE_ROOT/config/AGENTS.md.template" ]; then
        cp "$SOURCE_ROOT/config/AGENTS.md.template" "$target_dir/AGENTS.md"
        echo -e "${GREEN}✓ AGENTS.md 已创建${NC}"
    fi
    if [ -f "$SOURCE_ROOT/config/opencode.json.template" ]; then
        cp "$SOURCE_ROOT/config/opencode.json.template" "$target_dir/opencode.json"
        echo -e "${GREEN}✓ opencode.json 已创建${NC}"
    fi

    # 初始化 progress.txt
    echo -e "${YELLOW}[3/5] 初始化进度跟踪文件...${NC}"
    cat > "$target_dir/progress.txt" << 'EOF'
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

    # 安装 Skills
    echo -e "${YELLOW}[4/5] 安装核心 Skills...${NC}"
    if ! command -v npx &> /dev/null; then
        echo -e "${RED}✗ npx 未安装，跳过 Skills 安装${NC}"
        echo -e "${YELLOW}请手动安装 Node.js 后重试${NC}"
    else
        echo "正在安装核心 Skills..."
        local core_skills=(
            "spec-driven-development"
            "writing-plans"
            "incremental-implementation"
            "test-driven-development"
            "code-review-and-quality"
            "debugging-and-error-recovery"
            "context-engineering"
        )
        for skill in "${core_skills[@]}"; do
            echo -n "  安装 $skill..."
            if npx skills add "https://github.com/addyosmani/agent-skills" --skill "$skill" 2>/dev/null; then
                echo -e " ${GREEN}✓${NC}"
            else
                echo -e " ${RED}✗${NC}"
            fi
        done

        echo ""
        read -p "是否安装增强 Skills？（前端、安全等）[Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            local enhanced_skills=(
                "frontend-ui-engineering"
                "security-and-hardening"
            )
            for skill in "${enhanced_skills[@]}"; do
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

    # 复制自定义 Skills 和模板
    echo -e "${YELLOW}[5/5] 复制自定义内容...${NC}"
    read -p "是否复制文档模板和自定义 Skills？[Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # 文档模板
        [ -f "$SOURCE_ROOT/templates/BACKEND_STRUCTURE.md" ] && cp "$SOURCE_ROOT/templates/BACKEND_STRUCTURE.md" "$target_dir/" && echo -e "${GREEN}✓ BACKEND_STRUCTURE.md${NC}"
        [ -f "$SOURCE_ROOT/templates/FRONTEND_GUIDELINES.md" ] && cp "$SOURCE_ROOT/templates/FRONTEND_GUIDELINES.md" "$target_dir/" && echo -e "${GREEN}✓ FRONTEND_GUIDELINES.md${NC}"
        # 自定义 Skills
        [ -d "$SOURCE_ROOT/skills-template/skill-self-update" ] && cp -r "$SOURCE_ROOT/skills-template/skill-self-update" "$target_dir/.opencode/skills/" && echo -e "${GREEN}✓ skill-self-update${NC}"
        [ -d "$SOURCE_ROOT/skills-template/skill-recommendation" ] && cp -r "$SOURCE_ROOT/skills-template/skill-recommendation" "$target_dir/.opencode/skills/" && echo -e "${GREEN}✓ skill-recommendation${NC}"
        [ -f "$SOURCE_ROOT/skills-template/skills-config.json" ] && cp "$SOURCE_ROOT/skills-template/skills-config.json" "$target_dir/.opencode/" && echo -e "${GREEN}✓ skills-config.json${NC}"
    fi

    # 保存安装信息
    cat > "$target_dir/.opencode/install-info.json" << EOF
{
  "install_type": "$install_type",
  "install_date": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "source_version": "1.0.0"
}
EOF

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${GREEN}  安装完成！${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
    echo -e "后续步骤："
    echo -e "  1. 编辑 AGENTS.md 中的项目信息"
    echo -e "  2. 运行 opencode 开始开发"
    echo ""
    echo -e "更多信息请查看 README.md"
    echo ""
}

# 解析参数
INSTALL_MODE=""
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --global)
            INSTALL_MODE="global"
            TARGET_DIR="$GLOBAL_DIR"
            shift
            ;;
        --project)
            INSTALL_MODE="project"
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                TARGET_DIR="$2"
                shift
            else
                TARGET_DIR="$(pwd)"
            fi
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            # 如果不是选项，当作路径处理
            if [ -z "$TARGET_DIR" ]; then
                TARGET_DIR="$1"
                INSTALL_MODE="project"
            fi
            shift
            ;;
    esac
done

# 主流程
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  OpenCode 开发工作流 - 安装程序${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

check_opencode

# 如果没有指定模式，交互式选择
if [ -z "$INSTALL_MODE" ]; then
    echo ""
    echo -e "${CYAN}请选择安装类型：${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} 项目级安装（推荐）"
    echo -e "     安装到当前目录或指定项目目录"
    echo -e "     适合：单个项目使用"
    echo ""
    echo -e "  ${BLUE}2)${NC} 全局安装"
    echo -e "     安装到 ~/.opencode/"
    echo -e "     适合：所有项目共享配置"
    echo ""
    read -p "请选择 [1/2]: " choice
    case $choice in
        1)
            INSTALL_MODE="project"
            TARGET_DIR="$(pwd)"
            ;;
        2)
            INSTALL_MODE="global"
            TARGET_DIR="$GLOBAL_DIR"
            ;;
        *)
            echo -e "${RED}无效选择，退出${NC}"
            exit 1
            ;;
    esac
fi

# 确认安装目录
echo ""
echo -e "${CYAN}安装目录: ${TARGET_DIR}${NC}"
if [ "$INSTALL_MODE" = "project" ] && is_project_dir "$TARGET_DIR"; then
    echo -e "${GREEN}✓ 检测到项目目录${NC}"
fi
read -p "确认安装？[Y/n] " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]] || exit 1

# 执行安装
do_install "$TARGET_DIR" "$INSTALL_MODE"