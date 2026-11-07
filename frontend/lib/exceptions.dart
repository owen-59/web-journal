class ResponseParsingException implements Exception {
  const ResponseParsingException();

  @override
  String toString() => "ResponseParsingException";
}

class ResponseNotMapException extends ResponseParsingException {
  final dynamic obj;

  const ResponseNotMapException(this.obj);

  @override
  String toString() => "ResponseNotMapException: $obj was not a Map.";
}

class ResponseValueInvalidException<T> extends ResponseParsingException {
  final dynamic obj;

  const ResponseValueInvalidException(this.obj);

  @override
  String toString() =>
      "ResponseValueInvalidException: $obj was not $T, was ${obj.runtimeType}";
}
