# Learnings e Memória de Erros

Arquivo de memória para consulta antes de novas mudanças.

## Como usar

1. Ler este arquivo antes de implementar/refatorar.
2. Adicionar novas entradas sempre que houver erro relevante.
3. Converter recorrências em checklist de prevenção.

## Entradas

### [2026-04-14] Ambiguidade de estado na UI
- Erro: modelagem inicial sugerida por IA com múltiplas flags (`isLoading`, `error`, `data`).
- Causa raiz: simplificação excessiva sem garantir exclusividade de estado.
- Correção: migração para estados explícitos e mutuamente exclusivos via Cubit.
- Prevenção: evitar flags paralelas para fluxo principal de tela.

### [2026-04-15] Hardcoded de cores fora do tema
- Erro: uso de cores fixas em resolver de estilo do card principal.
- Causa raiz: código vindo de geração visual sem alinhamento completo com design tokens.
- Correção: mover paleta para `ThemeExtension` e consumir por contexto.
- Prevenção: toda nova cor visual deve nascer no tema/tokens.

### [2026-04-15] Parâmetro sem efeito real em widget
- Erro: `MetricCardSize` existia, mas não alterava layout.
- Causa raiz: boilerplate gerado sem validação de comportamento.
- Correção: tamanho passou a afetar padding, tipografia e ícone.
- Prevenção: validar se todo parâmetro público muda comportamento observável.

### [2026-04-16] Label de apresentação vazando para domínio/data
- Erro: categorias de transação foram unificadas no domínio e serializadas pelo `label` em português.
- Causa raiz: a refatoração reduziu duplicação da UI, mas levou um artefato visual (`TransactionCategory`) para o núcleo de negócio.
- Correção: separar `IncomeCategory` e `ExpenseCategory` no domínio, mover `TransactionCategory` para presentation e serializar `category.code` no repository/data.
- Prevenção: usar mapper explícito entre UI e domínio sempre que a UI agrupar conceitos que o domínio precisa manter separados.

### [2026-04-17] Loops abertos: código declarado sem consumo
- Erro: `CommitmentStatus` enum declarado e nunca renderizado na UI; pastas e rotas criadas vazias; `Future.delayed` artificial no cubit simulando IO.
- Causa raiz: geração incremental de código com IA priorizou "preparar para depois" sem validar se o "depois" existia no escopo.
- Correção: remoção de tudo que não era consumido em nenhum widget ou teste. Delay movido para a camada de dados (onde faz sentido).
- Prevenção: antes de comitar, verificar se todo artefato declarado é consumido em pelo menos um lugar real (widget, teste ou rota).

### [2026-04-17] Bottom sheet fechava antes de confirmar sucesso
- Erro: o sheet fazia `pop` imediatamente após `submit()` e só depois chamava `addIncome`/`addExpense` no cubit da dashboard.
- Causa raiz: fluxo original tratava o sheet como formulário puro (coletar dados → devolver), sem considerar que o feedback de sucesso/falha deveria ser visível no próprio sheet.
- Correção: `onSubmit` callback que retorna `Future<bool>`; sheet só fecha no `true`; no `false` reseta `isSubmitting` para o usuário tentar novamente.
- Prevenção: quando um modal dispara side-effect com latência, o modal deve aguardar confirmação antes de fechar.

## Checklist rápido pré-implementação

- Estados principais da tela são exclusivos?
- Há cor hardcoded fora de tema/tokens?
- Todo parâmetro público do widget tem efeito real?
- O componente está desacoplado de regra de negócio?
- Existe teste ou validação mínima para a mudança?
- Payload/storage usa `code` estável em vez de `label` de UI?
- MCP está ativo antes do primeiro prompt de código?
- Valores monetários são `int` (centavos), não `double`?

### [2026-04-22] MCP configurado no meio do projeto

- Erro: features geradas antes do MCP estar ativo usavam naming inconsistente com as convenções definidas depois.
- Causa raiz: regras de `get_rules` foram registradas depois que o scaffolding inicial já havia sido gerado.
- Correção: renomeação manual das features afetadas.
- Prevenção: em projetos novos, popular `get_rules` com convenções de naming antes de qualquer geração de código.

### [2026-04-22] generate_cubit_test sem estado inicial

- Erro: scaffold de teste gerado pela ferramenta MCP não incluía assertion para o estado inicial do Cubit.
- Causa raiz: template da ferramenta focava nos métodos de ação, não no estado após construção.
- Correção: assertion de estado inicial adicionada manualmente; template da ferramenta atualizado.
- Prevenção: todo scaffold de teste de Cubit deve incluir o estado inicial como primeiro caso.

### [2026-04-22] get_rules ativo não garantiu int para valor monetário

- Erro: a IA sugeriu `double` para valor monetário mesmo com a regra de `int em centavos` documentada em `get_rules`.
- Causa raiz: o prompt não explicitou contexto de dinheiro — a IA não conectou a regra ao código gerado.
- Correção: substituição manual para `int`; learning adicionado; prompts seguintes passaram a mencionar explicitamente a restrição.
- Prevenção: quando a IA gerar qualquer campo de valor monetário, verificar o tipo antes de aceitar o output.
