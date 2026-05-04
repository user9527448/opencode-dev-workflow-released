# OpenCode 开发工作流完整指南

> 基于 Vibe Coding 方法论的专业级开发流程 | 适配自 Claude/Cursor 最佳实践

---

## 目录

1. [为什么你需要一个系统](#1-为什么你需要一个系统)
2. [规范文档系统](#2-规范文档系统)
3. [Interrogation 系统](#3-interrogation-系统)
4. [OpenCode 工作流](#4-opencode-工作流)
5. [会话管理](#5-会话管理)
6. [组件与布局](#6-组件与布局)
7. [状态管理](#7-状态管理)
8. [样式系统](#8-样式系统)
9. [响应式设计](#9-响应式设计)
10. [前后端分离](#10-前后端分离)
11. [错误处理](#11-错误处理)
12. [发布验证](#12-发布验证)

---

## 1. 为什么你需要一个系统

### AI 是翻译器，不是魔术师

AI 编程工具能力高但确定性低。它们在没有结构护栏的情况下执行任务。

**失败模式：**
- 缺乏锁定约束
- 缺乏权威文档
- AI 幻觉需求
- 未经授权的架构决策

**解决方案：文档第一，代码第二。永远这样。**

---

## 2. 规范文档系统

### 六份核心文档

在写任何代码之前，创建以下规范文档：

#### 2.1 PRD.md - 产品需求文档

**包含：**
- 你在构建什么
- 为谁构建
- 有什么功能
- 什么在范围内
- 什么明确在范围外
- 用户故事
- 成功标准
- 非目标
- 每个功能的具体标准

**这是你的合同。AI 读了这个就知道"完成"是什么样子。**

#### 2.2 APP_FLOW.md - 用户流程图

**包含：**
- 每个页面和每个用户导航路径
- 什么触发每个流程
- 逐步序列与决策点
- 成功时发生什么
- 错误时发生什么
- 屏幕清单与路由

**这防止 AI 猜测用户如何在 App 中移动。**

#### 2.3 TECH_STACK.md - 技术栈定义

**包含：**
- 每个包的确切版本
- 依赖版本
- API 工具
- 构建工具

**示例：**
```markdown
- Next.js 14.1.0
- React 18.2.0
- TypeScript 5.3.3
- Tailwind CSS 3.4.0
- Supabase 2.45.0
```

**当 AI 看到 "使用 React"，它可能选任何版本。当它看到确切版本，它构建的完全是你指定的。**

#### 2.4 FRONTEND_GUIDELINES.md - 前端设计系统

**包含：**
- 字体（带确切名称）
- 调色板（带确切十六进制代码）
- 间距刻度
- 布局规则
- 组件样式
- 响应式断点
- UI 库偏好
- 设计风格（Glassmorphism/Neobrutalism/Bento Grid 等）

#### 2.5 BACKEND_STRUCTURE.md - 后端数据结构

**包含：**
- 数据库模式（每张表、每列、类型和关系）
- 认证逻辑
- API 端点合约
- 存储规则
- 边缘情况处理

**如果用 Supabase，包含确切的 SQL 结构。**

#### 2.6 IMPLEMENTATION_PLAN.md - 实施计划

**格式：**
```markdown
# 实施计划

## 步骤 1: 项目初始化
### 1.1 初始化 Next.js 项目
- 运行 create-next-app
- 配置 TypeScript
- 安装 Tailwind CSS

### 1.2 安装依赖
- 安装 TECH_STACK.md 中列出的包

### 1.3 创建文件夹结构
- src/app
- src/components
- src/lib

## 步骤 2: 核心功能
### 2.1 构建导航栏组件
- 按照 FRONTEND_GUIDELINES.md 样式化
- 实现响应式设计
...
```

**步骤越多，AI 猜测越少。AI 猜测越少，幻觉越少。**

---

## 3. Interrogation 系统

### 在写文档之前，让 AI 审问你的想法

**核心提示词：**
> "在写任何代码之前，在 Planning 模式下无尽地审问我的想法。不要假设任何问题。问问题直到没有假设剩下。"

### AI 应该问的问题：

- 这是给谁用的？
- 用户采取的核心行动是什么？
- 他们完成那个行动后发生什么？
- 需要保存什么数据？
- 需要展示什么数据？
- 错误时发生什么？
- 成功时发生什么？
- 这需要登录吗？
- 这需要数据库吗？
- 需要在手机上工作吗？

### 生成文档的提示词

> "基于我们的审问，生成我的规范文档文件：PRD.md、APP_FLOW.md、TECH_STACK.md、FRONTEND_GUIDELINES.md、BACKEND_STRUCTURE.md、IMPLEMENTATION_PLAN.md。用我们对话中的答案作为素材。要具体且详尽。没有歧义。"

### 顺序

```
Interrogation → 文档 → 代码
永远不要跳过这些步骤
```

---

## 4. OpenCode 工作流

### 4.1 模式切换

| 模式 | 快捷键 | 用途 |
|------|--------|------|
| Plan | Tab | 只读分析、规划方案 |
| Build | Tab | 完整开发、修改文件 |

### 4.2 完整开发循环

```bash
# 步骤 1: Interrogation（Plan 模式）
opencode
> 在 Plan 模式下审问我的想法：我想做一个食谱分享 App

# 步骤 2: 生成文档（Plan 模式）
> 基于我们的对话，生成所有规范文档

# 步骤 3: 确认文档
[阅读生成的文档，纠正任何模糊的]

# 步骤 4: 切换到 Build 模式
[按 Tab 键]

# 步骤 5: 实现
> 实现 IMPLEMENTATION_PLAN.md 的步骤 1.1

# 步骤 6: 验证
> 运行 npm run build 确认无错误

# 步骤 7: 更新进度
[更新 progress.txt]
```

### 4.3 OpenCode 特定配置

#### AGENTS.md 替代 CLAUDE.md

OpenCode 使用 `AGENTS.md` 而非 `CLAUDE.md`。创建位置：

- 项目根目录：`.opencode/AGENTS.md` 或 `AGENTS.md`
- 全局配置：`~/.config/opencode/AGENTS.md`

#### AGENTS.md 模板

```markdown
# 项目规则

## 技术栈
[从 TECH_STACK.md 复制]

## 文件结构
- src/app/ → 页面和路由
- src/components/ → 可复用 UI 组件
- src/lib/ → 工具函数

## 命名约定
- 组件：PascalCase (Button.tsx)
- 工具：camelCase (formatDate.ts)
- 常量：UPPER_SNAKE_CASE

## 设计系统
[从 FRONTEND_GUIDELINES.md 引用关键规则]

## 禁止操作
- 永远不要使用内联样式，使用 Tailwind
- 永远不要提交 .env 到 git

## 参考文档
- PRD.md
- APP_FLOW.md
- TECH_STACK.md
- FRONTEND_GUIDELINES.md
- BACKEND_STRUCTURE.md
- IMPLEMENTATION_PLAN.md

## 会话管理
- 每次会话开始读取 progress.txt
- 完成任何功能后更新 progress.txt
- 每次纠正后更新 lessons.md
```

---

## 5. 会话管理

### progress.txt - 你的外部记忆

**为什么重要：** AI 在会话间没有记忆。关闭终端、打开新终端、或开始新聊天时，一切都消失了。

**格式：**
```text
已完成：
- 通过 Clerk 的用户认证（登录、注册、Google OAuth）
- 带侧边栏导航的仪表盘布局
- 产品 API 端点（GET /api/products）

进行中：
- 产品详情页面（/products/[id]）
- 需要连接 frontend 到 API

接下来：
- 购物车功能
- Stripe 结账

已知 Bug：
- 点击链接后手机导航不关闭
```

**更新时机：**
- 每次完成一个功能
- 每次开始新会话
- 每次打开新终端窗口
- 每次切换分支

### lessons.md - 错误学习

**格式：**
```markdown
# 项目错误模式

## 认证相关
- 问题：登录后未重定向 → 解决：添加 useRouter 强制跳转

## 样式相关
- 问题：暗色模式下文字看不清 → 解决：保持足够对比度
```

**更新时机：**
- 每次纠正 AI 的错误后
- 每个 PR 后
- 每个调试会话后

---

## 6. 组件与布局

### 组件思维

**什么是组件：** 可复用的界面片段（按钮、卡片、表单）

**为什么重要：** AI 知道要创建什么片段，每个片段可独立编辑

**示例提示词：**
> "用这些组件构建落地页：导航栏、hero 区域、功能网格（3 张卡片）、推荐轮播、CTA 区域、页脚。"

### 布局思维

**核心概念：** 每个网站都是盒子套盒子

**主要盒子：**
- header/导航栏（顶部）
- 主要内容（中间）
- 侧边栏（可选）
- 页脚（底部）

**示例提示词：**
> "两列布局。左边侧边栏，250px 宽。主要内容占据剩余空间。侧边栏固定，不滚动。"

---

## 7. 状态管理

### 什么是 State

State 是变化的数据：
- 菜单是打开还是关闭？
- 用户是登录还是登出？
- 购物车里有什么物品？
- 输入框里有什么文本？
- 这是在加载还是完成了？
- 这是成功还是失败？

### 示例提示词

> "当用户点击这个按钮，把 modal state 设为打开。当他们点击 modal 外面，设为关闭。"

---

## 8. 样式系统

### 设计令牌（Design Tokens）

在 `FRONTEND_GUIDELINES.md` 中锁定：

```markdown
## 调色板
- 主色：#3B82F6
- 辅色：#8B5CF6
- 背景：#F9FAFB
- 表面：#FFFFFF
- 文本：#111827
- 边框：#E5E7EB
- 成功：#10B981
- 错误：#EF4444
- 警告：#F59E0B

## 间距刻度
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

## 圆角
- sm: 4px
- md: 8px
- lg: 12px
- xl: 16px

## 字体
- 标题：Inter, system-ui, sans-serif
- 正文：Inter, system-ui, sans-serif
- 代码：JetBrains Mono, monospace
```

### 具体 > 模糊

**坏的提示词：**
> "让它看起来好看一点"

**好的提示词：**
> "用 16px 内边距和 8px 圆角把背景做成 #3B82F6"

---

## 9. 响应式设计

### 断点定义

```markdown
## 响应式断点
- 手机：0-640px
- 平板：640-1024px
- 桌面：1024px 以上

## 响应规则
- 导航：768px 以下汉堡菜单，以上完整水平导航
- 网格：手机单列、平板两列、桌面三列
- 字体：每个断点放大 15%
```

### Mobile-First

```css
/* Tailwind 默认 mobile-first */
flex flex-col md:flex-row
/* 手机上堆叠，平板及以上并排 */
```

---

## 10. 前后端分离

### Frontend
- 用户看到和交互的
- 在浏览器里运行
- 收集输入、发送到服务器、显示响应

### Backend
- 幕后发生的
- 数据库、用户账户、处理
- 在服务器上运行

### 示例提示词

> "用 Supabase。我需要一个带 email 和密码的 users 表，以及一个带 title、content 和 user_id 的 posts 表。"

---

## 11. 错误处理

### 调试循环

```
AI 给你代码 → 你尝试 → 它崩了 → 你粘贴错误 → AI 修复 → 重复直到工作
```

### 给 AI 足够的上下文

**坏的：**
> "它坏了，修复它"

**好的：**
> "我得到这个错误：TypeError: Cannot read property 'map' of undefined。这是那行的代码：[粘贴代码]。ProductList.tsx:15:23"

### 切换工具

对于顽固 bug：
- 使用 OpenCode 的调试模式
- 或使用专门的调试 Skills

---

## 12. 发布验证

### 发布前检查清单

- [ ] 在手机上工作吗？（真机测试）
- [ ] 在不同浏览器中工作吗？
- [ ] 没有数据时空状态处理了吗？
- [ ] 错误数据时错误状态处理了吗？
- [ ] 慢网速时加载状态存在吗？
- [ ] 能通过快速点击打破它吗？
- [ ] 密钥在浏览器开发者工具中隐藏了吗？

---

## 总结

```
文档优先 → 增量实现 → 验证通过 → 持续迭代
```

**核心原则：**
1. 永远先写文档
2. 把大需求拆成小碎片
3. 给 AI 足够的上下文
4. 总是验证输出
5. 保持会话状态

---

> 参考：[Vibe Coding 方法论](https://mp.weixin.qq.com/s/xQvSuhGXvawPsW_cWXxnbA)
> 本项目：OpenCode Dev Workflow