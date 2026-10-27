# CLAUDE.md

Claude Code がこのリポジトリで作業するときの手引き。コードから読み取れることは書かず、
依存の向き・設計上の約束・つまずきやすい点だけを残す。構成が変わったらこのファイルも直す。

## 概要

Porker2 はスクラムポーカーのアプリ。Go (Connect RPC) のバックエンドと Flutter web のフロントエンド、
状態の保存と配信に Redis を使う。proto は `proto/porker/v2/` にあり、`make protoc` で両側のコードを生成する。

## コマンド

`make help` で一覧が出る。よく使うもの:

```bash
make setup/tools         # mockgen, buf, protoc プラグインを入れる
make setup/redis         # 開発用 Redis コンテナ
make protoc              # proto からバックエンド・フロントエンドのコードを生成
make be/run-for-debug    # バックエンド起動 (設定は .envrc、雛形は .envrc.example)
make fe/run-for-debug    # フロントエンド起動 (Chrome, port 53676, env_local.json を --dart-define)
make fe/build-runner     # Router / Freezed のコード生成。状態クラスやルートを変えたら実行
make mock/gen            # gomock 生成。usecase/port や interface/gateway を変えたら実行

cd backend  && go test -race ./...                                   # 単体テスト (Redis 結合テストは Skip)
cd backend  && REDIS_TEST_ADDR=localhost:6379 go test -race ./internal/infrastructure/redis/  # 結合テスト (DB 15 を使う)
cd frontend && flutter analyze && dart analyze --fatal-infos && flutter test   # CI と同じ
cd frontend && flutter build web --release
```

- `make mock/gen` は mockgen が PATH にある必要がある (`go install go.uber.org/mock/mockgen@v0.6.0`)。
  asdf 利用時は `export PATH="$(go env GOPATH)/bin:$PATH"` が要ることがある。
- CI (`.github/workflows/pr-checks.yml`) は Go のテストを Redis サービス付きで、Flutter は `flutter analyze` +
  `dart analyze --fatal-infos` + `flutter test` を回す。`flutter analyze` は analysis_options.yaml の `plugins`
  (riverpod_lint) を読まないので、プラグインのルールは `dart analyze` (= `make fe/lint`) でしか検出されない。

## バックエンド (`backend/`)

ヘキサゴナル構成。依存の向きは `interface` / `infrastructure` → `usecase` → `domain` → `core` の一方向。
`domain` は標準ライブラリと `core` 以外に依存しない。connect-go と protobuf の型は `interface` より内側に出さない。

| 層 | 場所 | 役割 |
| --- | --- | --- |
| core | `internal/core/merror` | アプリ共通のエラー型。`Kind` (NotFound, InvalidArgument, Internal, ...) と `FieldViolations` を持つ |
| domain | `internal/domain/poker`, `internal/domain/user` | `Room` 集約、`Ballot`、VO (`RoomID`, `Point`, `DisplayMode`, `VoteState`, `UserRole`, `user.ID`, `user.Name`)。`snapshot.go` が永続化用の `RoomSnapshot` / `RestoreRoom` |
| usecase | `internal/usecase/interactor`, `internal/usecase/port` | ユースケース (`User`, `Poker`) とリポジトリのインターフェース |
| interface | `internal/interface/controller` | Connect ハンドラ。`convert.go` の `requestFields` が proto のフィールドをドメインのコンストラクタで変換し、違反をまとめて 1 つの InvalidArgument にする |
| | `internal/interface/rpcerr` | `merror` → `connect.Error` の変換はここだけ |
| | `internal/interface/interceptor` | `ErrorInterceptor` (最外、`rpcerr.ToConnect`)、`LogInterceptor` (Kind で WARN / ERROR / INFO を決める) |
| | `internal/interface/session` | Cookie セッション。`authn` ミドルウェアは interceptor の外側で動くため、ここは自前で connect エラーに変換する |
| | `internal/interface/repository` | Redis 実装。永続化モデル (JSON タグ) は `model.go` に置き、ドメインには持ち込まない |
| infrastructure | `internal/infrastructure/connect`, `redis`, `config` | HTTP サーバー (connect-go v2、先頭の interceptor が最外)、`MemDBClient` 実装 (複数キーの原子操作は Lua)、`config.Load()` |

