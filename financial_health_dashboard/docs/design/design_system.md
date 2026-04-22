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

## O arquivo de cores é colossal — por que não usar `AppLightColors.ruby`?

O arquivo de cores do projeto tem dezenas de constantes. A pergunta natural é: por que não criar uma paleta central (`AppLightColors`) com nomes semânticos como `ruby`, `emerald`, `slate50`, e referenciar esses nomes nas extensões?

```dart
// Abordagem de paleta central — não foi usada aqui
abstract class AppLightColors {
  static const ruby   = Color(0xFFEF4444);
  static const emerald = Color(0xFF1D5C4A);
  static const slate50 = Color(0xFFF8FAFC);
}

// ThemeExtension referenciando a paleta
static const FinancialHealthCardColors criticalLight = FinancialHealthCardColors(
  badgeBackground: AppLightColors.ruby,    // ← um lugar para mudar
  backgroundStart: AppLightColors.slate50,
  ...
);
```

Com essa abordagem, mudar o tom de vermelho crítico seria uma linha em `AppLightColors.ruby` — e todos os componentes que a referenciam atualizariam automaticamente.

### Por que não foi usada aqui

A decisão foi priorizar **tokens semânticos por componente** em vez de paleta global. O raciocínio:

- O design do projeto saiu diretamente de ferramentas de geração (Google Stitch + Figma), que entregam valores hexadecimais literais, não nomes semânticos. Criar `ruby`, `emerald` etc. exigiria um passo extra de curadoria que não estava no escopo desta entrega.
- Em um componente financeiro com status (crítico, atenção, saudável), as cores mudam de família inteira entre status — não apenas de shade. `badgeBackground` no estado crítico tem nada a ver com `badgeBackground` no estado saudável, mesmo que em uma paleta teórica ambos existissem.
- A ferramenta `figma.to.code` gerou os valores já nomeados como `backgroundColor`, `textColor` etc. — o custo de mapear para uma paleta nomeada era maior que o benefício para o escopo do projeto.

### O que seria melhor em produção

Em um design system de produto real, a prática correta é **dois níveis de tokens**:

```
Nível 1 — paleta (valores brutos com nome)
  AppColors.ruby        = Color(0xFFEF4444)
  AppColors.rubyDark    = Color(0xFFB91C1C)
  AppColors.emerald     = Color(0xFF1D5C4A)

Nível 2 — tokens semânticos (significado no produto)
  AppSemanticColors.danger           = AppColors.ruby
  AppSemanticColors.dangerElevated   = AppColors.rubyDark
  AppSemanticColors.positive         = AppColors.emerald
```

Os `ThemeExtension`s dos componentes referenciam nível 2 — e nível 2 referencia nível 1. Mudar o tom de "danger" no produto inteiro é trocar `AppColors.ruby` por `Color(0xFFDC2626)` em um único lugar.

O trade-off desta ausência neste projeto: se a especificação mudar o vermelho do badge crítico, é necessário atualizar em todos os lugares onde `Color(0xFFEF4444)` aparece no arquivo de temas. Isso é gerenciável com busca global, mas não é o padrão ideal.

---

## Migração para package em produção — riscos e gitflow

### O problema de timing em times reais

A extração de `shared/presentation` para um package local parece uma mudança interna, mas em um time com múltiplos devs ela tem o mesmo risco de uma mudança de API pública: **um dev pode estar à frente, outro atrasado**.

**Cenário típico:**
```
main:       A ── B ── C ──────── [MERGE feature-auth] ──→ 💥 compile error
                      │
feature-auth: ───────────── D ── E ── F (imports de shared/presentation)
                              ↑
                           extração do DS aconteceu em main
                           feature-auth ainda usa caminho antigo
```

O dev que extraiu o package atualizou todos os imports em `main`. O outro dev, que tinha uma branch de feature aberta com os imports antigos, mergea depois e a compilação quebra — todos os `import 'package:financial_health_dashboard/src/shared/presentation/...'` viraram `import 'package:financial_health_design_system/...'`.

### Estratégias de mitigação

**1. PR atômico — não fragmentar a migração**

A extração do package deve ser feita em um único PR, com todos os imports atualizados, todos os testes passando e o PR aprovado e mergeado antes de qualquer outra branch avançar. Nunca migrar em partes ao longo de vários dias.

**2. Comunicação antecipada no time**

Antes de começar a migração, avisar o time: _"nos próximos X dias vou extrair o DS para package — quem tiver branch aberta que usa `shared/presentation/design` precisa dar rebase depois do merge."_

**3. Facade temporária — zero breaking changes no dia do merge**

Durante a transição, manter os imports antigos funcionando via re-exports:

```dart
// shared/presentation/widgets/metric_card.dart (temporário)
// DEPRECATED — use financial_health_design_system
export 'package:financial_health_design_system/src/components/metric_card/metric_card.dart';
```

Isso permite que branches com imports antigos ainda compilem. A remoção do facade é feita em um PR separado depois que todos os devs migraram.

**4. Gitflow para a extração**

```
main (ou develop)
  │
  └── chore/extract-design-system-package
        ├── Criar package com estrutura vazia
        ├── Mover componentes um a um (com testes passando em cada commit)
        ├── Atualizar imports do app
        ├── Remover facades se foram criados
        └── PR → squash merge em main
```

A branch de extração deve ser curta (idealmente 1-2 dias) e não ter outras features misturadas.

**5. Semver e CHANGELOG para quando o package for publicado**

Enquanto o package é `path: ../packages/...`, o versionamento é implícito (qualquer commit pode ser uma breaking change silenciosa). Se o package for publicado no pub.dev ou compartilhado entre repositórios, semver é obrigatório:

- `BREAKING CHANGE:` no commit message → bump de versão major (`1.x.x` → `2.0.0`)
- Nova feature → minor (`1.2.x` → `1.3.0`)
- Bugfix → patch (`1.2.3` → `1.2.4`)

CI deve bloquear merge se o package tem breaking changes e a versão não foi atualizada.

---

## Referências

- [Processo de design (Stitch → Figma → figma.to.code) →](./design_process.md)
- [ThemeExtension — documentação oficial Flutter](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- [Material Design tokens](https://m3.material.io/foundations/design-tokens/overview)
- [Package do design system →](../../packages/financial_health_design_system/README.md)