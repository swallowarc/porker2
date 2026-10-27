/// 利用者に原因を伝えられる、想定内の失敗 (部屋がない、名前が使用中など)。
class ExpectedError implements Exception {
  final String message;

  ExpectedError(this.message);

  @override
  String toString() => message;
}

/// セッションが無効 (未ログイン、または期限切れ)。画面はログインへ戻す。
class UnauthenticatedError implements Exception {
  const UnauthenticatedError();

  @override
  String toString() => 'unauthenticated';
}

/// 想定外の失敗。[cause] に元の例外を保持する。
class UnexpectedError implements Exception {
  final String message;
  final Object? cause;

  UnexpectedError(this.message, [this.cause]);

  @override
  String toString() =>
      cause == null ? message : '$message (caused by: $cause)';
}
