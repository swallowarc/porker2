class ExpectedError implements Exception {
  final String message;

  ExpectedError(this.message);

  @override
  String toString() => message;
}

class UnexpectedError implements Exception {
  final String message;
  final Exception? exception;

  UnexpectedError(this.message, [this.exception]);

  @override
  String toString() => message;

  Exception get cause => exception ?? this;
}
