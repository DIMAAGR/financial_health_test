# Financial Health Design System

Package local criado para o **Desafio 3 - Widget reutilizável e Design System Thinking**.

## Por que virou package

Inicialmente, os componentes compartilhados ficaram dentro do app em `shared/presentation/design`, porque os primeiros desafios priorizavam feature, arquitetura e estado. O Desafio 3 mudou o contexto: o `FinancialSummaryCard` precisava ser avaliado como componente de design system, com contrato público, tema próprio, dark mode e ausência de dependências implícitas de produto.

Por isso, a decisão evoluiu para um package local. Em um projeto real, essa extração exigiria análise de custo, governança dos tokens, versionamento e adoção pelos apps consumidores. Para este teste, o package deixa explícita a fronteira entre design system e features sem transformar regras de negócio em UI compartilhada.

## Organização

Usei uma estrutura pragmática de **Foundations + Components**, em vez de Atomic Design.

```text
lib/
  financial_health_design_system.dart
  src/
    foundations/
      theme/
      tokens/
    components/
      category_breakdown/
      contextual_fab/
      detail_app_bar/
      financial_summary_card/
      month_summary_card/
      shimmer_skeleton/
      svg_icon/
      transaction_list/
    extensions/
    helpers/
    input_formatters/
    theme/
      extensions/
    assets/
      icons/
```

## Conteúdo atual

- `FhSpacing`, `FhRadius`, `FhTextStyles`: foundations do componente do Desafio 3.
- `AppSpacing`, `AppRadius`, `AppTextStyles`: tokens já usados pelo app antes da extração.
- `FinancialHealthDesignTheme`: extensões de tema light/dark do package.
- `FinancialSummaryCard`: componente reutilizável, sem dependência de feature.
- Componentes compartilhados do app: `DetailAppBar`, `ContextualFab`, `MonthSummaryCard`, `CategoryBreakdownSection`, `TransactionListSection`, `ShimmerSkeleton` e `AppSvgIcon`.
- Suporte visual: ícones SVG, themes extensions, formatadores e extensions de apresentação.

O `theme.dart` da aplicação continua no app consumidor, porque ele compõe o `ThemeData` específico do produto. O package fornece os blocos visuais e as `ThemeExtension`s.

## Uso

No app consumidor:

```yaml
dependencies:
  financial_health_design_system:
    path: ../packages/financial_health_design_system
```

```dart
ThemeData(
  extensions: FinancialHealthDesignTheme.lightExtensions,
)
```

```dart
FinancialSummaryCard(
  title: 'INCOME',
  value: 'R$ 12.400,00',
  variationPercent: 15,
  icon: const Icon(Icons.trending_up),
  onTap: () {},
)
```
