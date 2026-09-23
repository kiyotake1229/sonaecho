# プレゼン資料（提案書ページ・PDF）

- 公開URL（Claude Artifact。スマホでもPCでも見られる）: https://claude.ai/artifact/6uBubGU9VS9zPuvLNiGHXJ
- PDF: `そなえ帳_提案書.pdf`（A4横・10ページ。そのまま配れる）
- 話す台本: [../プレゼンの進め方.md](../プレゼンの進め方.md)
- 文書版の提案書: [../岩崎さんへの提案書.md](../岩崎さんへの提案書.md)
- `提案書.html` … 提案書ページの元ファイル。文言を直すときはここを編集する（Google Fonts と QRコード用のスクリプトをネットから読む）
- `screenshots/` … アプリの画面（サンプルデータの状態）と、紙に残す防災カード（`paper-card.png`）
- 構成: 表紙（何日もつかのホーム）/ 01 なぜこのテーマか / 02 何が違うのか（何日もつか・期限切れを出さない・平時と非常時）/ 03 画面 / 04 収益と展開 / 05 5分デモの順番 / 06 現在の状態 / 07 URLと資料
- 見た目はアプリ本体と同じ配色（深緑 #0E7C6B・淡い緑の地）。見出しは Zen Kaku Gothic New、本文は BIZ UDPゴシック

## 作り直す

アプリのフォルダで次を実行する（Chrome が必要）。

```bash
bash tools/take-shots.sh   # 画面の画像を撮り直す（音は出さない）
bash tools/make-pdf.sh     # 提案書.html から PDF を作る（A4横）
```

Artifact の更新は、Claude Code で `資料/プレゼン資料/提案書.html` を上記URLに公開し直す（`screenshots/` の画像も一緒に載せる）。
