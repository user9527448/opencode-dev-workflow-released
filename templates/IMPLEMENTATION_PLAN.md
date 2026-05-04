# 实施计划 (IMPLEMENTATION_PLAN)

> 逐步构建序列，确保 AI 不会跳步或乱序

---

## 阶段 1: 项目初始化

### 1.1 初始化 Next.js 项目

```bash
npx create-next-app@14 . --typescript --tailwind --eslint
```

**验收标准：**
- [ ] 项目成功创建
- [ ] TypeScript 正常编译
- [ ] Tailwind CSS 工作
- [ ] 开发服务器可运行

### 1.2 安装依赖

```bash
npm install zustand axios react-hook-form date-fns
npm install -D @types/node @types/react @types/react-dom
```

**验收标准：**
- [ ] package.json 包含所有依赖
- [ ] 无安装错误

### 1.3 创建文件夹结构

```
src/
├── app/           # Next.js App Router
├── components/    # React 组件
│   ├── ui/        # 基础 UI 组件
│   └── features/  # 功能组件
├── lib/           # 工具函数
│   ├── api/       # API 调用
│   └── utils/     # 通用工具
├── hooks/         # 自定义 hooks
├── stores/        # Zustand stores
└── types/         # TypeScript 类型
```

**验收标准：**
- [ ] 目录结构创建完成
- [ ] 路径别名配置正确

### 1.4 配置 OpenCode

- 创建 AGENTS.md
- 创建 opencode.json
- 创建 progress.txt（初始化）

**验收标准：**
- [ ] OpenCode 可读取项目配置

---

## 阶段 2: 基础 UI 组件

### 2.1 按钮组件

**文件：** `src/components/ui/Button.tsx`

**功能：**
- Primary/Secondary/Ghost 变体
- Loading 状态
- 禁用状态

**验收标准：**
- [ ] 组件可正常渲染
- [ ] 所有变体样式正确
- [ ] 悬停/激活状态正确
- [ ] 加载状态显示 spinner

### 2.2 输入框组件

**文件：** `src/components/ui/Input.tsx`

**功能：**
- 基础输入
- 错误状态
- 图标插槽

**验收标准：**
- [ ] 可输入文本
- [ ] 错误状态显示红色边框
- [ ] 可添加前后图标

### 2.3 卡片组件

**文件：** `src/components/ui/Card.tsx`

**验收标准：**
- [ ] 圆角和阴影正确
- [ ] 可自定义 padding

### 2.4 导航栏组件

**文件：** `src/components/ui/Navbar.tsx`

**功能：**
- Logo
- 导航链接
- 用户菜单

**验收标准：**
- [ ] 桌面端显示完整导航
- [ ] 移动端显示汉堡菜单

---

## 阶段 3: 布局与路由

### 3.1 根布局

**文件：** `src/app/layout.tsx`

**验收标准：**
- [ ] 全局样式正确加载
- [ ] 字体正确应用

### 3.2 认证布局

**文件：** `src/app/(auth)/layout.tsx`

**验收标准：**
- [ ] 居中显示子内容
- [ ] 无顶部导航

### 3.3 路由配置

| 页面 | 路径 | 文件 |
|------|------|------|
| 首页 | / | app/page.tsx |
| 登录 | /login | app/login/page.tsx |
| 注册 | /register | app/register/page.tsx |
| 仪表盘 | /dashboard | app/dashboard/page.tsx |

**验收标准：**
- [ ] 所有页面可访问
- [ ] 路由跳转正常

---

## 阶段 4: 认证功能

### 4.1 设置 Supabase（如果使用）

```bash
npm install @supabase/supabase-js
```

**配置：**
- 创建 src/lib/supabase.ts
- 配置环境变量

### 4.2 登录页面

**文件：** `src/app/login/page.tsx`

**验收标准：**
- [ ] 可输入邮箱密码
- [ ] 登录失败显示错误
- [ ] 登录成功跳转 /dashboard

### 4.3 注册页面

**文件：** `src/app/register/page.tsx`

**验收标准：**
- [ ] 可填写注册信息
- [ ] 注册成功跳转 /dashboard

### 4.4 认证状态管理

**文件：** `src/stores/authStore.ts`

**验收标准：**
- [ ] 登录状态全局可用
- [ ] 登出功能正常

---

## 阶段 5: 核心功能

### 5.1 仪表盘页面

**文件：** `src/app/dashboard/page.tsx`

**验收标准：**
- [ ] 显示用户信息
- [ ] 显示主要功能入口

### 5.2 数据列表页

**文件：** `src/app/dashboard/items/page.tsx`

**验收标准：**
- [ ] 显示数据列表
- [ ] 可分页
- [ ] 可搜索（可选）

### 5.3 数据详情页

**文件：** `src/app/dashboard/items/[id]/page.tsx`

**验收标准：**
- [ ] 显示详情信息
- [ ] 编辑功能
- [ ] 删除功能

---

## 阶段 6: 测试与优化

### 6.1 单元测试

```bash
npm run test
```

**验收标准：**
- [ ] 核心组件有测试
- [ ] 测试通过

### 6.2 构建检查

```bash
npm run build
```

**验收标准：**
- [ ] 无 TypeScript 错误
- [ ] 无 ESLint 错误

### 6.3 性能优化

- [ ] 图片优化
- [ ] 路由预加载

---

## 阶段 7: 部署

### 7.1 Vercel 部署

**验收标准：**
- [ ] 成功部署到 Vercel
- [ ] 环境变量配置正确

### 7.2 最终验证

- [ ] 首页正常加载
- [ ] 登录/注册正常
- [ ] 数据操作正常

---

## 进度跟踪

### 已完成
- [ ] 步骤 1.1
- [ ] 步骤 1.2

### 进行中
- [ ] 步骤 1.3

### 待开始
- [ ] 步骤 1.4
- [ ] 步骤 2.1
- ...

---

> 最后更新：{{date}}