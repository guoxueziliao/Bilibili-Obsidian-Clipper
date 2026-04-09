# Bilibili Obsidian Clipper

在 B 站视频页抓取字幕，预览后可复制 Markdown、下载字幕文件，并一键写入 Obsidian（Local REST API）。

## 核心能力

- 页面范围：`https://www.bilibili.com/video/*`
- 自动识别当前分 P（`bvid + p -> cid`），抓取更准确
- 多字幕轨支持，默认优先中文，其次英文
- 无字幕场景给出明确失败提示，不写入错误内容
- 导出格式支持 `srt / txt`（设置中可选，默认 `srt`）
- 写入 Obsidian 时支持 Frontmatter 字段勾选、章节分段与时间戳格式化

## 本地安装

1. 打开 `chrome://extensions/`
2. 开启“开发者模式”
3. 点击“加载已解压的扩展程序”
4. 选择本目录 `bilibili-obsidian-clipper`

## Obsidian 配置（仅 Local REST API）

1. 在 Obsidian 社区插件市场安装并启用 `Local REST API`
2. 在插件设置中勾选 `Enable Non-encrypted (HTTP) Server`
3. 复制插件页面里的 API Key
4. 打开本扩展设置页，填写：
   - `Local REST API 地址`（默认 `http://127.0.0.1:27123`）
   - `Local REST API Key`
   - `笔记目录`（如 `Clippings/Bilibili`）
   - `默认 tags`
   - `下载格式`
   - `Frontmatter 字段`

## 使用方式

1. 打开任意 B 站视频页并点击扩展图标
2. 面板会自动抓取并展示字幕
3. 按需点击：
   - `刷新`
   - `复制`
   - `下载`
   - `保存到 Obsidian`

## 开发与调试

- 每次改代码后，在 `chrome://extensions/` 点“重新加载”
- 刷新视频页后再测试
- 排查时可在设置页开启调试日志，并在 DevTools 查看 `[BOC]` 日志
