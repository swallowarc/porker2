# フロントエンド スマホ対応 / 退室・ログアウト UX 実装プラン

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** ポーカー画面をスマホ幅(375px〜)で使えるようにし、退室/ログアウトの誤操作を構造的に防ぐ UI に変更する。

**Architecture:** Flutter web フロントエンドのプレゼンテーション層のみの変更。手札は `LayoutBuilder` の実利用可能幅 750px を閾値に「扇状レイアウト(現状維持)」と「横スクロール1列」を切り替える。退室は AppBar 常設の Leave ボタンへ、ログアウトはアバターの `PopupMenuButton` 内へ移動する。バックエンド・ドメイン層の変更は無し。

**Tech Stack:** Flutter (>= 3.38.4, Dart SDK ^3.11.0), hooks_riverpod, go_router

**Spec:** `docs/superpowers/specs/2026-07-04-frontend-mobile-and-exit-ux-design.md`

## Global Constraints

- Flutter >= 3.38.4 / Dart SDK ^3.11.0 (pubspec.lock / pubspec.yaml より)
- 手札レイアウト切替閾値: **750px**(`MediaQuery` の画面幅ではなく `LayoutBuilder` の利用可能幅で判定)
- カードサイズ **100×130** は変更しない。PC の扇状レイアウトは現状のまま維持する
- BottomBar 非表示閾値: `smallScreenBoundary`(= 600、`lib/presentation/const.dart` 定義済み)
- VoteButtons の幅: `min(400, 利用可能幅)` 相当
- Reset ボタンの確認ダイアログは追加しない(スコープ外)
- エラー処理は既存の `invoke()` ヘルパーと `TwoChoiceDialog` をそのまま使う。新規エラー処理は追加しない
- テストゲートは `flutter analyze`(仕様の検証方針)。`test/widget_test.dart` は Flutter テンプレートのカウンターテストのままで **既存から失敗する** ため `flutter test` はゲートにしない(本件のスコープ外、削除もしない)
- コミットメッセージ末尾に `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` を付ける

---

### Task 0: Flutter SDK セットアップ(環境に flutter コマンドが無い場合のみ)

**Files:** なし(環境セットアップのみ。リポジトリへのコミットは無し)

**Interfaces:**
- Produces: `flutter` コマンドが PATH で使えること。以降の全タスクが `flutter analyze` に依存する

- [ ] **Step 1: flutter の有無を確認**

Run: `zsh -ic 'which flutter' || asdf list flutter 2>/dev/null`
既に使えるなら Step 5 へ。

- [ ] **Step 2: asdf で Flutter プラグインを追加**

```bash
asdf plugin add flutter https://github.com/asdf-community/asdf-flutter.git
```

- [ ] **Step 3: Flutter をインストールして有効化**

```bash
asdf install flutter latest
# asdf 0.16+ の場合:
asdf set -u flutter $(asdf latest flutter)
# 古い asdf の場合は代わりに: asdf global flutter $(asdf latest flutter)
```

Expected: `flutter --version` が 3.38.4 以上を表示(ダウンロードに数分かかる)。
`.tool-versions` がリポジトリ内に生成された場合はコミットしない(`asdf set -u` はホーム側に書くので通常は生成されない)。

- [ ] **Step 4: 依存取得**

```bash
cd frontend && flutter pub get
```

Expected: `Got dependencies!`

