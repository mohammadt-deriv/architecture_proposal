enum DataExceptionType {
  network,
  server,
  unknown,
}

class DataException implements Exception {
  DataException(this.type, {String? message})
      : message = message ?? type.defaultMessage();

  final DataExceptionType type;
  final String message;

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
