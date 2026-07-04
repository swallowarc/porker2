# フロントエンド デザイン改善: スマホ対応 / 退室・ログアウト UX

日付: 2026-07-04
対象: `frontend/` (Flutter web)

## 背景・目的

1. ポーカー画面の手札カードが扇状レイアウト(固定幅730px)で、スマホでは両端のカードが画面外に出てタップできず、実質スマホから使えない。
2. 「ルーム退室」(Drawer内・exit_to_appアイコン)と「ログアウト」(AppBar右上・account_circleアイコン)がどちらも「出る」系のUIで紛らわしく、誤操作が起きている。
3. その他、小画面での表示上の問題(AppBarタイトル固定サイズ、BottomBarの縦幅消費、VoteButtonsのはみ出し)がある。

PC表示の扇状カードレイアウトは現状のまま維持する。

## スコープ外

- Reset ボタンの確認ダイアログ追加(ユーザー判断により対応しない)
- バックエンドの変更(本件はフロントエンドのみで完結する)

## 設計

### 1. 手札カードのレスポンシブ化 (`hand_cards.dart`)

切り替え判定は `MediaQuery` の画面幅ではなく、`HandCards` 直下の `LayoutBuilder` が返す実際の利用可能幅で行う。閾値は **750px**(扇状レイアウトの実効幅 約660px + 余白)。これにより「画面は広いが常設Drawer(250px)で内容領域が狭い」ケースも正しく扱える。

- **利用可能幅 ≥ 750px**: 現状の扇状レイアウト(Stack + Positioned + Transform.rotate)を変更せず使用。☕/? の別行配置も現状どおり。
- **利用可能幅 < 750px**: 全11枚(0, 0.5, 1, 2, 3, 5, 8, 13, 21, ☕, ?)を1本の横スクロール行(`SingleChildScrollView(scrollDirection: Axis.horizontal)`)に並べる。
  - カードサイズは現状の 100×130 を維持。回転(Transform.rotate)はしない。
  - カード間隔と左右パディングは、画面端でカードが中途半端に見切れる(=スクロール可能だと視覚的に分かる)値にする。
  - タップ時の選択/解除ロジック、選択時にカードが浮き上がる `HandCard` の既存アニメーションはそのまま利用する。
  - Observer モード時に手札を表示しない挙動は現状どおり。

### 2. 退室/ログアウトの再配置

#### 退室 (Leave)

- ポーカー画面の AppBar のタイトル行の先頭(ハンバーガーメニューの右)に、アイコン+ラベル付きボタン **"Leave"** を常時表示する。
- 押下時の確認ダイアログ(TwoChoiceDialog)と退室処理は現状の Drawer 内実装と同じ。
- Drawer 内の「Leave room」項目は削除する。

#### ログアウト (Logout)

- AppBar 右上の `account_circle` アイコン直押しでダイアログを出す現状実装を廃止。
- 代わりにアバターアイコンの `PopupMenuButton` にする:
  - メニュー先頭にユーザー名を表示(選択不可項目)。
  - "Logout" 項目(`Icons.logout` アイコン付き)を選ぶと、現状どおり確認ダイアログ → ログアウト処理。
- ポーカー画面・ルーム選択画面の両方の AppBar(`Porker2AppBar`)で共通に適用する。

これにより、1タップで押せる「出る」ボタンは退室のみとなり、ログアウトはメニューを1段開かないと到達できないため、誤操作が構造的に発生しなくなる。

### 3. その他の小画面対応

- **AppBar タイトル** (`app_bar.dart`): fontSize 30 固定をやめ、`FittedBox`(scaleDown)で利用可能幅に収まるように縮小させる。Room URL コピーのタップ動作は維持。
- **BottomBar** (各ページ): 画面幅が `smallScreenBoundary`(600px)未満のとき非表示にし、手札の表示領域を確保する。GitHub リンクは失われるがログイン画面等の広い画面では引き続き表示される。
- **VoteButtons** (`vote_buttons.dart`): 固定幅400pxのコンテナを、画面幅に収まる幅(`min(400, 利用可能幅)`相当)にして幅375px端末でのはみ出しを解消する。

## 影響ファイル

- `frontend/lib/presentation/widget/poker/hand_cards.dart` — レイアウト分岐追加
- `frontend/lib/presentation/widget/app_bar.dart` — Leave ボタン、アバターメニュー、タイトルの FittedBox 化
- `frontend/lib/presentation/page/poker_page.dart` — Drawer から Leave room 削除、AppBar への退室ハンドラ受け渡し
- `frontend/lib/presentation/page/room_select_page.dart` — 新しいログアウトメニューの適用(app_bar.dart 側の変更で吸収される想定)
- `frontend/lib/presentation/widget/bottom_bar.dart` または各ページ — 小画面での非表示
- `frontend/lib/presentation/widget/poker/vote_buttons.dart` — はみ出し修正

## エラー処理

既存の `invoke()` ヘルパー(エラー表示)と確認ダイアログをそのまま使い、新規のエラー処理は追加しない。

## テスト・検証

- `cd frontend && flutter analyze` が通ること。
- `make fe/run-for-debug` で起動し、ブラウザの devtools レスポンシブモードで確認:
  - 幅 375px / 430px: 手札が横スクロール1列で全カード選択可能。VoteButtons がはみ出さない。BottomBar 非表示。
  - 幅 1024px 以上: 従来どおりの扇状レイアウト・常設 Drawer。
  - 幅 750〜1024px(Drawer がハンバーガー化する帯域): 扇状レイアウトが収まる。
- Leave ボタン → 確認 → ルーム選択画面へ遷移。アバターメニュー → Logout → 確認 → ログイン画面へ遷移。
