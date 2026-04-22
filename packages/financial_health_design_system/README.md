# Financial Health Design System

Package local de design system do projeto Financial Health Dashboard. Contém os componentes visuais, tokens de espaçamento/tipografia/radius e `ThemeExtension`s com suporte a light/dark mode.

---

## Por que existe como package separado

Os componentes começaram em `financial_health_dashboard/lib/src/shared/presentation/` — colocados lá por pragmatismo: os primeiros desafios priorizavam feature e arquitetura, extrair um package antes de ter widgets estáveis seria overengineering.

O Desafio 3 mudou o contexto. O `FinancialSummaryCard` precisava ser avaliado como componente de design system com **contrato público explícito** — sem poder importar nada de `lib/src/features/`. Isso forçou a extração formal.

O critério de o que entrou no package: **qualquer widget que pode ser usado por outro app sem carregar regra de negócio do financial health dashboard.** Componentes como `DashboardSkeleton` ficaram no app porque dependem do estado específico da tela principal.

Ver análise completa da extração, riscos em produção e gitflow recomendado em [docs/design/design_system.md](../../financial_health_dashboard/docs/design/design_system.md).

---

## O que está no package

### Foundations

| Token | O que define |
|---|---|
| `FhSpacing` / `AppSpacing` | Escala de espaçamentos (4, 8, 12, 16, 24, 32...) |
| `FhRadius` / `AppRadius` | Border radius (xs, sm, md, lg) |
| `FhTextStyles` / `AppTextStyles` | Estilos tipográficos (title, body, label, caption) |

`Fh*` são tokens criados para o `FinancialSummaryCard` (Desafio 3). `App*` são os tokens que o app usava antes da extração — mantidos no package para que o app não precise de dois sistemas.

### Componentes

| Componente | Descrição |
|---|---|
| `FinancialSummaryCard` | Card com título, valor, variação e ícone — entregável do Desafio 3 |
| `MonthSummaryCard` | Card de overview mensal (receita, despesa, saldo) |
| `CategoryBreakdownSection` | Lista de categorias com barras de progresso |
| `TransactionListSection` | Lista de transações agrupadas por data |
| `DetailAppBar` | AppBar com título e botão de adicionar contextual |
| `ContextualFab` | FAB com comportamento por tipo de tela (income/expense/transaction) |
| `ShimmerSkeleton` | Skeleton loader genérico com animação shimmer |
| `AppSvgIcon` | Wrapper de SVG com suporte a cor e tamanho semântico |

### Tema

`FinancialHealthDesignTheme` expõe `.lightExtensions` e `.darkExtensions` — listas de `ThemeExtension`s prontas para inserir no `ThemeData` do app:

```dart
ThemeData(
  brightness: Brightness.light,
  extensions: FinancialHealthDesignTheme.lightExtensions,
)
```

Cada componente tem sua própria `ThemeExtension` com tokens específicos (ex: `FinancialSummaryCardTheme`, `MonthSummaryCardTheme`). O app `theme.dart` compõe o `ThemeData` final — ele fica no app, não aqui, porque inclui decisões de produto (cor primária, `ColorScheme`, tipografia base).

---

## Estrutura

```text
lib/
  financial_health_design_system.dart   # public API — só o que está aqui é importável
  src/
    foundations/
      theme/
      tokens/                           # FhSpacing, FhRadius, FhTextStyles, App*
    components/
      financial_summary_card/           # widget + tokens + theme — co-locados (ver abaixo)
        financial_summary_card.dart
        financial_summary_card_tokens.dart
        financial_summary_card_theme.dart
        README.md
      month_summary_card/
      category_breakdown/
      transaction_list/
      detail_app_bar/
      contextual_fab/
      shimmer_skeleton/
      svg_icon/
    extensions/                         # extensions de BuildContext para ThemeExtensions
    helpers/
    input_formatters/                   # BRL input formatter
    theme/
      extensions/                       # ThemeExtension dos demais componentes
    assets/
      icons/                            # SVGs
```

### Por que `financial_summary_card/` tem 3 arquivos — e os outros componentes não

O `FinancialSummaryCard` tem dois arquivos extras além do widget:

- **`financial_summary_card_tokens.dart`** — constantes de layout específicas do componente: `iconContainerSize`, `headerContentGap`, `contentPadding`, etc. Esses valores **não são tokens globais do design system** (que ficam em `foundations/tokens/` como escalas de espaçamento e radius). São decisões internas do componente — se o card mudar de design, só este arquivo muda.

- **`financial_summary_card_theme.dart`** — a `ThemeExtension` com a paleta light/dark do card. Nos outros componentes do package, as `ThemeExtension`s ficam em `theme/extensions/`. Aqui está co-localizada porque o `FinancialSummaryCard` foi construído como o componente exemplar do Desafio 3: a intenção é que tudo necessário para entender, copiar ou mover o componente esteja em uma pasta.

**A inconsistência com os outros componentes é real.** Em um design system de produção, você escolheria um padrão e aplicaria a todos — provavelmente: `ThemeExtension` em `theme/extensions/` (para manter a edição de tema em um lugar só) e tokens de componente co-locados (porque são internos, não globais). O que está aqui é uma decisão de documentação para o avaliador, não o padrão que seguiria em produção em larga escala.

---

## `FinancialSummaryCard` — componente do Desafio 3

```dart
FinancialSummaryCard(
  title: 'INCOME',
  value: 'R$ 12.400,00',      // formatado pelo caller — o card não conhece regra de moeda
  variationPercent: 15,        // positivo → badge verde; negativo → badge vermelho
  icon: const Icon(Icons.trending_up),
  onTap: () {},
)
```

**Decisões principais:**

- `value` é `String` — o card não formata dinheiro nem conhece `Locale`. Quem chama decide o formato.
- A cor positiva/negativa é resolvida internamente a partir do sinal de `variationPercent` — o caller não precisa saber as cores.
- `themePalette` permite uma família de cores customizada sem acoplar o widget a uma feature específica.
- `ThemeExtension` com instâncias separadas para light e dark — sem `if (isDark)` no widget.

Ver contrato completo: [lib/src/components/financial_summary_card/README.md](./lib/src/components/financial_summary_card/README.md)

---

## Uso

```yaml
# pubspec.yaml do app consumidor
dependencies:
  financial_health_design_system:
    path: ../packages/financial_health_design_system
```

```dart
// Importar apenas via API pública
import 'package:financial_health_design_system/financial_health_design_system.dart';
```

Importar caminhos internos (`src/`) não é suportado — o package encapsula seus internals intencionalmente.

---

## Testes

```bash
cd packages/financial_health_design_system
flutter test
```

Os testes cobrem o `FinancialSummaryCard`: estado positivo, negativo, sem variação, com e sem callback, e verificação de que o widget não tem dependência de produto.

