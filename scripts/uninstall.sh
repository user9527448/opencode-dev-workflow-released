#!/bin/bash

#========================================
# OpenCode 开发工作流 - 卸载脚本
# 支持全局卸载和项目级卸载
#========================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 全局安装目录
GLOBAL_DIR="$HOME/.opencode"

# 显示帮助
show_help() {
    echo -e "${BLUE}OpenCode 开发工作流 - 卸载脚本${NC}"
    echo ""
    echo "用法: ./uninstall.sh [选项] [路径]"
    echo ""
    echo "选项:"
    echo "  --global        卸载全局安装 (~/.opencode/)"
    echo "  --project       卸载当前目录的项目级安装"
    echo "  --project PATH  卸载指定路径的项目级安装"
    echo "  --keep-data     保留用户数据 (progress.txt, lessons.md)"
    echo "  --help          显示此帮助信息"
    echo ""
}

# 检测安装类型
detect_install_type() {
    local dir="$1"
    if [ -f "$dir/.opencode/install-info.json" ]; then
        grep -o '"install_type": *"[^"]*"' "$dir/.opencode/install-info.json" | cut -d'"' -f4
    else
        echo "unknown"
    fi
}

# 卸载核心函数
do_uninstall() {
    local target_dir="$1"
    local keep_data="$2"

    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  卸载 OpenCode 开发工作流${NC}"
    echo -e "${BLUE}  目标目录: $target_dir${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""

    # 检测是否已安装
    if [ ! -d "$target_dir/.opencode" ]; then
        echo -e "${YELLOW}⚠ 未检测到安装，退出${NC}"
        exit 0
    fi

    # 显示将要删除的内容
    echo -e "${YELLOW}将要删除以下内容：${NC}"
    echo -e "  - $target_dir/AGENTS.md"
    echo -e "  - $target_dir/opencode.json"
    echo -e "  - $target_dir/.opencode/"
    if [ "$keep_data" = "false" ]; then
        echo -e "  - $target_dir/progress.txt"
        echo -e "  - $target_dir/lessons.md"
    else
        echo -e "  ${GREEN}(保留 progress.txt, lessons.md)${NC}"
    fi
    echo ""

    read -p "确认卸载？[y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1

    # 执行卸载
    echo -e "${YELLOW}正在卸载...${NC}"

    # 删除配置文件
    [ -f "$target_dir/AGENTS.md" ] && rm "$target_dir/AGENTS.md" && echo -e "${GREEN}✓ 删除 AGENTS.md${NC}"
    [ -f "$target_dir/opencode.json" ] && rm "$target_dir/opencode.json" && echo -e "${GREEN}✓ 删除 opencode.json${NC}"

    # 删除文档模板
    [ -f "$target_dir/BACKEND_STRUCTURE.md" ] && rm "$target_dir/BACKEND_STRUCTURE.md" && echo -e "${GREEN}✓ 删除 BACKEND_STRUCTURE.md${NC}"
    [ -f "$target_dir/FRONTEND_GUIDELINES.md" ] && rm "$target_dir/FRONTEND_GUIDELINES.md" && echo -e "${GREEN}✓ 删除 FRONTEND_GUIDELINES.md${NC}"

    # 删除用户数据（如果未保留）
    if [ "$keep_data" = "false" ]; then
        [ -f "$target_dir/progress.txt" ] && rm "$target_dir/progress.txt" && echo -e "${GREEN}✓ 删除 progress.txt${NC}"
        [ -f "$target_dir/lessons.md" ] && rm "$target_dir/lessons.md" && echo -e "${GREEN}✓ 删除 lessons.md${NC}"
    fi

    # 删除 .opencode 目录
    if [ -d "$target_dir/.opencode" ]; then
        rm -rf "$target_dir/.opencode"
        echo -e "${GREEN}✓ 删除 .opencode/${NC}"
    fi

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  卸载完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

# 解析参数
INSTALL_MODE=""
TARGET_DIR=""
KEEP_DATA="false"

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
        --keep-data)
            KEEP_DATA="true"
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
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
echo -e "${BLUE}  OpenCode 开发工作流 - 卸载程序${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 如果没有指定模式，尝试自动检测
if [ -z "$INSTALL_MODE" ]; then
    # 先检查当前目录
    if [ -f "$(pwd)/.opencode/install-info.json" ]; then
        INSTALL_MODE=$(detect_install_type "$(pwd)")
        TARGET_DIR="$(pwd)"
    # 再检查全局目录
    elif [ -f "$GLOBAL_DIR/.opencode/install-info.json" ]; then
        INSTALL_MODE="global"
        TARGET_DIR="$GLOBAL_DIR"
    else
        echo -e "${YELLOW}未检测到安装，请指定卸载目标${NC}"
        echo ""
        echo -e "${CYAN}请选择卸载目标：${NC}"
        echo ""
        echo -e "  ${GREEN}1)${NC} 卸载当前目录的项目级安装"
        echo -e "  ${BLUE}2)${NC} 卸载全局安装 (~/.opencode/)"
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
fi

# 确认卸载目录
echo ""
echo -e "${CYAN}卸载目录: ${TARGET_DIR}${NC}"
echo -e "${CYAN}安装类型: ${INSTALL_MODE}${NC}"
echo ""

# 询问是否保留数据
if [ "$KEEP_DATA" = "false" ]; then
    read -p "是否保留用户数据（progress.txt, lessons.md）？[Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        KEEP_DATA="true"
    fi
fi

# 执行卸载
do_uninstall "$TARGET_DIR" "$KEEP_DATA"