DI は Uber FX。`config.Load()` も `fx.Provide` で供給し、`init()` は使わない。

### 設計上の約束

- **VO はコンストラクタで作る。キャストしない。** VO は非公開フィールドの構造体で、`poker.NewRoomID(raw)` や
  `user.NewName(raw)` が事前条件違反を InvalidArgument で返す。`MustXxx` はテスト専用。
  ゼロ値は「なし」を表す (`IsZero()`)。例: どの部屋にもいないユーザーの `RoomID`。
- **集約の状態変更はメソッド経由。** `Room` のフィールドは非公開で、getter で読む (`Ballots()` はコピーを返す)。
  永続化は `room.Snapshot()` と `poker.RestoreRoom(snapshot)` を使い、復元時に全値を再検証する
  (壊れたデータは Internal として表面化する)。観戦者数は保存せず `Room.ObserverCount()` で導出する。
- **エラーは端まで `merror`。** domain / usecase / repository / redis は `merror` を返し、controller はそのまま返す。
  種別は `merror.IsNotFound(err)` などで判定する。`merror.Wrap*` は外側の Kind が勝つので、
  呼び出し側が検出したい NotFound を包まない。リポジトリは NotFound を透過させる (usecase が分岐する)。
  「セッションはあるがユーザーデータがない」は interactor で Unauthenticated に変換する。
- **検証はドメインで行う。** validator ライブラリはない。controller は `requestFields` でフィールド名を添えて
  コンストラクタを呼ぶだけ。
- **ログ**: クライアント起因は WARN、サーバー起因は ERROR。`kind` 属性で絞り込める。

### テスト

- domain は実オブジェクト (`poker.NewRoom()`, `poker.MustRoomID("12345")`) で書く。
  ID 固定の部屋は `poker.RestoreRoom(poker.RoomSnapshot{RoomID: "12345", VoteState: 1, DisplayMode: 1, AutoOpen: true})`。
- usecase / repository は `internal/test/mock/` の gomock を使う。`UpdateRoomWithLock` に渡した `RoomModifier` を
  動かすには `DoAndReturn` で実 `*poker.Room` に適用する。
- `internal/infrastructure/redis` の結合テストは `REDIS_TEST_ADDR` があるときだけ動く。

## フロントエンド (`frontend/`)

Riverpod を使ったクリーンアーキテクチャ。依存の向きは `presentation` / `infrastructure` → `application` → `domain` → `core`。
`connectrpc` と `lib/infrastructure/generated/` を import してよいのは `infrastructure` だけ。

| 層 | 場所 | 役割 |
| --- | --- | --- |
| core | `lib/core/error` | `ExpectedError` (そのまま利用者に見せる)、`UnauthenticatedError` (ログインへ戻す)、`UnexpectedError` (`cause` を保持) |
| | `lib/core/env`, `lib/core/logger` | `--dart-define` の読み出し、`logger` |
| domain | `lib/domain/point.dart` | `Point` enum (札の文字、T シャツ表記、数値)。手札の並びは `Point.numeric` / `Point.extras` |
| | `lib/domain/room.dart` | `Room` / `Ballot` (freezed) と派生ロジック (`openable`, `average`, `isUnanimity`, `pointOf`, ...)、`DisplayMode` / `VoteState` / `UserRole` |
| | `lib/domain/user.dart` | `UserEntity`、名前の書式 |
| application | `lib/application/port/port.dart` | `Porker2Service` / `LocalStorage` のインターフェース。エラーの契約もここに書いてある |
| | `lib/application/provider.dart` | ポートの provider (override 必須、未設定なら例外) と Notifier の provider |
| | `lib/application/poker.dart` 他 | `Poker` (`Notifier<Room>`) が部屋の購読を持つ。`joinRoom` は購読が終わるまで完了しない Future を返し、別の部屋へ入ると前の購読を cancel する |
| infrastructure | `lib/infrastructure/provider.dart` | `infrastructureOverrides`。`main.dart` の `ProviderScope` に渡す composition root |
| | `lib/infrastructure/adapter/` | `porker2_service.dart` (Connect 実装、`ConnectException` を core のエラー型へ変換、ストリームは `retry.dart` の条件で再接続)、`pb_mapper.dart` (proto ⇄ domain、未知の列挙値は `UnexpectedError`)、`local_storage.dart` |
| presentation | `lib/presentation/router/router.dart` | go_router の typed route。`redirect` がログインを強制し、未ログインで開いた `/poker?room-id=` は `/?room-id=` に送ってログイン後に入室させる。ログイン状態の変化で redirect を再評価する (`refreshListenable`)。redirect は build 中に呼ばれるので provider を変更しない |
| | `lib/presentation/invoke.dart` | ウィジェットからユースケースを呼ぶ入口。失敗は SnackBar、`UnauthenticatedError` はログインへ |
| | `lib/presentation/page`, `widget` | `ref.watch(pokerProvider)` で `Room` を読み、`ref.read(pokerProvider.notifier)` を `invoke` で包んで呼ぶ |

