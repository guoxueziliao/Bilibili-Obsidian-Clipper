#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
EXT_DIR="$ROOT_DIR/extension"
RELEASE_DIR="$ROOT_DIR/release"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if [[ ! -f "$EXT_DIR/manifest.json" ]]; then
  echo "ERROR: manifest.json not found in extension/" >&2
  exit 1
fi

VERSION="$(
  node -e "const fs=require('fs');const m=JSON.parse(fs.readFileSync(process.argv[1],'utf8'));process.stdout.write(String(m.version||''));" \
    "$EXT_DIR/manifest.json"
)"

if [[ -z "$VERSION" ]]; then
  echo "ERROR: cannot read version from extension/manifest.json" >&2
  exit 1
fi

mkdir -p "$RELEASE_DIR"

CHROME_BUILD_DIR="$TMP_DIR/chrome"
FIREFOX_BUILD_DIR="$TMP_DIR/firefox"

cp -R "$EXT_DIR" "$CHROME_BUILD_DIR"
cp -R "$EXT_DIR" "$FIREFOX_BUILD_DIR"

find "$CHROME_BUILD_DIR" -name ".DS_Store" -delete
find "$FIREFOX_BUILD_DIR" -name ".DS_Store" -delete

node - "$CHROME_BUILD_DIR/manifest.json" <<'NODE'
const fs = require("fs");
const path = process.argv[2];
const manifest = JSON.parse(fs.readFileSync(path, "utf8"));
delete manifest.browser_specific_settings;
if (!manifest.background || typeof manifest.background !== "object") {
  manifest.background = { service_worker: "background.js" };
}
delete manifest.background.scripts;
manifest.background.service_worker = manifest.background.service_worker || "background.js";
fs.writeFileSync(path, JSON.stringify(manifest, null, 2) + "\n");
NODE

node - "$FIREFOX_BUILD_DIR/manifest.json" <<'NODE'
const fs = require("fs");
const path = process.argv[2];
const manifest = JSON.parse(fs.readFileSync(path, "utf8"));
manifest.browser_specific_settings = manifest.browser_specific_settings || {};
manifest.browser_specific_settings.gecko = manifest.browser_specific_settings.gecko || {
  id: "bilibili-obsidian-clipper@github.com",
  strict_min_version: "109.0"
};
manifest.background = manifest.background || {};
manifest.background.service_worker = manifest.background.service_worker || "background.js";
manifest.background.scripts = ["background.js"];
fs.writeFileSync(path, JSON.stringify(manifest, null, 2) + "\n");
NODE

CHROME_ZIP="$RELEASE_DIR/bilibili-obsidian-clipper-v${VERSION}-chrome.zip"
FIREFOX_ZIP="$RELEASE_DIR/bilibili-obsidian-clipper-v${VERSION}-firefox.zip"

rm -f "$CHROME_ZIP" "$FIREFOX_ZIP"

(
  cd "$CHROME_BUILD_DIR"
  zip -qr "$CHROME_ZIP" .
)

(
  cd "$FIREFOX_BUILD_DIR"
  zip -qr "$FIREFOX_ZIP" .
)

echo "Built:"
echo "  $CHROME_ZIP"
echo "  $FIREFOX_ZIP"
echo
echo "SHA256:"
shasum -a 256 "$CHROME_ZIP" "$FIREFOX_ZIP"