- [ ] **Step 5: ベースライン確認**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`(既存コードで警告が出る場合はその内容を記録し、以降のタスクでは「新規の警告を増やさない」をゲートとする)

---

### Task 1: 手札カードのレスポンシブ化

**Files:**
- Modify: `frontend/lib/presentation/widget/poker/hand_cards.dart`(全面書き換え)

**Interfaces:**
- Consumes: `HandCard`(`hand_card.dart`、変更しない)、`pokerProvider` / `userProvider`
- Produces: `HandCards` ウィジェット(外部インターフェース変更なし。`poker_page.dart` からの利用方法は不変)

**設計メモ:** 現状 onTap のトグルロジックが 3 箇所に重複しているので、`buildCard` ローカル関数に集約する(DRY)。ロジック自体は等価: `myPoint == point` なら `POINT_UNSPECIFIED` を、そうでなければ `point` を castVote。

- [ ] **Step 1: hand_cards.dart を以下の内容に書き換える**

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pbenum.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/poker/hand_card.dart';

const List<Point> pointOrder = [
  Point.POINT_0,
  Point.POINT_0_5,
  Point.POINT_1,
  Point.POINT_2,
  Point.POINT_3,
  Point.POINT_5,
  Point.POINT_8,
  Point.POINT_13,
  Point.POINT_21,
];

const List<Point> _extraPoints = [
  Point.POINT_COFFEE,
  Point.POINT_QUESTION,
];

const _pointListLength = 9;
const double _fanLayoutMinWidth = 750;

class HandCards extends HookConsumerWidget {
  const HandCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final pokerNotifier = ref.read(pokerProvider.notifier);
    final poker = ref.watch(pokerProvider);

    final myPoint = pokerNotifier.myPoint(user.userID);
    final isObserver = pokerNotifier.isObserver(user.userID);

    if (isObserver) {
      return Container();
    }

    HandCard buildCard(Point point, int delayMilliseconds) => HandCard(
          point: point,
          onTap: () {
            if (!pokerNotifier.votable) {
              return;
            }
            pokerNotifier
                .castVote(myPoint == point ? Point.POINT_UNSPECIFIED : point);
          },
          delayMilliseconds: delayMilliseconds,
          selected: myPoint == point,
          displayMode: poker.displayMode,
        );

    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth >= _fanLayoutMinWidth
              ? _fanLayout(buildCard)
              : _scrollLayout(buildCard),
    );
  }

  Widget _fanLayout(HandCard Function(Point, int) buildCard) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 730,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: List.generate(_pointListLength, (index) {
                    const indexCenter = _pointListLength ~/ 2;
                    final angle = (index - indexCenter) * 0.05;
                    final leftOffset = (index - indexCenter) * 70.0;

                    double topOffset = 8;
                    switch (index) {
                      case 3:
                      case 5:
                        topOffset = 10;
                        break;
                      case 2:
                      case 6:
                        topOffset = 18;
                        break;
                      case 1:
                      case 7:
                        topOffset = 30;
                        break;
                      case 0:
                      case 8:
                        topOffset = 46;
                        break;
                    }

                    return Positioned(
                      left: constraints.maxWidth / 2 + leftOffset - 50,
                      top: topOffset,
                      child: Transform.rotate(
                        angle: angle,
                        child: buildCard(pointOrder[index], index * 100),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCard(Point.POINT_COFFEE, 1000),
              const SizedBox(width: 20),
              buildCard(Point.POINT_QUESTION, 1100),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scrollLayout(HandCard Function(Point, int) buildCard) {
    final allPoints = [...pointOrder, ..._extraPoints];

    return SizedBox(
      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var i = 0; i < allPoints.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: buildCard(allPoints[i], i * 100),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

レイアウト計算の根拠(実装時に迷わないため):
- スクロール行の高さ 180 = カード 130 + 下余白 10 + 選択時の浮き上がり(`SlideTransition` の `Offset(0, -0.2)` ≒ 26px)+ 余裕。カードを `CrossAxisAlignment.end` で下寄せすることで、浮き上がってもスクロールビューの `Clip.hardEdge` に切られない。
- カード幅 100 + 間隔 12: 幅 375px 端末では左パディング 12 の後に 3 枚 + 4 枚目が約 27px だけ見える → 「スクロールできる」ことが視覚的に分かる(仕様の要件)。
- 扇状レイアウト(`_fanLayout`)は旧コードの移植であり、座標・角度・delay の値を変えないこと。

- [ ] **Step 2: analyze で検証**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`(または Task 0 で記録したベースラインから増えていない)

- [ ] **Step 3: コミット**

