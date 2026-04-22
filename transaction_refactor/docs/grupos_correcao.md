# Grupos de Correção — Plano de Refatoração

> Os 25 problemas foram agrupados por causa raiz para serem atacados em conjunto.
> A ordem dos grupos respeita as dependências: resolver os grupos 1–3 antes do 6 evita retrabalho na UI.
>
> Código modernizado: [`transaction_refactor/`](../transaction_refactor/)

---

### Grupo 1 — Gerenciamento de Estado
> Problemas: #1, #2, #3, #11, #20

Todas as issues giram em torno de como o estado é inicializado, representado e atualizado. A solução de #3 (estado tipado) elimina naturalmente #1, #2 e #20.

- [x] Remover o `setState(() { isLoading = true; })` duplicado dentro de `initState` (#1)
- [x] Eliminar o `setState` de `initState`; inicializar `isLoading = true` diretamente na declaração (#2)
- [x] Substituir as três variáveis soltas por estado selado: `loading`, `success(data)`, `error(message)`, `empty` (#3)
- [x] Adicionar `if (!mounted) return;` antes de `setState` após `await` (#11)
- [x] Tratar lista vazia como estado visual explícito com mensagem adequada ao usuário (#20)

---

### Grupo 2 — Arquitetura e Separação de Responsabilidades
> Problemas: #6, #7, #8, #14, #15, #16, #17

Todos decorrem da tela assumir papéis que não são dela. A introdução de `Repository`, `UseCase` e abstrações de autenticação elimina HTTP, `SharedPrefs` e cálculo de total da apresentação — e por consequência resolve a baixa testabilidade.

- [x] Extrair a chamada HTTP para `TransactionRepository` com `Future<List<TransactionEntity>> getTransactions()` (#7)
- [x] Mover a leitura do token para `AuthTokenProvider`, removendo qualquer referência a `SharedPrefs` da tela (#8)
- [x] Criar `GetTransactionsUseCase` orquestrando o repositório e retornando dados prontos para apresentação (#15, #16)
- [x] Mover `_calcularTotal()` para o `UseCase` / `ViewModel`, eliminando lógica de negócio do widget (#6)
- [x] Fazer a tela depender apenas de abstrações, nunca de implementações concretas (#16)
- [x] Escrever testes unitários isolados para `UseCase` e `Repository` sem widget test (#17)

---

### Grupo 3 — Modelagem e Tipagem de Dados
> Problemas: #4, #5, #12, #13

Mesma raiz: o dado bruto da API atravessa todas as camadas sem ser transformado.

- [x] Criar `TransactionDto` com factory `fromJson` que valida presença e tipo de cada campo (#12)
- [x] Criar `TransactionEntity` com campos tipados: `String description`, `int amount` (centavos), `TransactionType type` (#4)
- [x] Criar `TransactionItemViewData` com dados formatados para exibição — valor como `String`, ícone, label (#5, #13)
- [x] Adicionar validação de estrutura no `fromJson`, lançando `FormatException` para campos ausentes (#12)

---

### Grupo 4 — Tratamento de Erros e Comunicação HTTP
> Problemas: #9, #10

Inseparáveis: sem validar `statusCode` (#9) não é possível categorizar o erro (#10).

- [x] Validar `statusCode` antes de decodificar o body; lançar exceções tipadas por faixa de status (#9)
- [x] Criar hierarquia selada de `Failure`: `NetworkFailure`, `AuthFailure`, `ParseFailure`, `ServerFailure`, `UnknownFailure` (#10)
- [x] Mapear cada `Failure` para mensagem amigável antes de chegar ao widget — nunca exibir stack trace (#10)

---

### Grupo 5 — Qualidade e Consistência de Código
> Problemas: #18, #21, #24

Consistência e eliminação de repetição. Baixo custo, alto ganho de legibilidade.

- [x] Criar `enum TransactionType { income, expense, unknown }` puro de domínio (sem imports Flutter); adicionar `icon` e `label` via extension de apresentação `TransactionTypePresenter` (#18)
- [x] Centralizar strings mágicas: chaves JSON no `TransactionDto`, URL no client HTTP, labels na camada de UI (#21)
- [x] Padronizar todos os identificadores em inglês (#24)

---

### Grupo 6 — Composição de UI e Experiência do Usuário
> Problemas: #19, #22, #23, #25

Dependem dos grupos anteriores (`TransactionItemViewData` e estado tipado) para serem implementados corretamente.

- [x] Envolver o `build` em `Scaffold`; organizar estados visuais em widgets separados e nomeados (`_LoadingView`, `_EmptyView`, `_ErrorView`, `_SuccessView`) (#22)
- [x] Extrair `ListTile` para `TransactionListItem` recebendo `TransactionItemViewData` — `itemBuilder` de uma linha (#25)
- [x] Substituir formatação manual por `NumberFormat.currency(locale: 'pt_BR')` do pacote `intl` (#23)
- [x] Documentar decisão arquitetural para que a equipe não repita o anti-padrão (#19)
