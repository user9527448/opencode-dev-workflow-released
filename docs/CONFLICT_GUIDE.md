# 配置冲突指南

> 本指南说明如何与现有配置共存

---

## 与现有配置合并

### 如果你已有 AGENTS.md

不要直接覆盖。建议合并内容：

```markdown
# 现有 AGENTS.md 内容
...your existing rules...

# ====== 添加以下内容 ======
# 来自 opencode-dev-workflow 的自动化规则
# 复制以下章节到你的 AGENTS.md:

## 自动化工作流规则
[从 config/AGENTS.md.template 复制相关章节]
```

### 如果你已有 opencode.json

配置会合并。确保我们的设置不会覆盖你的关键配置：

```json
{
  // 你的现有配置
  ...your config...

  // 我们的配置会自动合并
  // 如需覆盖，手动调整
}
```

---

## 与 Oh My OpenCode (OMO) 共存

### OMO 用户

OMO 使用独立的配置文件：
- `.opencode/oh-my-opencode.json` - 项目级
- `~/.config/opencode/oh-my-opencode.json` - 用户级

**与本项目无冲突**，因为：
- 我们使用 `opencode.json`
- OMO 使用 `oh-my-opencode.json`

### 同时使用两者

```bash
# 你的项目结构
project/
├── opencode.json                    # ← 我们的配置
├── .opencode/
│   ├── oh-my-opencode.json          # ← OMO 配置
│   ├── AGENTS.md                    # ← 我们的规则
│   ├── skills/                      # ← 我们的 Skills
│   └── commands/                    # ← 我们的 Commands
```

### 加载顺序

OpenCode 配置加载顺序（后者覆盖前者）：
1. 全局 config (`~/.config/opencode/opencode.json`)
2. 项目 config (`opencode.json`) ← **我们的**
3. `.opencode` 目录 ← **我们的**

OMO 配置文件独立加载，不会冲突。

---

## 与 MCP/插件共存

### MCP（Model Context Protocol）

**无冲突** - 我们没有配置 MCP 字段

```json
// 我们的配置 - 无 mcp 字段
{
  "commands": {...}
}

// 用户的配置 - 可以有 mcp
{
  "mcp": {
    "servers": {...}
  }
}
```

两者完全独立，互不影响。

### 插件

**无冲突** - 我们没有配置 plugin 字段

```json
// 我们的配置 - 无 plugin 字段
{
  "commands": {...}
}

// 用户的配置 - 可以有 plugin
{
  "plugin": ["some-plugin"]
}
```

---

## Skills 冲突详细说明

### 加载优先级

OpenCode 按以下顺序发现 Skills，同名 Skills 只加载第一个：

```
1. .opencode/skills/           ← 项目级（我们的）
2. .claude/skills/             ← 项目级 Claude 兼容
3. ~/.config/opencode/skills/ ← 用户级
4. ~/.claude/skills/           ← 用户级 Claude
```

### 场景：用户有同名 Skill

如果用户有同名 Skill（如 `add-feature`）：

```
用户项目: .opencode/skills/add-feature/   ← 我们的（优先）
用户全局: ~/.config/opencode/skills/add-feature/  ← 被忽略
```

**我们的 Skill 会覆盖用户的**。

### 解决方案

用户可以通过命名空间强制使用特定版本：

```
use_skill("user:add-feature")    # 强制使用用户级
use_skill("project:add-feature") # 强制使用项目级（我们的）
```

---

## 常见冲突场景

### 场景 1: 已有自己的 AGENTS.md

**问题**：我们的 AGENTS.md 会覆盖你的

**解决**：
1. 复制我们的 AGENTS.md 内容到你的文件
2. 删除我们的 AGENTS.md，只保留 skills/commands

### 场景 2: 已有自己的 Skills

**问题**：Skill 名称可能冲突

**解决**：我们的 Skills 使用独特前缀，如需避免可重命名：
- `workflow-new-project` → 你的名称

### 场景 3: 已有自己的 Commands

**问题**：命令名称可能冲突

**解决**：我们的命令以 `/` 开头，如 `/new`，如果冲突可忽略或删除

---

## 完整卸载

如果需要移除本项目配置：

```bash
# 删除配置文件
rm AGENTS.md
rm opencode.json

# 删除 skills 和 commands
rm -rf .opencode/skills/*
rm -rf .opencode/commands/*
```

---

## 优先级说明

OpenCode 优先级（高 → 低）：
1. 项目 `opencode.json`
2. 全局 `~/.config/opencode/opencode.json`
3. 远程配置

我们的配置在项目级，有最高优先级。

---

> 如有其他冲突问题，请提交 Issue