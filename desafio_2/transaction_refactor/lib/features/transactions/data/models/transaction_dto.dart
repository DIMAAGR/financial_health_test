import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';
import 'package:transaction_refactor/features/transactions/domain/enums/transaction_type.dart';

/// DTO que representa o JSON bruto de uma única transação retornada pela API.
///
/// Responsabilidade única: mapear *um objeto* do contrato da API para a
/// entidade de domínio. Não itera coleções, não conhece o sistema de erros
/// da infraestrutura — lança [FormatException] nativo do Dart em caso de
/// campo ausente ou inválido. O [FailureHandler] captura essa exceção e a
/// transforma em [ParseFailure] (problema #12).
class TransactionDto {
  const TransactionDto._({
    required this.id,
    required this.description,
    required this.amount,
    required this.rawType,
  });

  final String id;
  final String description;
  final int amount;
  final String rawType;

  /// Chaves do JSON da API — centralizadas aqui para evitar strings mágicas
  /// espalhadas pelo código (problema #21).
  static const _kId = 'id';
  static const _kDescription = 'descricao';
  static const _kAmount = 'valor';
  static const _kType = 'tipo';

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    final id = json[_kId];
    final description = json[_kDescription];
    final amount = json[_kAmount];
    final type = json[_kType];

    if (id is! String || id.isEmpty) {
      throw const FormatException('Campo "id" ausente ou inválido na transação.');
    }
    if (description is! String) {
      throw const FormatException('Campo "descricao" ausente ou inválido.');
    }
    if (amount is! int) {
      throw const FormatException('Campo "valor" deve ser um inteiro em centavos.');
    }
    if (type is! String || type.isEmpty) {
      throw const FormatException('Campo "tipo" ausente ou inválido.');
    }

    return TransactionDto._(id: id, description: description, amount: amount, rawType: type);
  }

  /// Converte este DTO para a entidade de domínio.
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      description: description,
      amount: amount,
      type: _parseType(rawType),
    );
  }

  /// Converte a string bruta da API para [TransactionType].
  ///
  /// Responsabilidade da camada de dados: isola o contrato string da API
  /// do enum de domínio. Retorna [TransactionType.unknown] para valores
  /// não mapeados — nunca silencia informação inesperada (problema #4/#18).
  static TransactionType _parseType(String raw) {
    return switch (raw.toLowerCase()) {
      'receita' || 'income' => TransactionType.income,
      'despesa' || 'expense' => TransactionType.expense,
      _ => TransactionType.unknown,
    };
  }
}
