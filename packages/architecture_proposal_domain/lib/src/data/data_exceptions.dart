enum DataExceptionType {
  network,
  server,
  unknown,
}

class DataException implements Exception {
  DataException(this.type, {String? message, String? code})
      : message = message ?? type.defaultMessage(),
        code = code ?? 'UNDEFINED';

  final DataExceptionType type;
  final String message;
  final String code;

  @override
  String toString() => message;
}

extension DataExceptionTypeExtension on DataExceptionType {
  String defaultMessage() {
    switch (this) {
      case DataExceptionType.network:
        return 'Network error';
      case DataExceptionType.server:
        return 'Server error';
      case DataExceptionType.unknown:
        return 'Unknown error';
    }
  }
}
