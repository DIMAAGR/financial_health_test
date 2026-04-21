import 'package:transaction_refactor/core/failures/failure_handler.dart';
import 'package:transaction_refactor/core/services/auth/auth_token_provider.dart';
import 'package:transaction_refactor/features/transactions/data/models/transaction_dto.dart';
import 'package:transaction_refactor/features/transactions/domain/entities/transaction_entity.dart';

/// Contrato do datasource remoto.
///
/// Isola o repositório da origem concreta dos dados (HTTP real, mock, cache).
abstract class TransactionRemoteDataSource {
  /// Retorna a lista de transações do usuário.
  /// Lança [AuthException] ou [HttpException] para erros de transporte.
  /// Lança [FormatException] (via [TransactionDto.fromJson]) se o shape
  /// do JSON for inválido — capturada pelo [FailureHandler] como [ParseFailure].
  Future<List<TransactionEntity>> getTransactions();
}

/// Mock que simula a resposta da API sem dependência de HTTP real.
///
/// Substitui a chamada `http.get(...)` que estava diretamente na UI (problema #7).
/// O token é injetado via [AuthTokenProvider] — não lido de SharedPrefs aqui
/// (problema #8).
///
/// URL alvo (caso fosse real): `https://api.example.com/v1/transactions`
class MockTransactionRemoteDataSource implements TransactionRemoteDataSource {
  const MockTransactionRemoteDataSource(this._authTokenProvider);

  // Mantido para simular a injeção de token que ocorreria em HTTP real:
  // Authorization: Bearer ${_authTokenProvider.getToken()}
  // ignore: unused_field
  final AuthTokenProvider _authTokenProvider;

  static const _mockDelay = Duration(milliseconds: 1200);

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    // Simula latência de rede.
    // Em produção, este método faria: http.get(url, headers: {'Authorization': 'Bearer ${_authTokenProvider.getToken()}'})
    await Future.delayed(_mockDelay);

    // Dados mock que representam a resposta JSON da API.
    // Tipado como Object? para simular o retorno de json.decode() em um
    // client HTTP real — onde o tipo estático é desconhecido em compile time.
    // O DataSource é responsável por verificar o shape da coleção antes de
    // delegar o mapeamento de cada item ao DTO (problema #12).
    final Object raw = _mockApiResponse();

    if (raw is! List) {
      throw const FormatException('Esperava-se uma lista de transações.');
    }

    return raw
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Item de transação com formato inválido.');
          }
          return TransactionDto.fromJson(item).toEntity();
        })
        .toList(growable: false);
  }

  // Valores em centavos (int): R$5.000,00 = 500000, R$320,50 = 32050, etc.
  // Usar int elimina imprecisão de ponto flutuante em operações monetárias.
  List<Map<String, dynamic>> _mockApiResponse() {
    return [
      {'id': '1', 'descricao': 'Salário', 'valor': 500000, 'tipo': 'receita'},
      {'id': '2', 'descricao': 'Aluguel', 'valor': 150000, 'tipo': 'despesa'},
      {'id': '3', 'descricao': 'Mercado', 'valor': 32050, 'tipo': 'despesa'},
      {'id': '4', 'descricao': 'Freelance', 'valor': 80000, 'tipo': 'receita'},
      {'id': '5', 'descricao': 'Internet', 'valor': 9990, 'tipo': 'despesa'},
      {'id': '6', 'descricao': 'Academia', 'valor': 8000, 'tipo': 'despesa'},
      {'id': '7', 'descricao': 'Dividendos', 'valor': 23000, 'tipo': 'receita'},
    ];
  }
}
