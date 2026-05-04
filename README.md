# OpenCode 自动化开发工作流

> 基于 Vibe Coding 方法论 | 完全自动化，无需手动引导
> 使用 addyosmani/agent-skills (20K stars) 业界标准 Skills
> 支持 Skills 自更新系统与版本控制

## 概述

这是一个**给 AI 用的自动化开发系统**。用户安装后，OpenCode 会**自动执行**完整开发流程，无需手动引导。

### 核心特性

| 特性 | 说明 |
|------|------|
| 🎯 **意图自动识别** | 用户说"创建项目"→ 自动执行新项目流程 |
| 📋 **标准 Skills 驱动** | 使用业界验证的标准化 Skills (addyosmani/agent-skills) |
| 🔄 **进度自动追踪** | progress.txt 自动更新 |
| 📚 **错误自动学习** | lessons.md 记录并防止重复错误 |
| ⌨️ **斜杠命令** | `/dev new` `/dev add` `/dev continue` `/dev review` |
| 🔄 **Skills 自更新** | 自动发现、推荐、更新 Skills |
| ⏪ **版本控制** | Skills 变更历史记录与回退 |

---

## 快速开始

### 1. 安装 OpenCode（如果未安装）

```bash
# macOS / Linux
curl -fsSL https://opencode.ai/install | bash

# Windows
scoop install opencode
```

### 2. 克隆并安装

```bash
git clone https://github.com/your-repo/opencode-dev-workflow.git
cd opencode-dev-workflow
```

### 3. 选择安装方式

#### 项目级安装（推荐）

```bash
# Linux/macOS
chmod +x scripts/install.sh
./scripts/install.sh --project /path/to/your-project

# 或在项目目录下运行
cd /path/to/your-project
/path/to/scripts/install.sh

# Windows
.\scripts\install.ps1 -Project -Path C:\path\to\your-project

# 或在项目目录下运行
cd C:\path\to\your-project
C:\path\to\scripts\install.ps1 -Project
```

#### 全局安装

```bash
# Linux/macOS
chmod +x scripts/install.sh
./scripts/install.sh --global

# Windows
.\scripts\install.ps1 -Global
```

#### 交互式选择

```bash
# Linux/macOS
./scripts/install.sh

# Windows
.\scripts\install.ps1
```

> **注意：** 安装脚本会自动安装核心 Skills（addyosmani/agent-skills），无需手动安装。

### 4. 开始开发

```bash
# 进入你的项目目录
cd your-project

# 启动 OpenCode
opencode
```

### 卸载

```bash
# 项目级卸载
./scripts/uninstall.sh --project
.\scripts\uninstall.ps1 -Project

# 全局卸载
./scripts/uninstall.sh --global
.\scripts\uninstall.ps1 -Global

# 保留用户数据
./scripts/uninstall.sh --project --keep-data
.\scripts\uninstall.ps1 -Project -KeepData
```

---

## 自动化工作流

### 用户只需说：

| 用户输入 | 自动执行 | 对应 Skills |
|----------|----------|-------------|
| "创建新项目" / `/dev new` | 完整新项目流程：规范 → 计划 → 实现 | spec-driven-development → writing-plans → incremental-implementation |
| "添加功能" / `/dev add` | 功能开发流程：规范 → 计划 → 实现 → 测试 | spec-driven-development → writing-plans → incremental-implementation → test-driven-development |
| "继续工作" / `/dev continue` | 恢复流程：上下文恢复 → 继续工作 | context-engineering |
| "修复 bug" | 调试流程：复现 → 定位 → 修复 → 验证 | debugging-and-error-recovery → test-driven-development |
| "审查代码" / `/dev review` | 审查流程：5轴审查 → 输出报告 | code-review-and-quality |
| "查看状态" / `/dev status` | 显示 progress.txt 内容 | - |

### 自动执行细节

#### 新项目流程（自动）

```
1. 加载 spec-driven-development
2. SPECIFY 阶段：创建规范（6个核心领域）
3. 等待用户确认规范
4. PLAN 阶段：创建技术方案
5. TASKS 阶段：拆分任务（每个 5 分钟）
6. IMPLEMENT 阶段：使用 incremental-implementation + test-driven-development
7. 完成后更新 progress.txt、lessons.md
```

#### 添加功能流程（自动）

