# skill-self-update

Self-updating Skills management system with version control and rollback capability.

## Trigger Conditions

- **Session Start**: Automatically check for new skill recommendations
- **User Request**: User asks for something not covered by current skills
- **Periodic**: Weekly automatic check for better alternatives
- **Manual**: User triggers `/skill-check` command

## Core Principles (NEVER VIOLATE)

1. **User Confirmation First**
   - NEVER auto-install or auto-update anything without explicit user approval
   - Always show recommendation first, wait for user to confirm
   - If user rejects, do not ask again for the same recommendation

2. **Version Control**
   - Archive EVERY change (add/replace/remove) with full context
   - Record: timestamp, reason, before/after, created_by
   - Keep at least 3 history versions

3. **Safe Rollback**
   - User can revert to any previous version at any time
   - System auto-rollback on critical failure

---

## Workflow States

```
IDLE → CHECK_ON_START → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
            ↓
         RESEARCH_DEMAND → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
            ↓
         PERIODIC_CHECK → WAIT_CONFIRM → EXECUTE → ARCHIVE → IDLE
```

---

## Module 1: Session Start Check

### Trigger: `session.created` or user just opened OpenCode

**Workflow:**
1. Read current skills-config.json
2. Analyze user's recent project context (from session or config)
3. Search for relevant skills using Context7/websearch
4. Generate recommendation list with match scores

**Output Example:**
```
👋 欢迎回来！

检测到你的项目类型：[类型]
当前 Skills：[列表]

🔍 发现 [N] 个可能感兴趣的 Skills：

1. **[skill-name]** 
   - 匹配度：高/中/低
   - 描述：[简短描述]
   - 安装状态：已安装/未安装

回复 "了解更多 #1" 查看详情，或 "忽略" 跳过
```

---

## Module 2: Demand Response

### Trigger: User requests something not covered by current skills

**Workflow:**
1. Parse user request → extract key technologies/domains
2. Research available skills using Context7 + websearch (parallel)
3. Generate initial recommendation list (5-10 items)
4. Ask user to confirm priority:
   - 性能优先 (Performance)
   - 文档完善 (Documentation)
   - 社区活跃 (Community)
   - 简单易用 (Ease of use)
   - 兼容性好 (Compatibility)
5. Re-rank by priority
6. Show final recommendations

**Second Confirmation Example:**
```
找到 [N] 个可能满足需求的 Skills。你的侧重点是？

1. 性能优先 - 关注执行速度和效率
2. 文档完善 - 优先选择文档详细的
3. 社区活跃 - 优先选择活跃维护的
4. 简单易用 - 优先选择学习曲线低的
5. 兼容性好 - 优先选择多工具兼容的
```

**Final Recommendation Format:**
```
根据 "[侧重点]"，推荐：

🥇 **[skill-1]** (推荐度: 95%)
   - 描述：[描述]
   - 安装：npx skills add [url] --skill [name]
   - 匹配：✅ 性能 ✅ 文档

🥈 **[skill-2]** (推荐度: 85%)
   - 描述：[描述]
   - 匹配：✅ 性能

回复 "安装 #1" 或 "安装 #2" 确认安装
```

---

## Module 3: Periodic Self-Check

### Trigger: Weekly (configurable) or `/skill-check`

**Workflow:**
1. Scan all installed skills
2. For each skill category, search for better alternatives
3. Check compatibility between current skills
4. Generate update suggestions (if any)

**Output Example:**
```
📊 Skills 定期自检报告

| 当前 Skill | 评分 | 替代方案 | 建议 |
|-----------|------|---------|------|
| tdd-workflow | 9.0 | tdd-guide (9.5) | ⬆️ 建议更新 |

详细：[分析原因]

是否执行更新？回复 "更新" 或 "忽略"
```

---

## Module 4: Version Control

### Version File Structure:
```json
{
  "version": "3",
  "timestamp": "2026-05-04T10:30:00Z",
  "reason": "添加新的调试技能",
  "changes": [
    {
      "action": "add|replace|remove",
      "skill": "skill-name",
      "source": "repo/path",
      "before": null,
      "after": {"name": "...", "version": "1.0.0"}
    }
  ],
  "compatibility_check": {
    "tested": true,
    "conflicts": []
  },
  "created_by": "user"
}
```

### Rollback Commands:
- "回退版本" → revert to previous version
- "回退到 v2" → revert to specific version

---

## User Confirmation Protocol

**Confirmation Request Format:**
```
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

**Rules:**
1. If user says "拒绝" or "no", DO NOT ask again for same recommendation
2. If user says "详情", show more detailed analysis
3. If user says "确认", execute and archive version
4. If user says "忽略", silently return to IDLE

---

## Implementation Notes

### File Structure
```
.opencode/
├── skills-self-update/
│   ├── SKILL.md                  (this file)
│   ├── config.json               (configuration)
│   ├── versions/                 (version archives)
│   │   ├── v1.json
│   │   ├── v2.json
│   │   └── v3.json
│   ├── history/
│   │   └── changelog.md
│   └── recommendations/
│       └── pending.json          (pending confirmations)
```

### Configuration (config.json)
```json
{
  "check_on_start": true,
  "periodic_check": {
    "enabled": true,
    "interval": "weekly",
    "day": "monday",
    "time": "09:00"
  },
  "max_history_versions": 5,
  "compatibility_check_before_change": true
}
```

---

## Error Handling

1. **Research Failure**: Show "无法调研，请稍后重试"
2. **Compatibility Failure**: Block change, show conflicts, ask user to resolve
3. **Execution Failure**: Auto-rollback to previous version
4. **Version Archive Failure**: Block operation, require manual fix

---

## Integration Points

- **Commands**: `/skill-check` triggers periodic check
- **Skills**: Use Context7/websearch for research
- **Sessions**: Use session history for context analysis
- **Config**: Read/write skills-config.json for skill list management