```bash
git add frontend/lib/presentation/widget/poker/hand_cards.dart
git commit -m "feat(fe): make hand cards responsive with horizontal scroll on narrow screens

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 2: AppBar — Leave ボタン受け口・ログアウトのメニュー化・タイトルの FittedBox 化

**Files:**
- Modify: `frontend/lib/presentation/widget/app_bar.dart`(全面書き換え)

**Interfaces:**
- Consumes: `TwoChoiceDialog`(`dialog.dart`)、`invoke()`、`userProvider`(`.userName` を watch)
- Produces: `Porker2AppBar` に **省略可能な named パラメータ `VoidCallback? onLeave`** を追加。`onLeave != null` のときタイトル行先頭に "Leave" ボタン(`Icons.exit_to_app` + ラベル)を表示し、押下でそのコールバックを呼ぶ。ダイアログ表示は呼び出し側(Task 3 の poker_page)の責務。既存呼び出し(room_select_page 等)は無変更でコンパイルが通る

- [ ] **Step 1: app_bar.dart を以下の内容に書き換える**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/const.dart';
import 'package:porker2fe/presentation/invoke.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/dialog.dart';
import 'package:porker2fe/presentation/widget/rainbow_text.dart';

class Porker2AppBar extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool enableDrawer;
  final bool enableLogout;
  final bool enableCopyRoomURL;
  final VoidCallback? onLeave;

  const Porker2AppBar({
    super.key,
    required this.title,
    required this.enableDrawer,
    required this.enableLogout,
    required this.enableCopyRoomURL,
    this.onLeave,
  }) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider.notifier);
    final userName = ref.watch(userProvider).userName;
    final actions = <Widget>[];

    final bool isMediumScreen =
        MediaQuery.of(context).size.width < mediumScreenBoundary;

    if (enableLogout) {
      actions.add(
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Account',
          onSelected: (value) {
            if (value != 'logout') {
              return;
            }
            showDialog<void>(
              context: context,
              builder: (_) => TwoChoiceDialog(
                title: 'Logout',
                message: 'Do you want to log out?',
                onYes: () => invoke(context, () => user.logout(),
                    (_) => GoRouter.of(context).go('/')),
              ),
            );
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Text(userName),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }

    final txt = RainbowText(
      text: title,
      style: const TextStyle(
        fontSize: 30,
      ),
    );

    final Widget titleContent = enableCopyRoomURL
        ? Tooltip(
            message: "Copy room URL",
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  final currentUrl = Uri.base.toString();
                  Clipboard.setData(ClipboardData(text: currentUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('URL copied to clipboard!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: txt,
              ),
            ),
          )
        : txt;

    return AppBar(
      title: Row(
        children: [
          if (onLeave != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: onLeave,
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Leave'),
              ),
            ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: titleContent,
            ),
          ),
        ],
      ),
      actions: actions,
      automaticallyImplyLeading: false,
      leading: enableDrawer && isMediumScreen
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Drawerを開く
              },
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
```

変更点の要約(旧コードとの差分):
1. `onLeave` パラメータ追加。非 null のときタイトル `Row` の先頭に `TextButton.icon`(Leave)を置く。
2. ログアウト: `IconButton` 直押しダイアログ → `PopupMenuButton<String>`。先頭にユーザー名(`enabled: false`)、区切り線、`Logout` 項目。Logout 選択時のダイアログと処理は旧実装と同一。
3. タイトル: `fontSize: 30` は維持しつつ `Flexible` + `FittedBox(fit: BoxFit.scaleDown)` で幅に収まるよう縮小。Room URL コピーのタップ動作は `titleContent` 内にそのまま維持。

- [ ] **Step 2: analyze で検証**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`(既存呼び出し側は `onLeave` 省略可なのでエラーにならないこと)

- [ ] **Step 3: コミット**

```bash
git add frontend/lib/presentation/widget/app_bar.dart
git commit -m "feat(fe): add leave button slot and move logout into avatar menu on app bar

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 3: ポーカー画面 — Leave の AppBar 移設と Drawer 項目削除

**Files:**
- Modify: `frontend/lib/presentation/page/poker_page.dart`

**Interfaces:**
- Consumes: Task 2 の `Porker2AppBar.onLeave`(`VoidCallback?`)、既存の `TwoChoiceDialog` / `invoke()` / `pokerProvider.notifier.leaveRoom()`
- Produces: なし(画面完結)

- [ ] **Step 1: AppBar 呼び出しに onLeave を渡す**

`poker_page.dart` の `Scaffold` 内 `appBar:`(現在 82〜87 行目)を以下に置き換える:

```dart
      appBar: Porker2AppBar(
        title: 'Room ID: ${poker.roomID}',
        enableDrawer: true,
        enableLogout: true,
        enableCopyRoomURL: true,
        onLeave: () {
          showDialog<void>(
            context: context,
            builder: (_) => TwoChoiceDialog(
              title: 'Leave Room',
              message: 'Do you want to leave this poker?',
              onYes: () => invoke(
                  context,
                  () => ref.read(pokerProvider.notifier).leaveRoom(),
                  (_) => GoRouter.of(context).go('/room')),
            ),
          );
        },
      ),
```

ダイアログのタイトル・メッセージ・処理は旧 Drawer 実装と同一文言にすること。必要な import(`dialog.dart`, `invoke.dart`, `go_router`)は全て既存。

- [ ] **Step 2: Drawer から Leave room 項目を削除**

