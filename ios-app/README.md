# そなえ帳 iOSアプリ（Capacitor）

Webアプリ本体（`../index.html`）をネイティブiOSアプリとして同梱したプロジェクト。

- **申請・アップロードは岩崎さんが実施** → 手順は [`岩崎さんへの引き渡し手順.md`](岩崎さんへの引き渡し手順.md)
- このREADMEは開発側向けのメモ

## 現在の状態

| 項目 | 状態 |
|------|------|
| Capacitorプロジェクト | 構築済み（`work.ltv.sonaecho` / そなえ帳） |
| Xcodeプロジェクト生成 | 済み（`ios/App/App.xcworkspace`） |
| アプリアイコン・スプラッシュ | 生成済み（`assets/icon.png` 1024px から） |
| ネイティブ触覚・通知・保存・共有 | 組み込み済み（`../index.html` 内で `NATIVE` 分岐） |
| 防災カードの画像の保存・共有 | 組み込み済み（v1.1。`@capacitor/filesystem` を追加、`Info.plist` に `NSPhotoLibraryAddUsageDescription`） |
| 縦画面固定（iPhone） | 設定済み（`Info.plist`） |
| `pod install` | 手元では未実行（Xcode無し）。**GitHub Actions の macOS 上で `pod install` → ビルドを確認**（v1.0: 2026-09-14、v1.1: CI_RESULT）。Xcodeのある環境で下記を1回実行 |

```bash
npm install
npx cap sync ios      # ← pod install が走る（要 Xcode）
open ios/App/App.xcworkspace
```

> 日本語パスで CocoaPods がエラーになる場合は `export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8` を先に実行。

## 構成

```
ios-app/
├── package.json              npm設定（Capacitor + プラグイン）
├── capacitor.config.json     アプリID・名前・プラグイン設定
├── sync-web.sh               ../のWebアプリを www/ にコピー
├── assets/icon.png           アイコン元画像（1024px）
├── www/                      同梱するWeb資産（sync-web.sh の出力。git管理外）
└── ios/                      Xcodeプロジェクト
    └── App/App.xcworkspace   ← これを開く
```

## よく使うコマンド

```bash
npm install        # 依存取得（初回のみ。node_modules は Dropbox 同期負荷のため削除してある）
npm run sync       # ../index.html の変更をiOSプロジェクトへ反映
npm run icons      # アイコン・スプラッシュ再生成（assets/icon.png から）
npm run open       # Xcodeで開く（要Xcode）
```

## ネイティブ専用の動作

| 機能 | Web版 | ネイティブ版 |
|------|-------|-------------|
| 触覚 | `navigator.vibrate`（iPhoneのSafariでは無反応） | Capacitor Haptics（登録・チェック＝成功触覚、ホイッスル＝強い衝撃） |
| 期限・点検日の通知 | ホーム画面のお知らせのみ | ローカル通知（アプリを閉じていても届く。期限N日前の朝9時、点検日の朝10時） |
| データ保存 | localStorage | localStorage ＋ Preferences の二重保存 |
| 安否連絡・家族カードの共有 | Web Share API（対応ブラウザ）。なければコピー | `@capacitor/share` の共有シート（v1.0 は `navigator.share` を呼んでいたのを v1.1 で修正） |
| 防災カード（紙に残す） | 画像だけを印刷（`window.print`。PDF保存も可）・Web Share API でファイル共有 | `@capacitor/filesystem` でキャッシュに PNG を書き出し → 共有シート（画像を保存・プリント・送信） |

## プラグイン

`package.json` の dependencies: `@capacitor/app`・`@capacitor/core`・`@capacitor/filesystem`（v1.1 で追加）・`@capacitor/haptics`・`@capacitor/ios`・`@capacitor/local-notifications`・`@capacitor/preferences`・`@capacitor/share`。
プラグインを追加したら `npx cap sync ios` で `ios/App/Podfile` と `Podfile.lock` が更新される（手元に Xcode がない場合、Dropbox に `node_modules` を作らないよう、作業用のコピーで `npm install` → `npx cap sync ios` を行い、変わった設定ファイルだけを戻す）。

## メモ

- ホイッスルの音は Web Audio で合成しており、音源ファイルはない。iOSでは端末のマナーモードでも `AudioContext` の音は鳴る（メディア扱い）
- `Pods/` `node_modules/` `www/` `App/public/` はgit管理外
