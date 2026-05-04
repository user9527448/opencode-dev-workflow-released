# 前端设计系统 (FRONTEND_GUIDELINES)

> 锁定所有视觉决策，确保 AI 生成一致的 UI

---

## 1. 设计风格

### 当前采用风格
- [ ] Glassmorphism（玻璃拟态）
- [x] Neobrutalism（新粗野主义）
- [ ] Neumorphism（软 UI）
- [ ] Bento Grid（便当网格）
- [x] Dark Mode（暗色模式）
- [ ] 其他：______

### 风格说明
**Neobrutalism**：原始、大胆、故意不精致。高对比度颜色、厚黑边框、平阴影、冲突的调色板、古怪字体。

---

## 2. 调色板

### 2.1 浅色模式

| 变量名 | 用途 | 十六进制 |
|--------|------|----------|
| --primary | 主色 | #3B82F6 |
| --primary-hover | 主色悬停 | #2563EB |
| --secondary | 辅色 | #8B5CF6 |
| --accent | 强调色 | #F59E0B |
| --background | 背景 | #FFFFFF |
| --surface | 表面 | #F9FAFB |
| --surface-elevated | 浮起表面 | #FFFFFF |
| --text-primary | 主要文本 | #111827 |
| --text-secondary | 次要文本 | #6B7280 |
| --text-muted | 弱化文本 | #9CA3AF |
| --border | 边框 | #E5E7EB |
| --border-strong | 强边框 | #000000 |
| --success | 成功 | #10B981 |
| --error | 错误 | #EF4444 |
| --warning | 警告 | #F59E0B |
| --info | 信息 | #3B82F6 |

### 2.2 深色模式

| 变量名 | 用途 | 十六进制 |
|--------|------|----------|
| --primary | 主色 | #60A5FA |
| --primary-hover | 主色悬停 | #3B82F6 |
| --secondary | 辅色 | #A78BFA |
| --accent | 强调色 | #FBBF24 |
| --background | 背景 | #0F172A |
| --surface | 表面 | #1E293B |
| --surface-elevated | 浮起表面 | #334155 |
| --text-primary | 主要文本 | #F9FAFB |
| --text-secondary | 次要文本 | #CBD5E1 |
| --text-muted | 弱化文本 | #64748B |
| --border | 边框 | #334155 |
| --border-strong | 强边框 | #94A3B8 |
| --success | 成功 | #34D399 |
| --error | 错误 | #F87171 |
| --warning | 警告 | #FBBF24 |
| --info | 信息 | #60A5FA |

---

## 3. 间距系统

### 间距刻度

| 名称 | 值 | 用途 |
|------|-----|------|
| 0 | 0px | 无间距 |
| xs | 4px | 紧凑元素 |
| sm | 8px | 组件内部 |
| md | 16px | 组件之间 |
| lg | 24px | 区块之间 |
| xl | 32px | 区块之间 |
| 2xl | 48px | 页面级 |
| 3xl | 64px | 页面级 |
| 4xl | 96px | 页面级 |

---

## 4. 圆角系统

| 名称 | 值 | 用途 |
|------|-----|------|
| none | 0px | 无圆角 |
| sm | 4px | 小元素 |
| md | 8px | 常规元素 |
| lg | 12px | 大元素 |
| xl | 16px | 特殊 |
| full | 9999px | 圆形/药丸 |

---

## 5. 阴影系统

### Neobrutalism 风格

```css
/* 凸起 */
box-shadow: 4px 4px 0px 0px #000000;

/* 悬停 */
box-shadow: 6px 6px 0px 0px #000000;

/* 按下 */
box-shadow: 2px 2px 0px 0px #000000;
```

### 替代阴影

| 名称 | 值 | 用途 |
|------|-----|------|
| sm | 0 1px 2px rgba(0,0,0,0.05) | 小元素 |
| md | 0 4px 6px rgba(0,0,0,0.1) | 卡片 |
| lg | 0 10px 15px rgba(0,0,0,0.1) | 浮起元素 |

---

## 6. 字体系统

### 字体栈

```css
--font-sans: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--font-display: 'Inter', system-ui, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', ui-monospace, monospace;
```

### 字号刻度

| 名称 | 值 | 行高 | 用途 |
|------|-----|------|------|
| xs | 12px | 1.5 | 辅助文本 |
| sm | 14px | 1.5 | 正文/次要 |
| base | 16px | 1.6 | 正文 |
| lg | 18px | 1.6 | 强调 |
| xl | 20px | 1.4 | 小标题 |
| 2xl | 24px | 1.3 | 标题 |
| 3xl | 30px | 1.2 | 大标题 |
| 4xl | 36px | 1.1 | Hero |

### 字重

| 名称 | 值 | 用途 |
|------|-----|------|
| normal | 400 | 正文 |
| medium | 500 | 次要 |
| semibold | 600 | 强调 |
| bold | 700 | 标题 |

---

## 7. 组件规范

### 按钮

```tsx
// Primary Button - Neobrutalism 风格
<Button variant="primary">
  点击我
</Button>
// 样式：bg-blue-500, text-white, border-2 border-black, shadow-[4px_4px_0px_0px_black]
// 悬停：shadow-[6px_6px_0px_0px_black], translate-x-[-2px], translate-y-[-2px]
// 按下：shadow-none, translate-x-[0], translate-y-[0]
```

### 输入框

```tsx
<input className="border-2 border-black rounded-md px-4 py-2 focus:outline-none focus:shadow-[4px_4px_0px_0px_black]" />
```

### 卡片

```tsx
<div className="border-2 border-black bg-white rounded-lg shadow-[4px_4px_0px_0px_black] p-6" />
```

---

## 8. 响应式断点

| 名称 | 断点 | 描述 |
|------|------|------|
| sm | 640px | 手机横屏 |
| md | 768px | 平板 |
| lg | 1024px | 小笔记本 |
| xl | 1280px | 桌面 |
| 2xl | 1536px | 大屏 |

---

## 9. 动画规范

### 过渡时间

```css
--transition-fast: 150ms;
--transition-base: 200ms;
--transition-slow: 300ms;
```

### 微交互示例

```tsx
// 按钮悬停
<button className="transition-all duration-200 hover:translate-x-[-2px] hover:translate-y-[-2px]" />

// 淡入
<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} />
```

---

## 10. 可访问性

### 颜色对比度
- 文本与背景：至少 4.5:1（普通文本）
- 大文本：至少 3:1

### Focus 状态
- 所有可交互元素必须有 focus-visible 样式
- 使用 2px 黑色轮廓

---

## 11. CSS 类顺序（Tailwind）

推荐顺序：
1. layout (display, flex, grid)
2. spacing (padding, margin)
3. sizing (width, height)
4. visual (background, border, shadow)
5. typography (font, text)
6. state (hover, focus, disabled)
7. interactive (cursor, pointer)

---

> 最后更新：{{date}}