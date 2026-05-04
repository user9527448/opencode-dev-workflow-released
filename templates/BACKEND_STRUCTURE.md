# 后端数据结构 (BACKEND_STRUCTURE)

> 定义数据库模式、API 端点和数据处理逻辑

---

## 1. 数据库模式

### 1.1 用户表 (users)

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### 1.2 示例表 (示例)

```sql
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT,
  status VARCHAR(50) DEFAULT 'draft',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 2. 表结构汇总

| 表名 | 描述 | 主键 | 外键 | 索引 |
|------|------|------|------|------|
| users | 用户 | id | - | email |
| posts | 帖子 | id | user_id | user_id |
| comments | 评论 | id | user_id, post_id | post_id |
| ... | ... | ... | ... | ... |

---

## 3. API 端点

### 3.1 认证 API

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| POST | /api/auth/register | 注册 | 否 |
| POST | /api/auth/login | 登录 | 否 |
| POST | /api/auth/logout | 登出 | 是 |
| GET | /api/auth/me | 当前用户 | 是 |

### 3.2 用户 API

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| GET | /api/users/:id | 获取用户 | 是 |
| PATCH | /api/users/:id | 更新用户 | 是 |

### 3.3 帖子 API

| 方法 | 路径 | 描述 | 认证 |
|------|------|------|------|
| GET | /api/posts | 列表 | 否 |
| GET | /api/posts/:id | 详情 | 否 |
| POST | /api/posts | 创建 | 是 |
| PATCH | /api/posts/:id | 更新 | 是 |
| DELETE | /api/posts/:id | 删除 | 是 |

---

## 4. 请求/响应格式

### 4.1 成功响应

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "title": "Example"
  }
}
```

### 4.2 错误响应

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "邮箱格式不正确",
    "details": []
  }
}
```

### 4.3 分页响应

```json
{
  "success": true,
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

---

## 5. 认证逻辑

### 5.1 JWT 令牌

```typescript
// Token 包含
{
  "userId": "uuid",
  "email": "user@example.com",
  "role": "user",
  "exp": 1234567890
}
```

### 5.2 令牌配置

- 访问令牌：15 分钟
- 刷新令牌：7 天

### 5.3 受保护路由

以下路由需要有效 JWT：
- /api/users/*
- /api/posts (POST/PATCH/DELETE)
- /api/comments (POST/PATCH/DELETE)

---

## 6. 验证规则

### 用户注册

| 字段 | 规则 | 错误消息 |
|------|------|----------|
| email | 必需，邮箱格式 | 请输入有效邮箱 |
| password | 必需，8+ 字符 | 密码至少 8 位 |
| name | 可选，2-50 字符 | - |

### 帖子创建

| 字段 | 规则 | 错误消息 |
|------|------|----------|
| title | 必需，1-255 字符 | 标题不能为空 |
| content | 可选，10000 字符内 | - |

---

## 7. 边缘情况处理

| 场景 | 处理 |
|------|------|
| 帖子不存在 | 返回 404 |
| 无权限操作 | 返回 403 |
| 并发修改 | 乐观锁版本号 |
| 请求超时 | 返回 504 |

---

## 8. 索引与性能

```sql
-- 用户表索引
CREATE INDEX idx_users_email ON users(email);

-- 帖子表索引
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
```

---

## 9. 数据迁移策略

- 使用版本化迁移文件
- 每次迁移必须是幂等的
- 保留回滚脚本

---

> 最后更新：{{date}}