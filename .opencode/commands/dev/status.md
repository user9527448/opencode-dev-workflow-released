---
name: dev:status
description: 查看当前项目进度状态
trigger: /dev status
---

# /dev status 命令

**触发方式：** 用户输入 `/dev status`

**执行流程：** 读取并显示 progress.txt 内容。

## 自动执行

1. 读取 progress.txt
2. 读取 lessons.md（如存在）
3. 显示当前状态

## 输出格式

```
📍 项目状态

✅ 已完成：
- [已完成功能列表]

⏳ 进行中：
- [当前进行中的任务]

📋 待完成：
- [待完成任务]

🐛 已知问题：
- [已记录的问题]

💡 错误学习：
- [来自 lessons.md 的要点]
```

## 使用场景

- 用户想查看当前进度
- 用户说"查看状态"、"进度如何"