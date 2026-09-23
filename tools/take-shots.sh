#!/bin/bash
# 資料/プレゼン資料/screenshots/*.png を生成する。サンプルデータ（?demo=1）で各画面を撮影
# 音は出さない（--mute-audio）。撮影用の URL パラメータは index.html の init を参照（shot=1 でアニメーションとトーストを止める）
set -e
cd "$(dirname "$0")/.."
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT="資料/プレゼン資料/screenshots"; mkdir -p "$OUT"
run(){ f="$1"; url="$2"; size="$3"; scale="$4"; ud="$(mktemp -d)"; rm -f "$f"
  "$CH" --headless=new --disable-gpu --mute-audio --hide-scrollbars --force-device-scale-factor="$scale" --window-size="$size" --user-data-dir="$ud" --timeout=4000 --screenshot="$PWD/$f" "$url" >/dev/null 2>&1 &
  pid=$!; for i in $(seq 1 60); do sleep 0.5; [ -s "$f" ] && break; done; sleep 1; kill $pid 2>/dev/null || true; wait $pid 2>/dev/null || true; rm -rf "$ud"; }
shot(){ n="$1"; q="$2"; f="$OUT/$n.png"
  run "$f" "file://$PWD/tools/shot.html?$q" "800,844" 2
  python3 -c "from PIL import Image;im=Image.open('$f');im.crop((0,0,780,1688)).save('$f',optimize=True)"; echo "$f"; }
shot home  "tab=home"
shot stock "tab=stock"
shot place "tab=stock&group=place"
shot item  "tab=stock&open=item"
shot exp   "tab=stock&seg=exp"
shot shop  "tab=stock&seg=shop"
shot check "tab=check"
shot bag   "tab=check&open=bag"
shot sos   "tab=sos&open=guide"
shot ration "tab=sos&open=ration"
shot paper "tab=sos&open=paper"
shot family "tab=home&open=family"
shot msg   "tab=sos&open=msg"
shot score "tab=home&open=score"
shot add   "tab=stock&open=add"
shot dark  "tab=home&theme=dark"
shot onboarding "ob=1"
# 紙に残す防災カード（A4・1240×1754）そのもの
f="$OUT/paper-card.png"; run "$f" "file://$PWD/index.html?demo=1&shot=1&open=papercard" "1240,1754" 1
python3 -c "from PIL import Image;im=Image.open('$f').convert('RGB');im.crop((0,0,1240,1754)).save('$f',optimize=True)"; echo "$f"
