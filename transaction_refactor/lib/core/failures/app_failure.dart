/// Hierarquia selada de falhas da aplicação.
/// Cada subtipo representa uma categoria de erro, permitindo que a UI
/// exiba mensagens amigáveis sem expor detalhes técnicos.
sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

/// Falha de conectividade (sem rede ou timeout).
class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Sem conexão com a internet. Verifique sua rede.']);
}

/// Erro retornado pelo servidor (5xx).
class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'O servidor retornou uma falha. Tente novamente.']);
}

/// Autenticação expirada ou negada (401/403).
class AuthFailure extends AppFailure {
  const AuthFailure([super.message = 'Sua sessão expirou. Faça login novamente.']);
}

/// Resposta da API com estrutura inesperada.
class ParseFailure extends AppFailure {
  const ParseFailure([super.message = 'Os dados retornaram em um formato inválido.']);
}

/// Falha genérica não categorizada.
class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Não foi possível concluir a operação.']);
}