### 設計上の約束

- **派生値は `Room` に置く。** Notifier やウィジェットで計算しない。Notifier は state 以外の公開プロパティを持たない
  (riverpod_lint の `avoid_public_notifier_properties`。`dart analyze` で検出される)。ログイン判定も `UserState.isLoggedIn`。
- **ユースケースは `invoke` 経由で呼ぶ。** `onPressed` から Notifier のメソッドを直接呼ぶと失敗が表に出ず、
  セッション切れでログインへ戻れない。
- **ポートは import せず override する。** application は実装の型を知らない。

### テスト

- application のテストは `ProviderContainer(overrides: [porker2ServiceProvider.overrideWithValue(fake)])` で組む。
  `connectrpc/web.dart` は `dart:js_interop` を使うため VM 上のテストから読み込めない。
  application 側に infrastructure の import を足すとテストが壊れる。
- adapter のテストは connectrpc 付属の `FakeTransportBuilder` を使う (`test/infrastructure/adapter/`)。
- `logger` は初回アクセス時に `Logger.level` を上書きするので、黙らせたいときは先に参照してから `Level.off` にする。

## 共通の仕組み

- **認証**: HttpOnly cookie `psc` にトークン。セッションは 180 分で、認証済みリクエストのたびに延長する。
  フロントエンドは cookie を読まず、`credentials: 'include'` で送るだけ。
- **Redis のキー** (すべて `porker2_` 接頭辞、TTL はユーザー 180 分 / 部屋は更新ごとに 180 分):
  - `porker2_token:(token)` → user_id、`porker2_user_id:(user_id)` → ユーザー JSON、
    `porker2_user_name:(user_name)` → user_id (重複防止)。この 3 つは name キーをガードに 1 つの Lua で原子的に書く
  - `porker2_room_condition:(room_id)` → Redis Stream (MaxLen 1)。最新エントリが部屋の JSON で、購読側は XREAD でブロックする
  - `porker2_room_Lock:(room_id)` → 分散ロック (値は所有者トークン、TTL 3 秒、compare-and-delete で解放)
- **T シャツ表記**: 0→Kids, 0.5→XXS, 1→XS, 2→S, 3→M, 5→L, 8→XL, 13→XXL, 21→3XL。
  平均は数値で計算し、表示だけモードに従う (`averageToTshirtSize`)。観戦者は平均と全員一致の判定に含めない。

## RPC を追加する手順

1. `proto/porker/v2/*.proto` にサービスとメッセージを書き、`make protoc`
2. バックエンド: `interactor` にユースケースを追加 (`merror` を返す。部屋に対する操作は `checkUserRoomJoin`)。
   `controller/porker2.go` で `requestFields` により変換して呼び、成功時に `p.session.RefreshCookie`。
   リポジトリを増やしたら `usecase/port` を更新して `make mock/gen`
3. フロントエンド: `Porker2Service` にメソッドを追加し、`adapter/porker2_service.dart` で `_call` を通して実装
   (新しい型があれば `pb_mapper.dart` にも)。Notifier から呼び出し、ウィジェットは `invoke` で包む
