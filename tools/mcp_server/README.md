# Financial Health MCP Server

Servidor MCP (Model Context Protocol) que conecta assistentes de IA ao contexto do projeto **Financial Health Dashboard**, padronizando o acesso à documentação, logging de interações e geração automatizada de código.

---

## Problema que resolve

Em times Flutter de 5–10 devs usando IA no dia a dia, três problemas são recorrentes:

1. **Perda de contexto entre sessões**: cada nova conversa com a IA começa do zero — a IA não sabe quais decisões já foram tomadas, quais erros já aconteceram, nem qual padrão o time segue.
2. **Inconsistência no uso da IA**: sem padronização, cada dev interage com a IA de forma diferente: um loga decisões, outro não; um segue a arquitetura, outro desvia.
3. **Scaffolding repetitivo**: criar uma feature nova exige montar 14+ diretórios e 5+ arquivos boilerplate — tarefa mecânica que consome tempo e introduz erros de naming.

O MCP server resolve os três ao ser **a fonte única de verdade** entre a IA e o projeto.

---

## Como funciona

O servidor implementa o [Model Context Protocol](https://modelcontextprotocol.io) via stdio, usando o SDK [`mcp_dart`](https://pub.dev/packages/mcp_dart). Ele roda como processo local e se conecta ao VS Code (ou qualquer MCP host) como um backend de ferramentas.

### Ferramentas disponíveis

| Ferramenta | Tipo | Descrição |
|---|---|---|
| `get_project_context` | Leitura | Retorna arquitetura + convenções do projeto |
| `get_rules` | Leitura | Retorna regras de governança IA + guardrails TOON |
| `get_learnings` | Leitura | Retorna erros documentados com causa raiz e prevenção |
| `search_prompt_log` | Leitura | Busca no histórico de interações IA por termo |
| `log_interaction` | Escrita | Registra nova interação no prompt_log.md |
| `add_learning` | Escrita | Registra novo aprendizado no learnings.md |
| `generate_feature_structure` | Geração | Cria hierarquia completa de pastas e arquivos para uma feature |
| `generate_cubit_test` | Geração | Analisa o texto de um Cubit e gera scaffold de teste com padrão AAA |

### Fluxo de uso

```
Developer ↔ VS Code (Copilot/Claude) ↔ MCP Protocol ↔ financial-health-mcp ↔ docs/ + lib/
```

1. A IA consulta `get_rules` e `get_learnings` antes de implementar
2. Ao tomar decisões, chama `log_interaction` para manter o audit trail
3. Se identifica um erro, chama `add_learning` para registrar
4. Para uma nova feature, chama `generate_feature_structure` para scaffolding instantâneo
5. Para testes, chama `generate_cubit_test` que analisa o source e gera scaffold

---

## Configuração

### Pré-requisitos

- Dart SDK `^3.10.0` (validado com Dart 3.10.0)
- VS Code com extensão GitHub Copilot (ou qualquer MCP host)

### Instalação

```bash
cd tools/mcp_server
dart pub get
```

### VS Code

O arquivo `.vscode/mcp.json` já está configurado na raiz do projeto. Ele usa `${workspaceFolder:financial_health_test}` para evitar ambiguidade em workspaces com mais de uma pasta aberta.

```json
{
  "inputs": [],
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
      "cwd": "${workspaceFolder:financial_health_test}/tools/mcp_server",
      "env": {
        "PROJECT_ROOT": "${workspaceFolder:financial_health_test}"
      }
    }
  }
}
```

> Se o workspace no VS Code tiver outro nome para a raiz do repositório, ajuste `financial_health_test` no `.vscode/mcp.json` ou use caminhos absolutos. Abrir apenas `financial_health_dashboard/` como root não é suficiente para este MCP, porque ele também lê `docs/` e `tools/`.

### Outros MCP hosts (Claude Desktop, etc.)

```json
{
  "mcpServers": {
    "financial-health-mcp": {
      "command": "dart",
      "args": ["run", "bin/main.dart", "--project-root", "/path/to/financial_health_test"],
      "cwd": "/path/to/financial_health_test/tools/mcp_server"
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
- Utilitários de conversão (snake_case ↔ PascalCase)

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