`_Drawer` 内の以下の `ListTile`(現在 177〜192 行目)を丸ごと削除する:

```dart
          ListTile(
            title: const Text('Leave room'),
            subtitle: const Text('Exit this poker session', style: TextStyle(fontSize: 12)),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (_) => TwoChoiceDialog(
                  title: 'Leave Room',
                  message: 'Do you want to leave this poker?',
                  onYes: () => invoke(context, () => pokerNotifier.leaveRoom(),
                      (_) => GoRouter.of(context).go('/room')),
                ),
              );
            },
          ),
```

削除後、`_Drawer` 内で `dialog.dart` の import が未使用になる場合は import も削除する(`flutter analyze` の unused_import 警告で検出できる。ただし Step 1 で page 内の別箇所が使うため通常は残る)。

- [ ] **Step 3: analyze で検証**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: コミット**

```bash
git add frontend/lib/presentation/page/poker_page.dart
git commit -m "feat(fe): move leave room action from drawer to app bar

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 4: BottomBar の小画面非表示

**Files:**
- Modify: `frontend/lib/presentation/widget/bottom_bar.dart`

**Interfaces:**
- Consumes: `smallScreenBoundary`(`const.dart`、import 済み)
- Produces: `BottomBar` は画面幅 < 600px のとき `SizedBox.shrink()` を返す(全ページ一括で適用されるため、各ページ側の変更は不要)

- [ ] **Step 1: build メソッド先頭に早期 return を追加**

`bottom_bar.dart` の `build` メソッド冒頭(`return BottomAppBar(` の直前)に以下を挿入:

```dart
    if (MediaQuery.of(context).size.width < smallScreenBoundary) {
      return const SizedBox.shrink();
    }
```

- [ ] **Step 2: analyze で検証**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: コミット**

```bash
git add frontend/lib/presentation/widget/bottom_bar.dart
git commit -m "feat(fe): hide bottom bar on small screens

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 5: VoteButtons のはみ出し修正

**Files:**
- Modify: `frontend/lib/presentation/widget/poker/vote_buttons.dart`

**Interfaces:**
- Consumes: なし
- Produces: なし(見た目のみ。ボタンの動作・サイズ 150×50 は不変)

- [ ] **Step 1: 固定幅 400 を maxWidth 400 に変更**

`vote_buttons.dart` の `Container`(現在 14〜17 行目)を変更:

```dart
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 30),
```

(`width: 400,` の行を削除し、`constraints:` を追加。それ以外は不変。)
これで利用可能幅が 400px 未満(幅 375px 端末等)のときは幅いっぱいに縮み、`Row`(150px ボタン×2、`spaceAround`)は 300px あれば収まるためはみ出さない。

- [ ] **Step 2: analyze で検証**

Run: `cd frontend && flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: コミット**

```bash
git add frontend/lib/presentation/widget/poker/vote_buttons.dart
git commit -m "fix(fe): prevent vote buttons overflow on narrow screens

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 6: ビルド確認と手動検証

**Files:** なし

- [ ] **Step 1: リリースビルドが通ることを確認(コンパイルの最終ゲート)**

Run: `cd frontend && flutter build web --release`
Expected: `✓ Built build/web`

- [ ] **Step 2: 手動検証(要ブラウザ。ヘッドレス環境ではユーザーに依頼する)**

`make setup/redis && make be/run-for-debug`(別プロセス)+ `make fe/run-for-debug` で起動し、devtools レスポンシブモードで確認:

- 幅 375px / 430px: 手札が横スクロール1列で全 11 カード(0〜21, ☕, ?)を選択できる。端でカードが中途半端に見切れてスクロール可能と分かる。VoteButtons がはみ出さない。BottomBar 非表示。
- 幅 1024px 以上: 従来どおり扇状レイアウト + ☕/? 別行 + 常設 Drawer。BottomBar 表示。
- 幅 750〜1024px(Drawer がハンバーガー化する帯域): 扇状レイアウトが収まって表示される。
- Leave ボタン(AppBar タイトル左) → 確認ダイアログ → Yes → ルーム選択画面へ遷移。Drawer に Leave room が無いこと。
- アバターアイコン → メニューにユーザー名(押せない)と Logout → 確認ダイアログ → Yes → ログイン画面へ遷移。ルーム選択画面のアバターでも同様。
- カード選択/解除、選択時の浮き上がりアニメーションが両レイアウトで動くこと。Observer モードで手札が消えること。
