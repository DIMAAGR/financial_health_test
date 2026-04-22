# Financial Health MCP Server

Servidor MCP (Model Context Protocol) escrito em Dart que conecta assistentes de IA (VS Code Copilot, Claude) diretamente ao contexto do projeto Financial Health Dashboard.

O servidor não gera código do zero — ele garante que a IA que gera o código conhece as decisões já tomadas, os erros já cometidos e o padrão esperado antes de começar a responder.

---

## O problema que resolve

Sem o MCP, cada sessão com a IA começa do zero. Três consequências concretas que aconteceram neste projeto antes do servidor ser configurado:

1. **Nomes de features incorretos** — a IA gerou diretórios com nomes que não seguiam `snake_case` e imports apontando para caminhos errados. Correção manual necessária.
2. **Strings de UI na camada de domínio** — sugestão recorrente de manter `title` e `description` dentro das entidades, violando a fronteira domain/presentation.
3. **Estado com flags booleanas paralelas** — padrão que a IA sugere para reduzir código, que o projeto explicitamente rejeita em favor de estados selados mutuamente exclusivos.

Após o servidor ser configurado, essas regras ficaram disponíveis via `get_rules` e `get_learnings` desde o primeiro prompt de cada sessão. A IA não precisou ser corrigida nos mesmos pontos novamente.

---

## Ferramentas

### Leitura (contexto para a IA)

| Ferramenta | O que retorna |
|---|---|
| `get_project_context` | Arquitetura, estrutura de pastas e convenções do projeto |
| `get_rules` | Regras de governança — o que a IA deve e não deve fazer neste projeto |
| `get_learnings` | Erros documentados com causa raiz e prevenção |
| `search_prompt_log` | Busca no histórico de interações por termo ou data |

### Escrita (registro de decisões)

| Ferramenta | O que faz |
|---|---|
| `log_interaction` | Registra um prompt e sua decisão no `prompt_log.md` com timestamp |
| `add_learning` | Registra um erro com causa raiz e prevenção no `learnings.md` |

### Geração (scaffolding)

| Ferramenta | O que faz |
|---|---|
| `generate_feature_structure` | Cria a hierarquia completa de diretórios e arquivos de uma feature (`data/domain/presentation`) com naming correto |
| `generate_cubit_test` | Analisa o source de um Cubit e gera scaffold de teste com padrão AAA e estados cobertos |

---

## Como o MCP foi usado no desenvolvimento

```
Início de sessão:
  IA chama get_rules + get_learnings
  → conhece as restrições antes de qualquer prompt de código

Durante desenvolvimento:
  IA chama log_interaction ao tomar decisão arquitetural
  → audit trail automático em prompt_log.md

Quando erro é identificado:
  IA chama add_learning com causa raiz e prevenção
  → próximas sessões não repetem o erro

Nova feature:
  IA chama generate_feature_structure com nome da feature
  → 14+ diretórios e arquivos criados com naming correto em segundos
```

O que o MCP **não** faz: não impede que a IA gere código errado — ele garante que a IA tem o contexto certo para gerar código alinhado. A validação ainda é manual.

---

## Estrutura

```
tools/mcp_server/
  bin/
    main.dart                    # entry point — registra ferramentas e inicia servidor stdio
  lib/src/
    doc_paths.dart               # caminhos para os arquivos de documentação
    tools/
      context_tools.dart         # get_project_context, get_rules, get_learnings, search_prompt_log
      logging_tools.dart         # log_interaction, add_learning
      generation_tools.dart      # generate_feature_structure, generate_cubit_test
  test/                          # 29 testes cobrindo todas as ferramentas
```

---

## Instalação e configuração

**Pré-requisitos:** Dart SDK `^3.10.0`

```bash
cd tools/mcp_server
dart pub get
```

### VS Code

O arquivo `.vscode/mcp.json` já está configurado na raiz do projeto:

```json
{
  "servers": {
    "financial-health-mcp": {
      "type": "stdio",
      "command": "dart",
      "args": [
        "run",
        "bin/main.dart",
        "--project-root",
        "${workspaceFolder:financial_health_test}"
      ],
      "cwd": "${workspaceFolder:financial_health_test}/tools/mcp_server"
    }
  }
}
```

> O workspace deve ser aberto na raiz `financial_health_test/` — não em `financial_health_dashboard/` isolado. O servidor lê `docs/`, `tools/` e `lib/` da raiz do repositório.

> Se o workspace tiver outro nome para a pasta raiz, substituir `financial_health_test` em `workspaceFolder:financial_health_test` pelo nome correto, ou usar caminho absoluto.

### Outros MCP hosts (Claude Desktop, etc.)

```json
{
  "mcpServers": {
    "financial-health-mcp": {
      "command": "dart",
      "args": ["run", "bin/main.dart", "--project-root", "/caminho/para/financial_health_test"],
      "cwd": "/caminho/para/financial_health_test/tools/mcp_server"
    }
  }
}
```

