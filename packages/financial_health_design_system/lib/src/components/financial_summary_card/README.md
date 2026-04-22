# FinancialSummaryCard

Componente entregue para o **Desafio 3 - Widget reutilizável e Design System Thinking**.

Ele vive no package local `financial_health_design_system` para manter uma fronteira clara entre componentes reutilizáveis e código de feature. A pasta é autocontida para facilitar revisão, evolução e eventual publicação/versionamento como package real.

## Estrutura

```text
financial_summary_card/
  financial_summary_card.dart
  financial_summary_card_theme.dart
  financial_summary_card_tokens.dart
  README.md
```

## Contrato

- `title`: rótulo curto exibido no card.
- `value`: valor já formatado pelo caller.
- `variationPercent`: define badge e estado visual positivo/negativo.
- `icon`: ícone do caller, colorido pelo tema do componente.
- `themePalette`: override opcional para outra família semântica.
- `onTap`: ação opcional do card.

## Uso

```dart
FinancialSummaryCard(
  title: 'INCOME',
  value: 'R$ 12.400,00',
  variationPercent: 15,
  icon: const Icon(Icons.trending_up),
  onTap: () {},
)
```

## Decisões

- O componente não formata dinheiro porque isso seria regra de apresentação do produto, não responsabilidade do widget base.
- A escolha entre estado positivo e negativo acontece apenas pela variação percentual.
- Todas as cores vêm de `FinancialSummaryCardTheme`, com suporte a light e dark mode.
- Dimensões próprias do componente ficam em `FinancialSummaryCardTokens`.
