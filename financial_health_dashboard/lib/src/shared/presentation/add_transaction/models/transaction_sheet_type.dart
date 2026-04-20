enum SheetType {
  income('Adicionar Receita', 'Salvar Receita', 'Ex: Salário Mensal'),
  expense('Adicionar Despesa', 'Salvar Despesa', 'Ex: Mercado');

  const SheetType(this.title, this.buttonTitle, this.descriptionHintText);

  final String title;
  final String buttonTitle;
  final String descriptionHintText;
}
