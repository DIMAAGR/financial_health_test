/// Categorias possíveis de uma transação — enum puro de domínio.
///
/// Não possui dependências de Flutter, UI ou infraestrutura.
/// Ícones, cores e labels pertencem à camada de apresentação
/// (veja `TransactionTypePresenter` e `TransactionColors`).
/// O parsing de strings brutas da API pertence à camada de dados
/// (veja `TransactionDto._parseType`).
enum TransactionType {
  income,
  expense,

  /// Tipo retornado pela API que não foi reconhecido.
  /// Explícito por design — nunca cai silenciosamente em um tipo errado.
  unknown,
}
