/// Parâmetro vazio para casos de uso que não requerem entrada.
///
/// Seguir o padrão `call(Params params)` mesmo sem parâmetros reais
/// garante que o contrato seja extensível sem quebrar chamadas existentes:
/// se filtros forem necessários no futuro (data, categoria, usuário),
/// basta criar `GetTransactionsParams extends NoParams` e adicionar os campos.
class NoParams {
  const NoParams();
}
