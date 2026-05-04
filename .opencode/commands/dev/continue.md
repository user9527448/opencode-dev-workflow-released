---
name: dev:continue
description: 继续上次工作流程
trigger: /dev continue
---

# /dev continue 命令

**触发方式：** 用户输入 `/dev continue`

**执行流程：** 加载 `continue-work` skill 并恢复工作进度。

## 自动执行

1. 加载 continue-work skill
2. 读取 progress.txt 获取当前进度
3. 读取 lessons.md 获取历史错误模式
4. 显示当前状态
5. 继续工作

## 使用场景

- 用户想继续上次的工作
- 用户说"继续工作"、"继续上次"