---

## Testes

```bash
cd tools/mcp_server
dart test
```

29 testes cobrindo:
- Leitura e parsing de documentação (context, rules, learnings, search)
- Operações de escrita com auto-indexação (log, learning)
- Geração de feature structure com validação de naming
- Análise de Cubit source e geração de test scaffold
- Utilitários de conversão (`snake_case` ↔ `PascalCase`)

---

## Vantagens e limitações observadas no projeto

Ver análise detalhada com exemplos concretos em [financial_health_dashboard/README.md](../../financial_health_dashboard/README.md#mcp-server-no-processo-de-desenvolvimento).


---

## Exemplos de uso

### 1. Antes de implementar: consultar contexto

A IA chama `get_learnings` e descobre que o time já errou ao:
- Usar flags booleanas em vez de enums para estado
- Colocar labels de UI no domain layer
- Hardcodar cores fora do theme

Resultado: evita repetir os mesmos erros.

### 2. Scaffolding de feature

```
Tool: generate_feature_structure
Args: { "feature_name": "transaction_detail" }
```

Cria automaticamente:
- 14 diretórios (data/domain/presentation + espelhos em test/)
- 5 arquivos (init, failure, repository contract, repository impl, datasource)
- Nomenclatura consistente (PascalCase para classes, snake_case para arquivos)

### 3. Geração de teste a partir de Cubit

```
Tool: generate_cubit_test
Args: { "cubit_file_path": "lib/src/features/dashboard/presentation/view_model/dashboard/dashboard_cubit.dart" }
```

O servidor:
1. Lê o arquivo Dart
2. Extrai: nome do Cubit, nome do State, dependências do construtor, métodos públicos
3. Gera scaffold de teste com: imports, estrutura de grupo, Arrange/Act/Assert, happy path + error path para cada método

Limitação conhecida: `generate_cubit_test` não usa AST/analyzer completo. Ele faz análise textual do source para gerar um template inicial. Funciona bem para Cubits simples e consistentes com o padrão do projeto, mas pode exigir ajuste manual em Cubits com múltiplas classes no mesmo arquivo, construtores complexos, generics, dependências opcionais ou métodos com assinaturas fora do padrão.

---

## Ganho de produtividade estimado (time de 5-10 devs)

| Atividade | Sem MCP | Com MCP | Saving/dev/semana |
|---|---|---|---|
| Contexto inicial por sessão IA | 5-10 min (ler docs, copiar regras) | 0 min (automático) | ~30-60 min |
| Scaffolding de feature | 15-20 min (criar pastas, boilerplate) | <1 min (1 tool call) | ~15-20 min/feature |
| Scaffold de teste para Cubit | 10-15 min (imports, mocks, estrutura) | <1 min (1 tool call) | ~10-15 min/cubit |
| Logging de decisão IA | 3-5 min (abrir arquivo, formatar) | 0 min (tool call) | ~15-25 min |
| Pesquisa em decisões passadas | 5-10 min (ctrl+f em múltiplos docs) | <1 min (search tool) | ~20-40 min |

**Estimativa conservadora**: 1-2h/dev/semana economizadas em tarefas mecânicas.
Para um time de 10 devs: **10-20h/semana** reinvestidas em lógica de negócio.

---

## Arquitetura

```
tools/mcp_server/
├── bin/
│   └── main.dart                      # Entry point: resolve paths, register tools, start server
├── lib/src/tools/
│   ├── context_tools.dart             # get_project_context, get_rules, get_learnings, search_prompt_log
│   ├── logging_tools.dart             # log_interaction, add_learning
│   └── generation_tools.dart          # generate_feature_structure, generate_cubit_test
├── test/
│   └── tools_test.dart                # 28 testes unitários
├── pubspec.yaml
└── README.md
```

### Decisões técnicas

| Decisão | Alternativa | Motivo |
|---|---|---|
| Dart puro (não Flutter) | Node.js / Python | Mantém consistência com o stack do projeto; devs do time já conhecem |
| `mcp_dart` SDK | Implementação manual do protocolo | SDK maduro (2.1.0, 26k downloads), spec 2025-11-25 compliant |
| Funções públicas testáveis | Tudo privado nos callbacks | Permite testes unitários diretos sem mock do protocolo MCP |
| `readDoc()` por arquivo | Ler tudo em memória no startup | Mais simples, docs são pequenos, evita stale cache |
| `dry_run` em generate_feature | Sempre criar | Segurança: permite preview antes de criar 14+ diretórios |
| Análise textual em `generate_cubit_test` | AST com analyzer Dart | Menor escopo para o bônus; gera scaffold útil, mas a limitação é documentada e requer validação humana |

---

## Licença

Mesmo do projeto principal.
