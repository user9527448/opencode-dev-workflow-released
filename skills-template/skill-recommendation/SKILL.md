---
name: skill-recommendation
description: 智能 Skills 推荐系统 - 根据任务类型和上下文自动推荐合适的 Skills
compatibility: opencode
metadata:
  audience: developers
  workflow: skill-discovery
  tags: [recommendation, skills, discovery]
---

# Skills 推荐 Skill

本 Skill 负责根据任务类型和上下文智能推荐合适的 Skills。

## 核心功能

### 1. 任务类型识别与 Skills 映射

当检测到任务类型时，自动推荐对应 Skills：

| 任务类型 | 推荐 Skills | 用途 |
|----------|-------------|------|
| 新项目/新功能开发 | `spec-driven-development` | 需求规范化 |
| 创建实现计划 | `writing-plans` | 任务拆分 |
| 多文件实现 | `incremental-implementation` | 增量开发 |
| 编写测试/修复bug | `test-driven-development` | TDD 开发 |
| 代码审查 | `code-review-and-quality` | 5轴审查 |
| 调试/错误 | `debugging-and-error-recovery` | 5步调试 |
| 上下文管理 | `context-engineering` | 上下文加载 |
| 前端开发 | `frontend-ui-engineering` | UI开发 |
| API设计 | `api-and-interface-design` | 接口设计 |
| 安全检查 | `security-and-hardening` | 安全审计 |

### 2. 会话开始推荐

**自动执行：**

```typescript
await skill({ name: "context-engineering" });
// 加载上下文管理 Skill
```

显示欢迎消息和推荐：
```
👋 欢迎回来！

当前项目：[项目名称]
状态：进行中

🔧 推荐 Skills：
• spec-driven-development - 需求规范化（用于新功能）
• incremental-implementation - 增量开发（用于实现）
• code-review-and-quality - 代码审查（用于审查）

使用方式：说 "加载 [skill-name]"
```

### 3. 关键词触发推荐

| 检测关键词 | 推荐 Skills |
|-----------|-------------|
| "创建项目" / "新建" | spec-driven-development |
| "实现" / "开发" | writing-plans → incremental-implementation |
| "测试" / "写测试" | test-driven-development |
| "审查" / "review" | code-review-and-quality |
| "bug" / "错误" / "修复" | debugging-and-error-recovery |
| "UI" / "界面" / "样式" | frontend-ui-engineering |
| "API" / "接口" | api-and-interface-design |
| "安全" / "部署到生产" | security-and-hardening |
| "性能" / "优化" | performance-optimization |

### 4. Skills 加载执行

推荐后，用户可以：
- 说 "加载 [skill-name]" → 使用 skill 工具加载
- 直接描述需求 → AI 自动加载相关 Skill

```typescript
// 示例加载
skill({ name: "spec-driven-development" })
skill({ name: "test-driven-development" })
skill({ name: "code-review-and-quality" })
```

## Skills 组合工作流

### 新功能开发完整流程

```
用户: "帮我开发一个用户认证系统"

→ 加载 spec-driven-development
   → 创建 SPEC.md 规范
   → 等待用户确认

→ 加载 writing-plans
   → 创建任务列表

→ 加载 incremental-implementation
   → 每个任务: 实现 → 测试 → 验证 → 提交

→ 加载 test-driven-development
   → RED: 写测试
   → GREEN: 实现
   → REFACTOR: 重构
```

### Bug 修复流程

```
用户: "登录功能报错了"

→ 加载 debugging-and-error-recovery
   → Reproduce: 复现问题
   → Localize: 定位代码
   → Reduce: 最小化
   → Fix: 修复
   → Guard: 添加防护

→ 加载 test-driven-development
   → 回归测试验证
```

### 代码审查流程

```
用户: "帮我审查刚才的代码"

→ 加载 code-review-and-quality
   → 5轴审查
   → 置信度过滤
   → 输出报告
```

## 推荐场景示例

### 场景 1：用户要开发新功能

用户："我想做一个电商网站"

```
推荐：
• spec-driven-development - 先创建规范
• writing-plans - 规划实现步骤
• frontend-ui-engineering - 前端开发

我将加载 spec-driven-development 帮助你创建规范。
```

### 场景 2：用户要写测试

用户："帮我写一些单元测试"

```
推荐：
• test-driven-development - TDD 开发模式

我将加载 test-driven-development 帮助你编写测试。
```

### 场景 3：用户要调试

用户："支付接口报错了"

```
推荐：
• debugging-and-error-recovery - 5步调试流程

我将加载 debugging-and-error-recovery 帮你调试问题。
```

## 输出格式

### 欢迎消息格式

```markdown
👋 欢迎回来！

**当前项目**: [项目名称]
**状态**: 进行中

**🔧 推荐 Skills**:
| Skill | 用途 |
|-------|------|
| spec-driven-development | 需求规范化 |
| incremental-implementation | 增量开发 |
| code-review-and-quality | 代码审查 |

使用方式：说 "加载 [skill-name]" 或直接描述需求
```

### 推荐消息格式

```markdown
根据你的需求，我推荐以下 Skills：

1. **[skill-name]** - [描述]
   - 触发词: [关键词]

2. **[skill-name]** - [描述]
   - 触发词: [关键词]

我将自动加载 [primary-skill] 来帮助你。
```

## 关键规则

- ✅ 每次会话开始自动加载 `context-engineering`
- ✅ 根据任务类型自动推荐对应 Skills
- ✅ 提供清晰的加载指令
- ✅ 不强制加载，尊重用户选择
- ✅ 优先推荐 `addyosmani/agent-skills` 库中的标准化 Skills

## 安装说明

本项目推荐的 Skills 来自业界标准库：

```bash
# 核心 Skills
npx skills add https://github.com/addyosmani/agent-skills --skill spec-driven-development
npx skills add https://github.com/addyosmani/agent-skills --skill writing-plans
npx skills add https://github.com/addyosmani/agent-skills --skill incremental-implementation
npx skills add https://github.com/addyosmani/agent-skills --skill test-driven-development
npx skills add https://github.com/addyosmani/agent-skills --skill code-review-and-quality
npx skills add https://github.com/addyosmani/agent-skills --skill debugging-and-error-recovery
npx skills add https://github.com/addyosmani/agent-skills --skill context-engineering
```