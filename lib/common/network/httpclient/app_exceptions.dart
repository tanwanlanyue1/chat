
/// 自定义异常
class AppException implements Exception {
  final String message;
  final int code;

  AppException(
    this.code,
    this.message,
  );


  @override
  String toString() {
    return '$runtimeType{message: $message, code: $code}';
  }

  String getMessage() {
    return message;
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException(super.code, super.message);
}

/// 未认证异常
class UnauthorizedException extends AppException {
  UnauthorizedException(super.code, super.message);
}

/// json解析异常
class JsonParseException extends AppException {
  JsonParseException(super.code, super.message);
}