```
1. 加载 context-engineering 获取上下文
2. 加载 spec-driven-development（如需要新规范）
3. 加载 writing-plans 创建实现计划
4. 循环：incremental-implementation + test-driven-development
5. 完成后更新 progress.txt
```

---

## 🔄 Skills 自更新系统

### 核心原则

1. **用户确认原则** - 所有更改必须获得用户明确同意
2. **版本控制原则** - 每次更改都有完整存档
3. **容错回退原则** - 可随时回退到上一版本

### 触发条件

| 触发类型 | 条件 | 响应 |
|---------|------|------|
| 会话开始 | 打开 OpenCode | 自动推荐 Skills |
| 需求响应 | 用户请求当前 Skills 无法满足的功能 | 自动调研并推荐 |
| 定期自检 | 每周或用户触发 `/skill-check` | 扫描更好替代方案 |
| 回退请求 | 用户说 "回退版本" | 恢复到上一版本 |

### 工作流程

```
IDLE → CHECK_ON_START → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
            ↓
         RESEARCH_DEMAND → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
            ↓
         PERIODIC_CHECK → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
```

### 用户确认协议

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ 需要你的确认

操作：[添加/替换/删除] [skill-name]
原因：[原因描述]
影响：
- 正面：[benefits]
- 风险：[risks]

请回复：
- "确认" - 执行操作
- "拒绝" - 取消操作
- "详情" - 查看更多详情
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 版本控制

- 每次 Skills 变更都有版本记录
- 记录变更原因、变更内容、变更前后对比
- 用户可随时查看版本历史
- 支持回退到任意版本

### 版本回退命令

| 命令 | 效果 |
|------|------|
| `回退版本` | 回退到上一版本 |
| `回退到 v2` | 回退到指定版本 |

---

## 📊 定期自检

### 手动触发

```
/skill-check
```

### 自检报告格式

```markdown
📊 Skills 定期自检报告

| 当前 Skill | 评分 | 替代方案 | 建议 |
|-----------|------|---------|------|
| xxx | 9.0 | yyy (9.5) | ⬆️ 建议更新 |

详细分析：[分析原因]

是否执行更新？回复 "更新" 或 "忽略"
```

---

## ⌨️ 斜杠命令

| 命令 | 效果 |
|------|------|
| `/dev new` | 开始新项目流程 |
| `/dev add` | 添加新功能 |
| `/dev continue` | 继续上次工作 |
| `/dev review` | 代码审查 |
| `/dev status` | 查看当前进度 |
| `/skill-check` | 手动触发 Skills 定期自检 |
| `回退版本` | 回退到上一版本 |

---

## 项目结构

```
opencode-dev-workflow/
├── config/                       # 配置模板
│   ├── AGENTS.md.template       # AGENTS.md 模板
│   └── opencode.json.template   # opencode.json 模板
├── scripts/                      # 安装脚本
│   ├── install.sh               # Linux/macOS 安装
│   └── install.ps1              # Windows 安装
├── templates/                    # 文档模板
│   ├── BACKEND_STRUCTURE.md     # 后端架构文档
│   └── FRONTEND_GUIDELINES.md   # 前端规范文档
├── skills-template/              # 自定义 Skills
│   ├── skill-recommendation/    # 技能推荐
│   ├── skill-self-update/       # 自更新系统
│   └── skills-config.json       # Skills 配置
└── docs/                        # 文档
    ├── SELF_UPDATE_SYSTEM_DESIGN.md
    ├── CONFLICT_GUIDE.md
    └── TESTING_GUIDE.md
```

### 安装后用户项目结构

```
your-project/
├── AGENTS.md              # ← 核心自动化规则
├── .opencode/
│   ├── commands/          # ← 斜杠命令 (/dev new 等)
│   ├── skills/            # ← Skills 目录
│   │   ├── skill-recommendation/
│   │   └── skill-self-update/
│   └── skills-config.json # ← Skills 配置
├── BACKEND_STRUCTURE.md   # ← 后端架构文档（可选）
├── FRONTEND_GUIDELINES.md # ← 前端规范（可选）
├── progress.txt           # ← 自动更新的进度文件
└── ...
```

---

## 规范文档系统

安装后，当执行新项目流程时自动创建：

| 文档 | 内容 | 用途 |
|------|------|------|
| SPEC.md | 产品规范 | spec-driven-development 输出 |
| PRD.md | 产品需求、用户故事 | 可选 |
| APP_FLOW.md | 页面、路由、用户流程 | 可选 |
| IMPLEMENTATION_PLAN.md | 实施计划 | writing-plans 输出 |

