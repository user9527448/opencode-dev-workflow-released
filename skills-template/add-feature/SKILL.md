---
name: add-feature
description: 添加新功能流程 - 需求确认到实现验证
compatibility: opencode
metadata:
  audience: developers
  workflow: feature-development
---

# 添加新功能 Skill

当用户说"添加功能"、"开发新功能"、"实现XX功能"时，使用此 Skill。

## 完整工作流

### 阶段 1: 检查上下文

**必须执行：**
1. 读取 `progress.txt` 获取当前进度
2. 读取 `PRD.md` 确认功能范围
3. 读取 `IMPLEMENTATION_PLAN.md` 确认实现顺序

### 阶段 2: 需求确认

**如果用户未提供详细需求：**
1. 切换到 Plan 模式
2. 提问澄清：
   - 这个功能的完整流程是什么？
   - 需要哪些页面？
   - 需要什么数据？
   - 成功/失败的标准是什么？

**如果用户已提供明确需求：**
- 直接进入下一阶段

### 阶段 3: 实现功能

**必须执行：**
1. 切换到 Build 模式
2. 读取相关规范文档（APP_FLOW.md、TECH_STACK.md 等）
3. 按照 IMPLEMENTATION_PLAN.md 当前步骤实现
4. 运行测试验证

### 阶段 4: 验证

**必须执行：**
1. `npm run build` - 构建检查
2. `npm test` - 运行测试
3. 如有错误，修复后重新验证

### 阶段 5: 更新状态

**必须执行：**
1. 更新 `progress.txt` 记录完成内容
2. 如有错误纠正，更新 `lessons.md`
3. 提示用户可以继续什么

## 输出格式

完成后告诉用户：
```
✅ 功能开发完成！

📝 已完成：
- [功能描述]
- 测试通过

📋 下一步：
- [下一个待完成任务]
- 输入 "/add" 或说 "继续" 继续工作
```

## 关键规则

- ❌ 不要添加未在 PRD.md 中列出的功能
- ❌ 不要跳过测试
- ✅ 每次完成后更新 progress.txt
- ✅ 错误修复后更新 lessons.md