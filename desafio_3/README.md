# Desafio 3 - FinancialSummaryCard

## Entrega

O componente foi implementado em um package local de design system:

- Package: `packages/financial_health_design_system/`
- API pública: `packages/financial_health_design_system/lib/financial_health_design_system.dart`
- Componente: `packages/financial_health_design_system/lib/src/components/financial_summary_card/financial_summary_card.dart`
- Tema: `packages/financial_health_design_system/lib/src/components/financial_summary_card/financial_summary_card_theme.dart`
- Tokens: `packages/financial_health_design_system/lib/src/components/financial_summary_card/financial_summary_card_tokens.dart`
- README do componente: `packages/financial_health_design_system/lib/src/components/financial_summary_card/README.md`
- Testes: `packages/financial_health_design_system/test/components/financial_summary_card/financial_summary_card_test.dart`

O app principal consome o package via path dependency em `financial_health_dashboard/pubspec.yaml`.

## Decisões

- O componente recebe `title`, `value`, `variationPercent`, `icon`, `themePalette` e `onTap`.
- `value` é `String` por decisão intencional: o card não formata dinheiro nem conhece regra de negócio.
- A cor positiva ou negativa é resolvida automaticamente a partir de `variationPercent`.
- As cores vivem em `ThemeExtension`, com variantes para light mode e dark mode.
- `themePalette` permite uma familia de cores customizada sem acoplar o widget a uma feature.
- O widget não depende de dashboard, income, expense ou qualquer entidade de domínio.
- A organização do package usa Foundations + Components, em vez de Atomic Design, porque o escopo do desafio pede um componente financeiro reutilizável e não uma biblioteca visual completa.
- Inicialmente, a decisão era manter o design system dentro do app. O Desafio 3 mudou esse contexto e justificou a extração para package local.
- Depois da criação do `FinancialSummaryCard`, os componentes compartilhados que estavam em `shared/presentation/design` também foram migrados para o package. O app ficou apenas com o `theme.dart`, que monta o `ThemeData` específico do produto usando as `ThemeExtension`s exportadas pelo design system.

## IA no processo

Usei o layout gerado pelo Google Stitch como referência visual inicial. O output trazia valores fixos de Figma, como largura `342`, cores literais, espaçamentos absolutos e textos hardcoded (`INCOME`, `EXPENSES`, `R$ 12.400,00`).

Prompt usado para a refatoração assistida:

```text
Transforme este layout Flutter gerado por IA em um componente de design system reutilizável chamado FinancialSummaryCard. Ele deve receber título, valor, variação percentual, ícone, palette de tema opcional e callback. Remova cores hardcoded do widget, use ThemeExtension com light/dark mode, não inclua regra de negócio ou formatação monetária, e escreva testes de widget para estado positivo, estado negativo e callback de toque.
```

O que foi ajustado manualmente:

- Removi largura fixa e textos fixos do layout gerado.
- Troquei cores literais por `FinancialSummaryCardTheme`.
- Mantive a formatação do valor fora do componente.
- Usei `FittedBox` no valor principal para evitar overflow em valores longos.
- Adicionei documentação Dart pública com exemplo de uso.
- Validei os estados positivo, negativo e interação por widget test.
