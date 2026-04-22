# Financial Health Dashboard

<table>
<tr>
<td valign="top" width="62%">

O **Financial Health Dashboard** é um app mobile que transforma números financeiros brutos em uma leitura clara e imediata do seu estado financeiro. Você abre o app e vê na hora se está saudável, em atenção ou em situação crítica — sem precisar fazer nenhuma conta.

A tela principal exibe um **score de saúde financeira** calculado com base no quanto da sua renda você está comprometendo e como sua liquidez evoluiu no mês. A partir daí, você navega para telas de detalhe que mostram o breakdown de receitas ou despesas por categoria, a lista de movimentações agrupadas por data e uma ação contextual para registrar uma nova receita ou despesa diretamente na tela em que você está.

**Stack principal:** Flutter · Dart · `flutter_bloc` (Cubit) · `freezed` · `get_it` · `go_router` · `dartz`

**Sem backend:** os dados são gerados por um `FakeHttpService` que simula latência de rede, mutações e persistência em memória durante a sessão. Não há nada para configurar além de ter um emulador ou device ativo.

</td>
<td valign="top" align="center" width="38%">
<img src="../docs/assets/screenshots/dashboard_full.png" alt="Dashboard completo" width="260" />
</td>
</tr>
</table>

---

## Arquitetura

Feature-first com separação interna `data / domain / presentation`, DDD pragmático no domínio, Cubit para estado, `get_it` para DI e `go_router` para navegação.

→ **[Arquitetura completa, alternativas e trade-offs](./docs/architecture/architecture.md)**
→ **[Gerenciamento de estado — por que Cubit](./docs/architecture/state_management.md)**
→ **[Eventos efêmeros e desacoplamento de bottom sheets](./docs/architecture/ephemeral_events.md)**
→ **[Storage — FakeHttpService, KeyValueWrapper e alternativas reais](./docs/architecture/storage.md)**
→ **[Design system — ThemeExtensions, light/dark e extração de package](./docs/design/design_system.md)**
→ **[IA no processo — onde ajudou e onde errou](./docs/architecture/ia_in_process.md)**

---

## Stack

| Dependência | Papel | Trade-off principal |
|---|---|---|
| `flutter_bloc` (Cubit) | Estado explícito e mutuamente exclusivo | Mais arquivos que `setState`; compensa em testabilidade e legibilidade |
| `freezed` | Imutabilidade e `copyWith` nos states | Geração de código (`build_runner`); elimina erros de cópia parcial de estado |
| `get_it` | DI com `registerFactoryParam` para cubits parametrizados | Global mutable; trocado por DI com escopo se o app crescer |
| `go_router` | Roteamento declarativo com guards | Mais verboso que `Navigator.push` direto; necessário para deep link e guards |
| `dartz` | `Either<AppFailure, T>` para erros tipados no domínio | Curva de aprendizado; elimina exceções não tratadas no fluxo de negócio |
| `connectivity_plus` | Verificação de rede antes de requests | Depende de permissão de rede no Android/iOS; falso positivo em VPN |
| `intl` | Formatação de moeda e datas | Adiciona ~300KB ao bundle; sem alternativa prática para BRL |
| `financial_health_design_system` | Componentes visuais e tokens desacoplados de feature | Overhead de path dependency; impede consumo implícito de estado de feature no widget |

---

## Problemas encontrados e resolvidos

Problemas reais identificados durante o desenvolvimento, com causa raiz e como foram resolvidos.

### 1. Ambiguidade de estado na UI

**Erro:** modelagem inicial com múltiplas flags booleanas (`isLoading`, `error`, `data`) permitia estados impossíveis.

**Causa:** simplificação excessiva sem garantir exclusividade — padrão que a IA sugere com frequência para reduzir código.

**Correção:** migração para estados explícitos e mutuamente exclusivos via Cubit com classes seladas.

**Prevenção:** evitar flags paralelas para o fluxo principal de tela.

---

### 2. Textos de UI vazando para o domínio

**Erro:** a IA sugeriu manter `title` e `description` de exibição dentro das entidades de domínio.

**Causa:** simplificação que mistura responsabilidades — a entidade fica fácil de usar na UI, mas carrega um acoplamento implícito com apresentação, i18n e copy.

