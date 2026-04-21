import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:financial_health_dashboard/src/core/failures/app_failure.dart';

abstract final class FailureHandler {
  const FailureHandler._();

  static Future<Either<AppFailure, T>> guard<T>(Future<T> Function() operation) async {
    try {
      final result = await operation();
      return Right(result);
    } on Exception catch (e) {
      switch (e) {
        case TimeoutException():
        case SocketException():
          return const Left(NetworkFailure());
        case FormatException():
          return const Left(ParsingFailure());
        case FileSystemException():
          return const Left(StorageFailure());
        default:
          return Left(UnknownFailure(e.toString()));
      }
    } on Error catch (e) {
      switch (e) {
        case ArgumentError(:final message):
          return Left(ValidationFailure(message?.toString() ?? 'Dados inválidos.'));
        case TypeError():
          return const Left(ParsingFailure());
        case StateError():
          return const Left(StorageFailure());
        case UnsupportedError():
          return const Left(ServerFailure());
        default:
          return Left(UnknownFailure(e.toString()));
      }
    }
  }
}
