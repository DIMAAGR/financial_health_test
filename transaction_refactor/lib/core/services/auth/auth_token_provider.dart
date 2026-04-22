/// Abstração que provê o token de autenticação.
///
/// A tela e o datasource dependem apenas desta interface,
/// nunca de SharedPreferences ou qualquer storage concreto.
abstract class AuthTokenProvider {
  /// Retorna o token atual, ou null se o usuário não estiver autenticado.
  String? getToken();
}

/// Implementação de demonstração: retorna um token fixo para o app assíncrono.
///
/// Não é um mock de teste; representa uma borda simples substituível por
/// storage seguro ou sessão real sem alterar as camadas acima.
class DemoAuthTokenProvider implements AuthTokenProvider {
  const DemoAuthTokenProvider();

  @override
  String? getToken() => 'demo-bearer-token-12345';
}
