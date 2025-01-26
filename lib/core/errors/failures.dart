abstract class Failure {
  final String message;
  final StackTrace? stackTrace; // Optional for debugging purposes.

  Failure({required this.message, this.stackTrace});

  @override
  String toString() => 'Failure(message: $message)';
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.stackTrace});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.stackTrace});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.stackTrace});
}

class DatabaseFailure extends Failure {
  DatabaseFailure({required super.message, super.stackTrace});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message, super.stackTrace});
}

class UnknownFailure extends Failure {
  UnknownFailure({required super.message, super.stackTrace});
}