**Correção:** textos foram removidos das entidades e movidos para mappers de apresentação (`MonthlyGoalTextMapper`, `FinancialHealthScoreTextMapper`).

**Prevenção:** regra criada no processo — strings de UI nunca entram em entidades de domínio.

---

### 3. Label de apresentação serializado no domínio

**Erro:** categorias de transação foram unificadas em `TransactionCategory` com `label` em português. A serialização persistia o `label` visual, não um `code` estável.

**Causa:** refatoração que reduziu duplicação entre receita e despesa levou um artefato visual para o núcleo de negócio.

**Correção:** `IncomeCategory` e `ExpenseCategory` separados no domínio. `TransactionCategory` movido para presentation. Storage passou a usar `category.code`.

**Prevenção:** mapper explícito entre UI e domínio sempre que a UI agrupa conceitos que o domínio precisa manter separados.

---

### 4. Parâmetro público sem efeito real

**Erro:** `MetricCardSize` existia no widget mas não alterava layout — o parâmetro era aceito e ignorado.

**Causa:** boilerplate gerado pela IA sem validação de comportamento observável.

**Correção:** tamanho passou a afetar padding, tipografia e ícone de forma mensurável.

**Prevenção:** todo parâmetro público deve ter efeito visível ou ser removido.

---

### 5. Bottom sheet fechava antes de confirmar sucesso

**Erro:** o sheet fazia `pop` imediatamente após `submit()` e só depois disparava o cubit da dashboard. Se o submit falhasse, o usuário não via o erro.

**Causa:** fluxo tratava o sheet como formulário puro (coletar → devolver), sem considerar que operações com latência precisam de feedback antes do fechamento.

**Correção:** `onSubmit` recebe um callback `Future<bool>`. O sheet só fecha se o resultado for `true`. Em `false`, reseta `isSubmitting` para que o usuário possa tentar novamente.

**Prevenção:** modais que disparam side-effect com latência devem aguardar confirmação antes de fechar.

---

### 6. Features de detalhe consumindo endpoint da dashboard

**Erro:** as telas de receitas, despesas e transações consumiam `/dashboard/overview` — a mesma rota da tela principal.

**Causa:** acoplamento por conveniência durante o desenvolvimento inicial.

**Correção:** `FakeHttpService` passou a expor bordas por contexto: `/incomes/overview`, `/expenses/overview`, `/transactions/overview`, `/transactions`. Cada feature usa seu próprio contrato.

**Prevenção:** features de detalhe não devem depender do agregado de outra feature.

---

### 7. Loops abertos — código declarado sem consumo

**Erro:** `CommitmentStatus` enum declarado mas nunca renderizado. Rotas criadas vazias. `Future.delayed` artificial dentro do Cubit simulando IO.

**Causa:** geração incremental com IA priorizou "preparar para depois" sem validar se o "depois" existia no escopo do MVP.

**Correção:** tudo que não era consumido em nenhum widget, teste ou rota foi removido. O delay foi movido para a camada de dados, onde faz sentido arquitetural.

**Prevenção:** antes de commitar, verificar se todo artefato declarado é consumido em pelo menos um lugar real.

---

### 8. Cores hardcoded fora do tema

**Erro:** resolver de estilo do card principal usava cores literais em vez de tokens de tema.

**Causa:** código vindo de geração visual sem alinhamento com o design system.

**Correção:** paleta movida para `ThemeExtension`, consumida via `Theme.of(context)`.

**Prevenção:** toda cor nova nasce no tema/tokens.

---

## Dívida técnica conhecida

Itens identificados que não foram resolvidos nesta entrega por decisão de escopo — não por descuido.

| Item | Status | Descrição |
|------|--------|-----------|
| Valores monetários como `double` | Pendente | Risco de erro de arredondamento. Solução: `Money` com centavos em `int`. |
| `DateTime.now()` espalhado | Pendente | Deveria usar `Clock` injetado em todos os pontos temporais. |
| `AppFailure.message` com texto de UI | Pendente | Mensagens exibíveis ainda vivem no failure — deveriam ser mapeadas na presentation. |
| Inputs de comando com aparência de entidade | Pendente | `AddDashboardInput` parece entidade de domínio. Separar command/input de regra central. |
| Widget tests da tela principal | Parcial | Cobre estados, mas falta cobertura de interação completa (loading → success → tap). |
| `FakeHttpService` com muitas responsabilidades | Parcial | Store, seed, mutação e serialização estão na mesma classe. Separar em outra branch. |

