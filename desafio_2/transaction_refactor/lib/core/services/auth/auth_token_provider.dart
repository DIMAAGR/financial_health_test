/// Abstração que provê o token de autenticação.
///
/// A tela e o datasource dependem apenas desta interface,
/// nunca de SharedPreferences ou qualquer storage concreto.
abstract class AuthTokenProvider {
  /// Retorna o token atual, ou null se o usuário não estiver autenticado.
  String? getToken();
}

/// Implementação mock: retorna um token fixo para fins de teste.
class MockAuthTokenProvider implements AuthTokenProvider {
  const MockAuthTokenProvider();

  @override
  String? getToken() => 'mock-bearer-token-12345';
}
