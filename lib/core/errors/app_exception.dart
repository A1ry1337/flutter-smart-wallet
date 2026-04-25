class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode});
}
