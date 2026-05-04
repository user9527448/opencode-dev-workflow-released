---
name: dev:review
description: 代码审查流程
trigger: /dev review
---

# /dev review 命令

**触发方式：** 用户输入 `/dev review`

**执行流程：** 加载 `code-review` skill 并执行代码审查。

## 自动执行

1. 加载 code-review skill
2. 运行 lint、build、test
3. 检查代码规范、安全、性能
4. 输出审查报告
5. 如需要，执行修复

## 使用场景

- 用户想审查代码
- 用户说"代码审查"、"检查代码"