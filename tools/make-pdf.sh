#!/bin/bash
# 資料/プレゼン資料/そなえ帳_提案書.pdf を作る（提案書.html を Chrome ヘッドレスで A4 横に印刷）
set -e
cd "$(dirname "$0")/.."
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SRC="$PWD/資料/プレゼン資料/提案書.html"; OUT="$PWD/資料/プレゼン資料/そなえ帳_提案書.pdf"
ud="$(mktemp -d)"; rm -f "$OUT"
"$CH" --headless=new --disable-gpu --mute-audio --no-pdf-header-footer --window-size=1123,794 --user-data-dir="$ud" --virtual-time-budget=8000 --print-to-pdf="$OUT" "file://$SRC" >/dev/null 2>&1 &
pid=$!; for i in $(seq 1 80); do sleep 0.5; [ -s "$OUT" ] && break; done; sleep 2; kill $pid 2>/dev/null || true; wait $pid 2>/dev/null || true; rm -rf "$ud"
ls -la "$OUT"
