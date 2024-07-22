class ExpectedError implements Exception {
  final String message;

  ExpectedError(this.message);

  @override
  String toString() => message;
}

class UnexpectedError implements Exception {
  final String _message;
  final Exception? _cause;

  UnexpectedError(this._message, [this._cause]);

  @override
  String toString() => _message;

  Exception get cause => _cause ?? this;
}
