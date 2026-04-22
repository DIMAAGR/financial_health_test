# Design System — ThemeExtensions, Package e Temas

## O problema das cores repetidas

No início do projeto, as cores eram definidas diretamente nos widgets — um padrão comum em código gerado por ferramentas como `figma.to.code`:

```dart
// ❌ estado inicial — cor hardcoded, sem tema, sem suporte a dark mode
Container(
  color: const Color(0xFF1D5C4A),
  child: Text(
    'Saúde boa',
    style: TextStyle(color: const Color(0xFFB1EFD8)),
  ),
)
```

O problema não era visual — era de manutenção. O mesmo valor `0xFF1D5C4A` aparecia em múltiplos widgets sem nome semântico. Para trocar o tema, mudar o dark mode ou ajustar uma cor de status, era necessário buscar e substituir um valor hexadecimal sem saber o que ele significava em cada contexto.

---

## ThemeExtension como solução

A solução foi mover todas as cores para `ThemeExtension`s semânticas, acessadas via `BuildContext`:

```dart
// ✅ cor semântica via ThemeExtension — sem valor hardcoded no widget
Container(
  color: context.appColors.metricCardBackground,
  child: Text(
    'Saúde boa',
    style: TextStyle(color: context.appColors.metricCardValue),
  ),
)
```

Cada componente tem sua própria `ThemeExtension` com os tokens específicos que ele precisa:

```dart
// financial_health_score_theme_ext.dart
@immutable
class FinancialHealthCardColors {
  final Color backgroundStart;   // gradiente início
  final Color backgroundEnd;     // gradiente fim
  final Color backgroundSolid;   // fallback sem gradiente
  final Color badgeBackground;   // fundo do badge "CRÍTICO"
  final Color badgeText;
  final Color titleText;         // "Score de Saúde Financeira"
  final Color scoreText;         // "34"
  final Color headlineText;      // "Você está gastando 81% da sua renda"
  final Color descriptionText;   // subtítulo
  final Color divider;
  // ...
}
```

O acesso no widget é feito via extensão no `BuildContext`:

```dart
// app_theme_ext.dart
extension AppThemeExtension on BuildContext {
  AppSemanticColors get appColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
  FinancialHealthScoreTheme get financialHealthScoreTheme =>
      Theme.of(this).extension<FinancialHealthScoreTheme>()!;
  FlowAnalysisTheme get flowAnalysisTheme =>
      Theme.of(this).extension<FlowAnalysisTheme>()!;
  MonthlyGoalTheme get monthlyGoalTheme =>
      Theme.of(this).extension<MonthlyGoalTheme>()!;
  // ...
}
```

Isso significa que o widget não sabe se está em light ou dark mode — ele só pede `context.financialHealthScoreTheme.colors.badgeBackground` e o `ThemeData` resolve.

---

## Light mode e dark mode

Cada `ThemeExtension` tem duas instâncias completas — uma para `ThemeData.light()` e outra para `ThemeData.dark()`. Não há lógica de `if (isDark)` nos widgets.

Exemplo real do score card nos dois temas:

```dart
// light: gradiente vermelho com badge sólido
static const FinancialHealthCardColors criticalLight = FinancialHealthCardColors(
  backgroundStart: Color(0xFF7F1D1D),
  backgroundEnd:   Color(0xFF3B0000),
  badgeBackground: Color(0xFFEF4444),
  badgeText:       Color(0xFFFFFFFF),
  titleText:       Color(0xFFFFFFFF),
  scoreText:       Color(0xFFFFFFFF),
  headlineText:    Color(0xFFFFFFFF),
  // ...
);

// dark: mesma semântica, paleta ajustada para contraste em fundo escuro
static const FinancialHealthCardColors criticalDark = FinancialHealthCardColors(
  backgroundStart: Color(0xFF450A0A),
  backgroundEnd:   Color(0xFF1C0202),
  badgeBackground: Color(0xFFB91C1C),
  badgeText:       Color(0xFFFFFFFF),
  titleText:       Color(0xFFFFE2E2),
  scoreText:       Color(0xFFFFFFFF),
  headlineText:    Color(0xFFFFE2E2),
  // ...
);
```

O resultado é que os dois temas existem como dados — não como lógica condicional espalhada por widgets.

---

## Da pasta `shared/design` ao package

### Fase 1 — componentes em `shared/presentation`

