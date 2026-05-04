---
name: new-project
description: 完整的新项目创建流程 - 从需求分析到项目初始化
compatibility: opencode
metadata:
  audience: developers
  workflow: project-creation
---

# 新项目创建 Skill

当用户说"创建新项目"、"新建项目"、"我想做个XX"时，使用此 Skill。

## 完整工作流

### 阶段 1: 需求 Interrogation (Plan 模式)

**必须执行：**
1. 切换到 Plan 模式（按 Tab）
2. 对用户进行系统化提问：
   - 这是给谁用的？（目标用户）
   - 核心功能是什么？（用户要完成什么行动）
   - 他们完成后发生什么？
   - 需要保存什么数据？需要展示什么数据？
   - 需要登录吗？需要数据库吗？
   - 需要在手机上工作吗？
   - 错误时发生什么？成功时发生什么？

3. 持续提问直到没有假设剩余

### 阶段 2: 生成规范文档

**必须创建以下文件**（从 templates/ 复制）：

1. **PRD.md** - 产品需求文档
   - 包含：项目概述、目标用户、核心功能、用户故事、成功标准

2. **APP_FLOW.md** - 用户流程图
   - 包含：页面清单、用户流程、路由表

3. **TECH_STACK.md** - 技术栈定义
   - 询问用户偏好或推荐：Next.js 14 + TypeScript + Tailwind

4. **FRONTEND_GUIDELINES.md** - 设计系统
   - 锁定：调色板、间距、圆角、字体、响应式断点

5. **BACKEND_STRUCTURE.md** - 后端结构（如需要）
   - 数据库模式、API 端点、认证逻辑

6. **IMPLEMENTATION_PLAN.md** - 实施计划
   - 步骤化：项目初始化 → 基础组件 → 核心功能 → 测试 → 部署

### 阶段 3: 初始化项目

**必须执行：**
1. 切换到 Build 模式
2. 按照 IMPLEMENTATION_PLAN.md 步骤 1.1 初始化项目
3. 创建目录结构
4. 安装依赖

### 阶段 4: 状态文件

**必须创建：**
1. **progress.txt** - 记录初始状态
2. **lessons.md** - 空文件，用于记录错误学习

### 阶段 5: 提交

**必须执行：**
1. Git add 初始文件
2. Git commit "Initial project setup"

## 输出格式

完成后告诉用户：
```
✅ 新项目创建完成！

📋 已创建文档：
- PRD.md
- APP_FLOW.md
- TECH_STACK.md
- FRONTEND_GUIDELINES.md
- IMPLEMENTATION_PLAN.md
- progress.txt
- lessons.md

🚀 下一步：
- 第一个功能：实现 IMPLEMENTATION_PLAN.md 步骤 1.2
- 输入 "/add" 或说 "添加功能" 继续
```

## 关键规则

- ❌ 不要跳过 interrogation 阶段
- ❌ 不要在用户确认前开始写代码
- ✅ 文档必须保存到项目根目录
- ✅ 每次操作后更新 progress.txt