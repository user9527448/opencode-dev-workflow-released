---
name: dev:add
description: 添加新功能流程
trigger: /dev add
---

# /dev add 命令

**触发方式：** 用户输入 `/dev add`

**执行流程：** 加载 `add-feature` skill 并执行功能开发流程。

## 自动执行

1. 加载 add-feature skill
2. 检查 progress.txt 上下文
3. 确认/澄清需求
4. 实现功能
5. 验证并更新 progress.txt

## 使用场景

- 用户想在现有项目中添加功能
- 用户说"添加功能"、"开发新功能"