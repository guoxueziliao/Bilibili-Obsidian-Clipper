# AGENTS.md

## Project overview

Browser extension (Manifest V3) that extracts Bilibili video subtitles and saves them to Obsidian via Local REST API. Supports Chrome, Edge, and Firefox.

## No build step

There is no `package.json`, bundler, or build command. The extension loads directly from the `extension/` directory. To test changes, reload the extension in `chrome://extensions/` or `about:debugging`.

## Architecture

```
popup.js  --chrome.tabs.sendMessage-->  content.js  --chrome.runtime.sendMessage-->  background.js
                                        (injected into bilibili.com/video/*)           (service worker)
```

- **`content.js`**: injected into `*.bilibili.com/video/*`. Contains all subtitle extraction, UI rendering (sidebar panel), and Markdown/SRT/TXT generation. Uses `chrome.runtime.sendMessage` to reach the background service worker.
- **`background.js`**: service worker. Handles all external HTTP requests (Bilibili API, Obsidian REST API) because content scripts are blocked by CORS. Also manages settings storage and provides the `fetch-json` proxy.
- **`popup.js`**: extension popup. Communicates with `content.js` via `chrome.tabs.sendMessage` (tab-scoped). The popup itself does NOT fetch data — it relays user actions to the content script.
- **`options.js` / `options.html`**: settings page, exposed as the extension's options page.

## Settings storage split

- `chrome.storage.sync`: general settings (noteFolder, api base URL, tags, download format, frontmatter fields, etc.)
- `chrome.storage.local`: the API key only (considered sensitive). On first install, background.js migrates any API key from sync to local.

## API fetching — must proxy through background

Content scripts cannot directly `fetch()` Bilibili API endpoints due to CORS. Use `sendRuntimeMessage({ type: "fetch-json", url })` to proxy through the background service worker. The background adds appropriate headers (Accept, Referer, cache-control) for Bilibili domains.

## Subtitle fetching logic (content.js)

- Primary API source: `player-wbi-v2` (requires `aid`), fallback: `player-v2`
- Subtitle signed URLs expire quickly — there is retry logic with exponential backoff
- Subtitle tracks are validated by video duration to prevent mismatched tracks
- Subtitle bodies are cached in `chrome.storage.local` with key prefix `boc_subtitle_cache_`
- Multi-page (分P) videos: if no `?p=` param is present on a multi-page video, defaults to P1

## Tag system

Tags are dynamically merged from three sources:

1. **User-configured default tags** — comma-separated string from settings (`tags` field), e.g. `"clippings,bilibili"`
2. **Video tags** — fetched from `api.bilibili.com/x/tag/archive/tags?bvid=...`, the tags assigned to the video by the uploader/B站 community
3. **Partition tag** — resolved from the video's `tid` (type ID) against a hardcoded `PARTITION_MAP` lookup table in `content.js`

Whether sources 2 and 3 are included is controlled by two settings checkboxes:
- `autoAppendVideoTags` (default: `true`)
- `autoAppendPartitionTag` (default: `true`)

The merged tag string is displayed in an **editable input** in the popup, so users can modify tags per-video before copying or saving to Obsidian. When the user clicks "Copy" or "Save to Obsidian", the popup sends the currently-edited tags back to `content.js`, which regenerates the Markdown with those tags before the operation.

### Message types added for tag editing
- `popup-copy-markdown` — popup sends current tags, content.js returns regenerated markdown
- `popup-send-obsidian` now accepts an optional `tags` field

## Extension loading for development

1. Open `chrome://extensions/` (or `edge://extensions/`, `about:debugging` for Firefox)
2. Enable "Developer mode"
3. "Load unpacked" → select the `extension/` directory

## Testing / CI

No tests, linters, or CI workflows exist for this project.
