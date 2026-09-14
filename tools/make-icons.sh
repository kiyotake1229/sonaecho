#!/bin/bash
# アイコンPNGを生成する。Chrome（ヘッドレス）で tools/icon-gen.html を1024pxで撮影 → PIL で縮小
set -e
cd "$(dirname "$0")/.."
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
TMP="$(mktemp -d)"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=1024,1024 --screenshot="$TMP/icon-1024.png" "file://$(pwd)/tools/icon-gen.html" 2>/dev/null
python3 - "$TMP/icon-1024.png" <<'PY'
import sys
from PIL import Image
src=Image.open(sys.argv[1]).convert("RGB")
for name,size in [("icon-512.png",512),("icon-192.png",192),("apple-touch-icon.png",180)]:
    src.resize((size,size),Image.LANCZOS).save(name,optimize=True)
import os
os.makedirs("ios-app/assets",exist_ok=True)
src.save("ios-app/assets/icon.png",optimize=True)
print("ok")
PY
ls -la icon-*.png apple-touch-icon.png ios-app/assets/icon.png