---

## MCP Server no processo de desenvolvimento

O repositório inclui um servidor MCP (`tools/mcp_server/`) que foi conectado ao VS Code Copilot durante o desenvolvimento deste app. O servidor expõe as regras do projeto, os learnings acumulados e um gerador de estrutura de feature diretamente para o assistente de IA.

### O que funcionou bem

**Contexto persistente entre sessões** — sem o MCP, cada conversa com a IA começava do zero. Com o MCP, `get_project_context` e `get_rules` carregavam as decisões já tomadas antes de qualquer prompt. Isso evitou sugestões conflitantes com a arquitetura já definida.

**`generate_feature_structure`** — criar a estrutura de diretórios de uma feature nova (data/domain/presentation, DTOs, repositório, use case, cubit, tests) levava minutos de scaffolding manual. Com a ferramenta, o esqueleto era gerado com os nomes corretos e na organização esperada.

**`add_learning`** — quando um erro foi identificado (ver `ia_in_process.md`), registrá-lo imediatamente no MCP garantia que a IA não repetia o mesmo equívoco na próxima sessão.

### Onde o MCP não impediu problemas

O MCP foi implementado durante o desenvolvimento — não desde o dia zero. Em um momento anterior, a IA gerou features com nomes incorretos (ex: nome de diretório que não seguia a convenção `snake_case` do projeto, import path errado). Quando o MCP estava ativo, esse padrão foi capturado e registrado como regra. Para as features já geradas com o nome errado, foi necessário renomear manualmente.

**A lição:** o MCP é eficaz para manter consistência nas interações futuras, mas não corrige o passado. Configurar as regras antes de gerar qualquer código teria evitado o retrabalho de renomeação.

### Limitações

- O servidor não tem estado de contexto de sessão: ele serve o que está nos arquivos em disco, não o histórico da conversa ativa.
- `generate_feature_structure` gera boilerplate — ainda era necessário revisar e ajustar cada arquivo gerado. Ele economiza o scaffolding, não a implementação.
- Toda regra nova precisa ser registrada explicitamente via `add_learning` ou editando `rules.md`. A IA não aprende passivamente com as correções feitas fora do MCP.

---

## Como executar

**Pré-requisitos:**
- Flutter 3.38.1 stable / Dart ^3.10.0
- Emulador ou device Android/iOS ativo

```bash
cd financial_health_dashboard
flutter pub get
flutter run
```

**Testes:**

```bash
flutter test
flutter test --coverage
```

**Análise estática:**

```bash
flutter analyze
```

> O app não requer backend nem variáveis de ambiente. Basta ter um device ativo.

---

## Documentação complementar

### Arquitetura (este projeto)

| Arquivo | Conteúdo |
|---------|----------|
| [docs/architecture/architecture.md](./docs/architecture/architecture.md) | Por que essa arquitetura, alternativas descartadas, SOLID, o que ficou fora de escopo |
| [docs/architecture/state_management.md](./docs/architecture/state_management.md) | Por que Cubit — trade-offs vs ValueNotifier, MobX, BLoC, Riverpod |
| [docs/architecture/ephemeral_events.md](./docs/architecture/ephemeral_events.md) | Eventos efêmeros com `effectVersion`, desacoplamento de bottom sheet |
| [docs/architecture/storage.md](./docs/architecture/storage.md) | FakeHttpService, KeyValueWrapper, StorageSchema e alternativas reais de banco |
| [docs/architecture/ia_in_process.md](./docs/architecture/ia_in_process.md) | IA no processo — onde ajudou, onde errou (com código real) |
| [docs/design/design_process.md](./docs/design/design_process.md) | Google Stitch, Figma e figma.to.code no fluxo de design |
| [docs/design/design_system.md](./docs/design/design_system.md) | ThemeExtensions, light/dark, migração shared → package |

### Documentação geral do repositório

| Arquivo | Conteúdo |
|---------|----------|
| [../docs/requirements/requirements.md](../docs/requirements/requirements.md) | Requisitos funcionais e não funcionais |
| [../docs/ia/README.md](../docs/ia/README.md) | IA no processo — regras, log e learnings |