No início do projeto, os componentes compartilhados (cards, skeletons, formatadores) ficaram dentro do app em `shared/presentation/`. A justificativa era pragmática: os primeiros desafios priorizavam feature, arquitetura e estado — extrair um package antes de ter widgets estáveis seria overengineering.

```
lib/src/shared/presentation/
  widgets/
    metric_card.dart
    skeleton_loader.dart
  formatters/
    brl_input_formatter.dart
```

### Fase 2 — extração para package local

O Desafio 3 introduziu o `FinancialSummaryCard` como componente avaliado de design system. Isso mudou o contexto: o componente precisava ser avaliado com contrato público, tema próprio, dark mode e ausência de dependências implícitas de produto.

A decisão foi criar o package `financial_health_design_system` em `packages/`:

```
packages/
  financial_health_design_system/
    lib/
      financial_health_design_system.dart  # public API
      src/
        foundations/         # tokens (spacing, radius, text styles)
        components/          # widgets reutilizáveis
        theme/
          extensions/        # ThemeExtensions por componente
```

Consumido pelo app via path dependency:

```yaml
# financial_health_dashboard/pubspec.yaml
dependencies:
  financial_health_design_system:
    path: ../packages/financial_health_design_system
```

---

## Impacto da extração — positivo e negativo

### Por que valeu a pena

| Benefício | Descrição |
|---|---|
| Contrato público explícito | Cada componente tem uma API definida. O app não pode importar internals do package |
| Testabilidade isolada | Os testes do design system rodam sem inicializar o app (`flutter test` dentro do package) |
| Reutilização real | O `FinancialSummaryCard` pode ser publicado no pub.dev ou consumido por outro app do monorepo sem dependência de feature |
| Forçou separação de negócio e UI | O package não pode importar nada de `lib/src/features/` — isso eliminou um vetor de acoplamento |

### O que custou

| Custo | Descrição |
|---|---|
| Fazer isso no meio do projeto | Componentes existentes precisaram ser migrados e os imports do app atualizados. Quebrou compilação temporariamente |
| Coordenação de versão | Qualquer mudança no package que quebra a API exige atualização no app consumidor no mesmo commit |
| Overhead de path dependency | Em um monorepo real, isso exigiria versionamento semântico e processo de release; aqui é gerenciado por path |
| Onboarding mais complexo | Um novo dev precisa entender que existe um package separado, não apenas `lib/` |

### Impacto em um projeto real vs aqui

Em um projeto real com múltiplos apps consumindo o mesmo design system, a extração para package seria a decisão certa desde o início — mas exigiria:

- Governança dos tokens (quem aprova mudanças de cor/espaçamento?)
- Processo de publicação e changelog
- Estratégia de deprecação de componentes antigos
- Integração com CI para garantir que mudanças no package não quebram os apps consumidores

Aqui, como é um monorepo com um único app consumidor e o package foi extraído no meio do projeto, o risco foi gerenciável. Em um projeto com 3+ apps consumindo o mesmo package, a mesma mudança exigiria planejamento de rollout.

---

## Como a IA ajudou a reduzir o impacto da migração

A migração de `shared/presentation` para o package no meio do desenvolvimento foi a operação de maior risco desta fase — qualquer import incorreto ou ThemeExtension não migrada quebraria a compilação do app.

A IA foi usada para:

1. **Mapear todos os imports afetados** antes de começar a mover arquivos — evitou migração parcial que compilaria mas teria comportamento incorreto em runtime
2. **Gerar os adaptadores de tema** (`FinancialHealthDesignTheme.light` / `.dark`) com todas as variantes de status de um componente de uma vez, respeitando os nomes semânticos já definidos nos `ThemeExtension`s existentes
3. **Atualizar os testes** do app para consumir as versões públicas do package em vez dos caminhos internos de `shared/`

O que a IA não fez: decidir quais componentes deveriam entrar no package. Essa decisão foi feita manualmente — o critério foi: **entra no package só o que pode ser usado por outro app sem carregar regra de negócio do financial health dashboard**. Componentes como `DashboardSkeleton` ficaram no app porque são acoplados ao estado específico da tela, não à linguagem visual.

---

## Referências

- [Processo de design (Stitch → Figma → figma.to.code) →](./design_process.md)
- [ThemeExtension — documentação oficial Flutter](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- [Material Design tokens](https://m3.material.io/foundations/design-tokens/overview)
- [Package do design system →](../../packages/financial_health_design_system/README.md)
