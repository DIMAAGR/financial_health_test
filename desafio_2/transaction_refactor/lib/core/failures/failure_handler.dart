import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:transaction_refactor/core/failures/app_failure.dart';

/// Centraliza a conversão de exceções em [AppFailure] tipadas,
/// evitando que cada camada repita a lógica de tratamento.
abstract final class FailureHandler {
  static Future<Either<AppFailure, T>> guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on SocketException {
      return const Left(NetworkFailure());
    } on HttpException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ParseException catch (e) {
      return Left(ParseFailure(e.message));
    } on FormatException catch (e) {
      // Lançada pelo TransactionDto.fromJson quando um campo está ausente ou
      // com tipo inválido — exceção nativa do Dart, sem acoplamento ao DTO.
      return Left(ParseFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}

/// Lançada pelo datasource quando o servidor retorna 401 ou 403.
class AuthException implements Exception {
  const AuthException([this.message = 'Autenticação negada.']);
  final String message;
}

/// Lançada quando a decodificação ou validação do JSON falha.
class ParseException implements Exception {
  const ParseException([this.message = 'Formato de resposta inválido.']);
  final String message;
}

/// Lançada quando o servidor retorna um código de erro (4xx/5xx não-auth).
class HttpException implements Exception {
  const HttpException([this.message = 'Erro no servidor.']);
  final String message;
}
