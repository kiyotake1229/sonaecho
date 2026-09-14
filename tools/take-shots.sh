#!/bin/bash
# 提案資料/screenshots/*.png を生成する。サンプルデータ（?demo=1）で各画面を撮影
set -e
cd "$(dirname "$0")/.."
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT="提案資料/screenshots"; mkdir -p "$OUT"
shot(){ n="$1"; q="$2"; f="$OUT/$n.png"; rm -f "$f"
  "$CH" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 --window-size=800,844 --user-data-dir="$(mktemp -d)" --timeout=4000 --screenshot="$PWD/$f" "file://$PWD/tools/shot.html?$q" >/dev/null 2>&1 &
  pid=$!; for i in $(seq 1 60); do sleep 0.5; [ -s "$f" ] && break; done; sleep 1; kill $pid 2>/dev/null || true; wait $pid 2>/dev/null || true
  python3 -c "from PIL import Image;im=Image.open('$f');im.crop((0,0,780,1688)).save('$f',optimize=True)"; echo "$f"; }
shot home  "tab=home"
shot stock "tab=stock"
shot item  "tab=stock&open=item"
shot exp   "tab=stock&seg=exp"
shot check "tab=check"
shot bag   "tab=check&open=bag"
shot sos   "tab=sos&open=guide"
shot family "tab=home&open=family"
shot msg   "tab=sos&open=msg"
shot score "tab=home&open=score"
shot add   "tab=stock&open=add"
shot dark  "tab=home&theme=dark"
shot onboarding "ob=1"
