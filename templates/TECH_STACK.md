# 技术栈定义 (TECH_STACK)

> 锁定所有依赖的精确版本，防止 AI 幻觉依赖

---

## 1. 运行时

### Node.js
- **版本**：20.x LTS
- **包管理器**：npm（默认）/ pnpm

### 浏览器支持
- Chrome >= 90
- Firefox >= 88
- Safari >= 14
- Edge >= 90

---

## 2. 前端技术

### 框架与库

| 类别 | 包名 | 版本 | 用途 |
|------|------|------|------|
| 框架 | next | 14.x | React 框架 |
| React | react | 18.x | UI 库 |
| React | react-dom | 18.x | React DOM |
| 语言 | typescript | 5.x | 类型系统 |
| 样式 | tailwindcss | 3.x | CSS 框架 |
| 状态 | zustand | 4.x | 状态管理 |
| 请求 | axios | 1.x | HTTP 请求 |
| 表单 | react-hook-form | 7.x | 表单处理 |
| 日期 | date-fns | 3.x | 日期处理 |

### 开发工具

| 包名 | 版本 | 用途 |
|------|------|------|
| eslint | 8.x | 代码检查 |
| prettier | 3.x | 代码格式化 |
| @types/node | 20.x | Node 类型 |
| @types/react | 18.x | React 类型 |

---

## 3. 后端技术（如果适用）

### 运行时
- **语言**：Node.js 20.x / Python 3.11+
- **框架**：Express / FastAPI

### 数据库

| 类型 | 服务 | 版本 |
|------|------|------|
| 关系型 | PostgreSQL | 15.x |
| 文档 | MongoDB | 7.x |
| 缓存 | Redis | 7.x |

### 服务

| 类型 | 服务 | 用途 |
|------|------|------|
| 认证 | Clerk / Supabase Auth | 用户认证 |
| 数据库 | Supabase | PostgreSQL + 认证 |
| 存储 | AWS S3 / Supabase Storage | 文件存储 |
| 邮件 | Resend / SendGrid | 邮件发送 |
| 支付 | Stripe | 支付处理 |

---

## 4. API 版本

### 内部 API

| 版本 | 路径 | 状态 |
|------|------|------|
| v1 | /api/v1 | 活跃 |

### 第三方 API

| 服务 | 端点 | 用途 |
|------|------|------|
| ... | ... | ... |

---

## 5. 开发环境

### 环境变量 (.env.local)

```bash
# 应用
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000/api/v1

# 数据库
DATABASE_URL=postgresql://...

# 认证
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# 支付
STRIPE_PUBLIC_KEY=
STRIPE_SECRET_KEY=

# 邮件
RESEND_API_KEY=
```

---

## 6. 部署配置

### 构建命令
```bash
npm run build
```

### 运行环境
- **开发**：localhost:3000
- **预览**：vercel.app preview
- **生产**：vercel.app

---

## 7. 依赖管理规则

### 禁止操作
- ❌ 禁止添加未在本文档中列出的依赖
- ❌ 禁止升级主要版本（如 3.x → 4.x）
- ❌ 禁止降级依赖版本

### 添加依赖流程
1. 在 TECH_STACK.md 中添加条目
2. 说明添加理由
3. 运行 `npm install`
4. 更新 .env.example

---

> 最后更新：{{date}}