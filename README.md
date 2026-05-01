<p align="center">
  <img src="docs/images/cover.png" alt="Cover" width="100%" />
</p>

<h1 align="center">📚 Bilibili Obsidian Clipper</h1>
<h3 align="center">⚡ 一键捕捉 · 即刻沉淀 ⚡</h3>

<p align="center">
  <em>将 B 站的流动光影，凝固为你知识星图中永恒的一页。</em>
</p>

<p align="center">
  <a href="https://chromewebstore.google.com/detail/jokophbofiphenlplmohabdcmalcbenl">
    <img src="https://img.shields.io/badge/Chrome-Extension-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Chrome" />
  </a>
  <a href="https://microsoftedge.microsoft.com/addons/detail/fbeeapnjdjgacilaobonekidbfjcmdjo">
    <img src="https://img.shields.io/badge/Edge-Extension-0078D7?style=for-the-badge&logo=microsoftedge&logoColor=white" alt="Edge" />
  </a>
  <a href="https://addons.mozilla.org/addon/bilibili-obsidian-clipper/">
    <img src="https://img.shields.io/badge/Firefox-Add--on-FF7139?style=for-the-badge&logo=firefoxbrowser&logoColor=white" alt="Firefox" />
  </a>
</p>

---

> 🎬 **Fork from** [haixiong1997/Bilibili-Obsidian-Clipper](https://github.com/haixiong1997/Bilibili-Obsidian-Clipper)  
> 🙏 原作者：[haixiong1997](https://github.com/haixiong1997)

---

## ✨ 这是什么？

想象一下——

> *你深夜刷到一个绝妙的教程，30 分钟的知识密度抵得上半本教科书。*
> *你不想收藏它——收藏等于遗忘。*
> *你想把它拆解、标注、链接到你已有的知识体系中。*

**Bilibili Obsidian Clipper** 就是那座桥。

点击一下，视频的完整字幕自动落入你的 Obsidian，连同视频标签、分区、时间戳——一切就绪，只待你提笔批注。

```
B 站视频 ──⟐──→ 字幕抓取 ──⟐──→ Markdown ──⟐──→ 你的 Obsidian 知识库
                         ├── SRT 下载
                         └── TXT 纯文本
```

---

## 🎯 法术列表

| 法术 | 效果 |
|------|------|
| 🔍 **字幕抓取** | 自动识别当前分 P，抓取全部字幕轨 |
| 📝 **Markdown 生成** | 带 YAML frontmatter（标题/链接/BV号/标签等） |
| 🏷️ **智能标签** | 合并视频标签 + 分区 + 自定义，可随意编辑 |
| 📥 **字幕下载** | 支持 SRT / TXT 格式 |
| 📡 **一键写入** | 直连 Obsidian Local REST API |
| ⏱️ **重试机制** | 字幕链接过期自动重试，指数退避 |

> ⚠️ 仅支持「有字幕轨」的视频（播放器里有「字幕」选项即为有字幕）。

---

## 🎨 预览

<p align="center">
  <img src="docs/images/feature-demo-v2.png" alt="功能演示" width="720" />
</p>

---

## 🔧 结界展开仪式

### 📦 商店安装（推荐）

<p align="center">
  <a href="https://chromewebstore.google.com/detail/jokophbofiphenlplmohabdcmalcbenl">Chrome Web Store</a> ·
  <a href="https://microsoftedge.microsoft.com/addons/detail/fbeeapnjdjgacilaobonekidbfjcmdjo">Edge Add-ons</a> ·
  <a href="https://addons.mozilla.org/addon/bilibili-obsidian-clipper/">Firefox Add-ons</a>
</p>

### 🧪 开发者模式加载

<details>
<summary><strong>Chrome / Edge</strong></summary>

1. 在 Releases 下载 `*-chrome.zip` 并解压
2. 打开 `chrome://extensions/`（Edge: `edge://extensions/`）
3. 开启「开发者模式」
4. 点击「加载已解压的扩展程序」→ 选择解压目录
</details>

<details>
<summary><strong>Firefox</strong></summary>

1. 在 Releases 下载 `*-firefox.zip` 并解压
2. 打开 `about:debugging` → 「此 Firefox」
3. 「临时加载附加组件」→ 选择 `manifest.json`
</details>

---

## 🌐 与 Obsidian 订契

```
Obsidian 社区插件 → Local REST API → 启用 HTTP → 复制 API Key
                                                        ↓
                    扩展设置页 → 填入地址 + Key + 笔记目录 → 契约成立 ✨
```

| 设置项 | 示例值 |
|--------|--------|
| REST API 地址 | `http://127.0.0.1:27123` |
| API Key | `your-secret-key` |
| 笔记目录 | `Clippings/Bilibili` |
| 默认标签 | `学习,知识`（可选） |
| 自动追加视频标签 | ✅ 推荐开启 |
| 自动追加视频分区 | ✅ 推荐开启 |

---

## 📐 项目结构

```
extension/
├── manifest.json      # 扩展清单
├── background.js      # 后台服务（API 代理 / 设置管理）
├── content.js         # 字幕抓取 / 渲染 / 生成
├── popup.html         # 弹出面板
├── popup.js           # 面板交互
├── popup.css          # 面板样式
├── options.html       # 设置页面
├── options.js         # 设置逻辑
├── options.css        # 设置样式
├── content.css        # 侧边栏样式
└── icons/             # 图标集
```

---

## 🎮 快捷指令

```
① 打开 B 站视频页 → ② 点扩展图标 → ③ 预览编辑标签
                                          │
                          ┌───────────────┼───────────────┐
                          ▼               ▼               ▼
                       📋 复制        📥 下载字幕      📡 写入 Obsidian
```

---

## 📺 教程

- [B 站视频教程](https://www.bilibili.com/video/BV15qQwB4EZ9/)

---

## 🙇 致谢

原项目作者 [haixiong1997](https://github.com/haixiong1997)，感谢他打造了连结 B 站与知识管理的月下门扉。

---

<p align="center">
  <sub>Made with ❤️ and a lot of late-night B站 sessions</sub>
</p>
