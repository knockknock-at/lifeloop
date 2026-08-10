# lifeloop App Store申請 進行チェックリスト

作成日: 2026-08-10
対象アプリ: lifeloop
提供者: Knock Knock 株式会社
Bundle ID: at.knockknock.lifeloop

このファイルは、App Store申請を一つずつ片付けるための進行表です。
各ステップは、ユーザーが実施し、エビデンスを添えて報告し、Codexが確認してから次へ進みます。

## 進め方

1. Codexが「次に実施する1アクション」を提示する。
2. ユーザーがApple Developer / App Store Connect / Xcode上で実施する。
3. ユーザーが完了報告とエビデンスを添付する。
4. Codexが内容を確認し、問題がなければ次の1アクションを提示する。

## 0. 事前状態

- [x] ローカルリポジトリは `https://github.com/knockknock-at/lifeloop.git` に同期済み。
- [x] Bundle IDは `at.knockknock.lifeloop` に設定済み。
- [x] iPhone実機ビルドとインストール成功済み。
- [x] 公開ページと提出用文書は `docs/` と `AppStoreSubmission/` に準備済み。

## 1. Apple Developer Program

- [ ] Apple Developer ProgramにOrganizationとして登録する。
  - 目的: App Store上の販売元を `Knock Knock 株式会社` にする。
  - エビデンス: Apple DeveloperのMembership画面、または登録完了メールのスクリーンショット。
  - 注意: Individual登録では販売元が個人名になる。

- [ ] Apple Developer Programの年会費支払いを完了する。
  - エビデンス: MembershipがActiveになっている画面、または支払い完了メール。

- [ ] App Store Connectに入れることを確認する。
  - エビデンス: App Store Connectトップ、またはApps画面のスクリーンショット。

## 2. 契約・税務・銀行情報

- [ ] App Store Connectの Agreements, Tax, and Banking に未処理警告がないことを確認する。
  - エビデンス: Agreements, Tax, and Banking画面のスクリーンショット。
  - 注意: 無料アプリだけでも契約警告があると申請や公開で止まることがある。

## 3. Bundle ID / Identifiers確認

- [ ] Apple DeveloperのCertificates, Identifiers & Profilesで `at.knockknock.lifeloop` を確認する。
  - エビデンス: Identifier詳細画面のスクリーンショット。
  - 注意: XcodeのBundle IDと一致している必要がある。

## 4. App Store Connect アプリ作成

- [ ] App Store Connectで新規アプリを作成する。
  - 入力:
    - Name: `lifeloop`
    - Bundle ID: `at.knockknock.lifeloop`
    - SKU: `lifeloop-ios-001`
    - Primary Category: `Lifestyle`
    - Secondary Category: `Productivity`
  - エビデンス: App Information画面のスクリーンショット。
  - 参照: `app-store-connect-fields-ja.md`

## 5. 商品ページ情報

- [ ] アプリ名、サブタイトル、説明、キーワード、カテゴリを入力する。
  - エビデンス: App Store Product PageまたはApp Information画面のスクリーンショット。
  - 参照: `app-store-connect-fields-ja.md`

- [ ] URLを入力する。
  - Privacy Policy URL: `https://knockknock-at.github.io/lifeloop/docs/lifeloop/privacy.html`
  - Support URL: `https://knockknock-at.github.io/lifeloop/docs/lifeloop/support.html`
  - Marketing URL: `https://www.knockknock.at/products/lifeloop`
  - エビデンス: URL入力欄のスクリーンショット。

- [ ] スクリーンショットをアップロードする。
  - ファイル: `AppStoreScreenshots/final/`
  - エビデンス: スクリーンショット欄に5枚が並んだ画面。

## 6. App Privacy

- [ ] App Privacyを入力する。
  - 回答案: 現行実装ではData Collectedは `No`、Trackingは `No`。
  - エビデンス: App Privacy回答完了画面。
  - 参照: `app-privacy-answers.md`
  - 注意: サーバー送信、広告、分析SDK、第三者SDKを追加した場合は回答を見直す。

## 7. 年齢レーティング / コンプライアンス

- [ ] 年齢レーティング質問に回答する。
  - エビデンス: 年齢レーティング結果画面。
  - 注意: 医療、服薬、緊急、安全管理用途として回答しない。説明文とも矛盾させない。

- [ ] 輸出コンプライアンス質問に回答する。
  - エビデンス: 輸出コンプライアンス回答画面。
  - 参照: `export-compliance.md`

## 8. Archive / Upload

- [ ] XcodeでArchiveを作成する。
  - エビデンス: OrganizerにlifeloopのArchiveが表示された画面。

- [ ] App Store Connectへビルドをアップロードする。
  - エビデンス: Upload完了画面、またはApp Store ConnectでProcessing中/完了のビルド画面。

## 9. ビルド選択 / Review Notes

- [ ] App Store Connectで処理済みビルドを選択する。
  - エビデンス: Version画面にビルドが選択されているスクリーンショット。

- [ ] Review Notesを入力する。
  - 参照: `app-review-notes.txt`
  - エビデンス: App Review Information画面。

- [ ] App Review Contact Informationを入力する。
  - エビデンス: 連絡先入力欄のスクリーンショット。
  - 注意: 実際にAppleから連絡を受けられる電話番号とメールを使う。

## 10. 最終確認 / Submit for Review

- [ ] `pre-submission-checklist.md` を最後まで確認する。
  - エビデンス: チェック済み項目、または確認完了の報告。

- [ ] Submit for Reviewを実行する。
  - エビデンス: Waiting for Review または審査提出完了画面。

