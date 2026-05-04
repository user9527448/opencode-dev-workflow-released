---
name: dev:new
description: 开始新项目创建流程
trigger: /dev new
---

# /dev new 命令

**触发方式：** 用户输入 `/dev new`

**执行流程：** 加载 `new-project` skill 并执行新项目创建流程。

## 自动执行

1. 加载 new-project skill
2. 进入 Plan 模式进行需求 interrogation
3. 生成规范文档
4. 初始化项目
5. 创建 progress.txt 和 lessons.md
6. 提交初始代码

## 使用场景

- 用户想创建全新项目
- 用户说"创建新项目"、"新建项目"（自然语言也会触发）