---

## Skills 组合（推荐）

### 核心 Skills (来自 addyosmani/agent-skills - 20K stars)

| Skill | 功能 | 触发 |
|-------|------|------|
| `spec-driven-development` | 先规范后编码，4阶段流程 | 新项目/新功能 |
| `writing-plans` | 创建可执行实现计划，任务拆分 | 有规范后 |
| `incremental-implementation` | 薄切片实现，100行限制 | 多文件变更 |
| `test-driven-development` | RED-GREEN-REFACTOR，80%+覆盖率 | 编写测试/修复bug |
| `code-review-and-quality` | 5轴审查，置信度过滤 | 代码审查 |
| `debugging-and-error-recovery` | 5步调试流程 | Bug调试 |
| `context-engineering` | 上下文管理 | 会话开始/切换任务 |

### 增强 Skills

| Skill | 功能 | 触发 |
|-------|------|------|
| `frontend-ui-engineering` | 组件架构、响应式、WCAG | 前端开发 |
| `api-and-interface-design` | API设计、契约优先 | API开发 |
| `security-and-hardening` | OWASP Top 10、Secrets管理 | 部署前 |

### 组合工作流

```
新功能开发：
spec-driven-development → writing-plans → incremental-implementation → test-driven-development

Bug 修复：
debugging-and-error-recovery → test-driven-development

代码审查：
code-review-and-quality
```

---

## 工作原理

### 1. AGENTS.md 嵌入标准化 Skills 规则

AGENTS.md 中定义了强制规则：
- 任务开始前必须加载对应 Skill
- Skills 按优先级自动衔接

### 2. Skills 自动加载

```typescript
// 新功能开发
if (用户说 "添加功能") {
  await skill({ name: "spec-driven-development" });
  await skill({ name: "writing-plans" });
  await skill({ name: "incremental-implementation" });
  await skill({ name: "test-driven-development" });
}
```

### 3. 斜杠命令

`.opencode/commands/dev/` 中配置了命令，用户输入 `/dev new` 等即可触发。

### 4. progress.txt 自动更新

每次完成功能后，AI 会自动更新 progress.txt，记录当前进度。

### 5. Skills 自更新机制

每次会话开始或用户触发时，AI 会：
1. 分析当前项目上下文
2. 调研适合的 Skills
3. 生成推荐列表
4. 等待用户确认
5. 执行更新并归档

---

## 与其他工具共存

### Oh My OpenCode (OMO)

本项目与 OMO **完全兼容**，因为：
- 我们使用 `opencode.json` ← OMO 使用 `.opencode/oh-my-opencode.json`
- 我们使用项目根 `AGENTS.md` ← OMO 可使用 `.opencode/AGENTS.md`

**不会冲突** ✅

### MCP/插件

本项目 **不配置** MCP 或插件字段，与用户现有配置完全兼容 ✅

### Skills 冲突

如用户有同名 Skill，项目级的我们的会优先：
- 如需使用用户级版本，使用：`skill({ name: "user:skill-name" })`

详细说明见 [docs/CONFLICT_GUIDE.md](docs/CONFLICT_GUIDE.md)

---

## 故障排查

### 命令无响应

```bash
# 检查 AGENTS.md 是否存在
ls AGENTS.md

# 检查 .opencode 目录
ls .opencode/commands/dev/
```

### Skills 未加载

```bash
# 检查 Skills 安装
npx skills list

# 重新安装核心 Skills
npx skills add https://github.com/addyosmani/agent-skills --skill spec-driven-development
```

### progress.txt 未更新

```
# 手动触发更新
"更新 progress.txt"
```

---

## 时效性保证

- 本项目会持续更新，保持与 OpenCode 演进同步
- 定期检查 addyosmani/agent-skills 更新
- 跟随 OpenCode 官方 Changelog

---

## 参考资源

- [OpenCode 官方文档](https://dev.opencode.ai/docs/)
- [OpenCode Skills 文档](https://opencode.ai/docs/skills)
- [addyosmani/agent-skills (20K stars)](https://github.com/addyosmani/agent-skills)
- [Vibe Coding 方法论](https://mp.weixin.qq.com/s/xQvSuhGXvawPsW_cWXxnbA)

---

## 许可证

MIT License