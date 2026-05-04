---
name: continue-work
description: 继续上次工作流程 - 恢复上下文并继续开发
compatibility: opencode
metadata:
  audience: developers
  workflow: workflow-continuation
---

# 继续工作 Skill

当用户说"继续工作"、"继续上次"、"接着来"、"resume"时，使用此 Skill。

## 完整工作流

### 阶段 1: 加载上下文

**必须执行：**
1. 读取 `progress.txt` 获取当前进度
2. 读取 `lessons.md` 获取历史错误模式
3. 检查最近 git 提交历史

### 阶段 2: 确认状态

**必须执行：**
1. 显示当前进度给用户确认：
   - 已完成的功能
   - 当前进行中的功能
   - 待完成的功能
2. 询问是否有其他要补充的

### 阶段 3: 继续工作

**必须执行：**
1. 读取 `IMPLEMENTATION_PLAN.md` 获取当前步骤
2. 切换到 Build 模式（如需要）
3. 继续实现当前步骤
4. 验证完成后更新 progress.txt

## 输出格式

完成后告诉用户：
```
📍 当前状态：

✅ 已完成：
- [已完成列表]

⏳ 进行中：
- [当前进行中的任务]

📋 待完成：
- [待完成任务]

🚀 继续执行步骤 X.X...
```

## 关键规则

- ✅ 始终先读取 progress.txt
- ✅ 显示当前状态给用户确认
- ✅ 每次操作后更新 progress.txt