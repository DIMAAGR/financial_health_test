## Modernização

O enunciado pede: **Use IA para gerar a versão modernizada. Documente o prompt exato que você usou — como você alimentou o legado como especificação para a IA gerar algo novo e limpo.**

---

### Estratégia de Prompt

O código legado foi usado diretamente como contexto/especificação para a IA. A estratégia foi alimentar o código original colado na íntegra, seguido dos problemas identificados agrupados por causa raiz, e então pedir a geração com arquitetura e padrões explicitamente definidos no prompt.

Isso forçou a IA a tratar o legado como a "especificação do comportamento desejado" em vez de descrevê-lo em prosa — o que gerou um output muito mais fiel ao contrato original.

Para ver o histórico completo de prompts, questionamentos e correções iterativas: [prompt_log.md](./prompt_log.md)

---

### Prompt Principal Usado


> Observe o código abaixo:

> ```dart
> class TransactionPage extends StatefulWidget {
> @override
>_TransactionPageState createState() => _TransactionPageState();
>}
>class _TransactionPageState extends State<TransactionPage> {
>List<Map<String, dynamic>> transactions = [];
>bool isLoading = false;
>String? error;
>@override
>void initState() {
>super.initState();
>_loadTransactions();
>setState(() { isLoading = true; });
>}
>Future<void> _loadTransactions() async {
>setState(() { isLoading = true; });
>try {
>final response = await http.get(
>Uri.parse('https://api.example.com/v1/transactions'),
>headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'},
>);
>final data = json.decode(response.body) as List;
>setState(() {
>transactions = data.cast<Map<String, dynamic>>();
>isLoading = false;
>});
>} catch (e) {
>setState(() {
>error = 'Erro ao carregar transações: $e';
>isLoading = false;
>});
>}
>}
>double _calcularTotal() {
>return transactions.fold(0, (sum, t) => sum + (t['valor'] as num));
>}
>@override
>Widget build(BuildContext context) {
>if (isLoading) return Center(child: CircularProgressIndicator());
>if (error != null) return Center(child: Text(error!));
>return Column(
>children: [
>Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'),
>Expanded(
>child: ListView.builder(
>itemCount: transactions.length,
>itemBuilder: (_, i) => ListTile(
>title: Text(transactions[i]['descricao'] ?? ''),
>subtitle: Text('R\$ ${transactions[i]['valor']}'),
>trailing: Icon(
>transactions[i]['tipo'] == 'receita'
>? Icons.arrow_upward : Icons.arrow_downward,
>color: transactions[i]['tipo'] == 'receita'
>? Colors.green : Colors.red,
>),
>),
>),
>),
>],
>);
>}
>}

> ```

> é necessária uma refatoração urgente utilizando Clean Architecture + MVVM + ValueNotifier. `lib/` terá `core/`, `features/`, `shared/`. `get_it` para injeção de dependências.

> Ver análise detalhada dos 25 problemas: [problemas_detalhados.md](./problemas_detalhados.md)

---

### Problemas Identificados no Código Legado

1. setState redundante no initState

No initState, ele chama _loadTransactions(); e logo depois faz:

setState(() { isLoading = true; });

Mas _loadTransactions() já começa com:

setState(() { isLoading = true; });

Então há duplicidade de atualização de estado. Isso é ruído e pode gerar rebuild desnecessário.

2. setState dentro do initState é desnecessário nesse caso

No initState, o widget ainda está no ciclo inicial de montagem. Em muitos casos, basta inicializar:

bool isLoading = true;

ou mudar o valor sem setState, porque a primeira renderização ainda vai acontecer. Aqui o setState piora a clareza.

3. Estado muito genérico e mal modelado

O estado da tela está espalhado em três variáveis soltas:

List<Map<String, dynamic>> transactions = [];
bool isLoading = false;
String? error;

Isso gera combinações inválidas ou ambíguas, por exemplo:

* isLoading == true e error != null
* transactions preenchido mas error ainda antigo
* isLoading == false com lista vazia sem distinguir “vazio” de “erro” ou “sucesso”

Falta um estado explícito, como:

* initial
* loading
* success(data)
* error(message)
* empty

4. Uso de Map<String, dynamic> em vez de modelo tipado

Esse é um dos maiores anti padrões aqui:

List<Map<String, dynamic>> transactions = [];

Problemas:

* sem autocomplete confiável
* sem validação forte de tipo
* mais chance de typo em strings ('valor', 'descricao', 'tipo')
* parsing espalhado pela UI
* difícil manutenção

O ideal seria um TransactionModel / TransactionEntity.

5. UI acoplada ao formato cru da API

A UI acessa diretamente chaves da resposta:

transactions[i]['descricao']
transactions[i]['valor']
transactions[i]['tipo']

Ou seja, a tela conhece o contrato bruto da API. Isso gera forte acoplamento entre apresentação e infraestrutura. Se a API mudar de descricao para description, a UI quebra.

6. Regra de negócio dentro da camada de apresentação

O cálculo do total está na própria tela:

double _calcularTotal() {
  return transactions.fold(0, (sum, t) => sum + (t['valor'] as num));
}

Isso é lógica de negócio ou, no mínimo, de transformação de dado. Não deveria ficar no widget. Isso dificulta:

* reuso
* teste unitário isolado
* separação de responsabilidades

7. Chamada HTTP direta na tela

Aqui há acoplamento forte com infraestrutura:

final response = await http.get(...)

A tela está:

* iniciando requisição
* montando header
* lendo token
* fazendo parse
* tratando erro
* armazenando estado
* renderizando UI

Ela está fazendo coisa demais. Viola SRP fortemente.

8. Dependência direta de SharedPrefs.getToken()

Isso aumenta ainda mais o acoplamento:

headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'},

Problemas:

* a tela sabe como autenticação funciona
* depende de storage local diretamente
* dificulta mock em testes
* mistura responsabilidade de sessão/autorização com apresentação

Isso deveria estar em um serviço, client, interceptor ou repository.

9. Ausência de validação de statusCode

O código ignora completamente o status HTTP:

final response = await http.get(...)
final data = json.decode(response.body) as List;

Se vier 401, 403, 500, HTML, ou JSON com estrutura de erro, ele tenta dar json.decode e cast para List do mesmo jeito. Isso é frágil.

10. Tratamento de erro genérico e pouco confiável

O catch faz:

error = 'Erro ao carregar transações: $e';

Problemas:

* expõe erro técnico bruto para UI
* mistura mensagem amigável com detalhe interno
* pode mostrar exceções confusas ao usuário
* não categoriza erros (rede, auth, timeout, parse, servidor)

Falta uma abstração de falha (Failure, AppError, etc.).

11. Ausência de mounted antes de setState após await

Depois de uma chamada assíncrona, o widget pode já ter sido descartado. Mesmo assim ele faz:

setState(() {
  ...
});

Sem verificar:

if (!mounted) return;

Isso pode causar erro em tempo de execução ao tentar atualizar estado de widget desmontado.

12. Parsing inseguro

Esse trecho é frágil:

final data = json.decode(response.body) as List;
transactions = data.cast<Map<String, dynamic>>();

Assume que:

* a resposta sempre é lista
* todos os itens são Map<String, dynamic>
* todos os campos existem no formato esperado

Sem validação, qualquer mudança quebra em runtime.

13. Falta de separação entre entity, model e view data

O mesmo dado cru da API está sendo usado para:

* cálculo
* renderização
* decisão de ícone/cor
* exibição textual

Isso mistura responsabilidades. O ideal seria algo como:

* TransactionDto para a API
* TransactionEntity para domínio
* TransactionItemViewData para UI

14. Código pouco legível por causa da concentração de responsabilidades

Essa classe concentra:

* ciclo de vida
* estado
* chamada remota
* autenticação
* parse JSON
* tratamento de erro
* cálculo de total
* regra visual de tipo
* renderização

Mesmo sendo curta, ela já está cognitivamente pesada. Isso prejudica compreensão e manutenção.

15. Violação do SRP (Single Responsibility Principle)

A tela tem múltiplas razões para mudar:

* mudança na API
* mudança na autenticação
* mudança no cálculo do total
* mudança na estrutura do dado
* mudança no tratamento de erro
* mudança na UI

Isso é um caso clássico de violação de responsabilidade única.

16. Violação de DIP (Dependency Inversion Principle)

A tela depende de implementações concretas:

* http.get
* SharedPrefs.getToken

Ela deveria depender de abstrações, como:

* TransactionRepository
* GetTransactionsUseCase
* AuthTokenProvider

Assim ficaria mais desacoplada e testável.

17. Baixa testabilidade

Testar isso direito é ruim porque:

* a lógica está misturada no widget
* depende de http real ou mock complexo direto na tela
* depende de SharedPrefs
* cálculo do total está dentro da UI
* parsing está embutido no fluxo visual

Você até consegue testar com widget test + mocks, mas fica muito mais trabalhoso do que deveria.

18. DRY parcialmente violado

A lógica de “receita ou despesa” aparece repetida:

transactions[i]['tipo'] == 'receita'
? Icons.arrow_upward : Icons.arrow_downward,

e também:

color: transactions[i]['tipo'] == 'receita'
? Colors.green : Colors.red,

A mesma condição é reavaliada mais de uma vez. O ideal seria encapsular isso em um model, enum ou mapper visual.

19. KISS mal aplicado

À primeira vista parece “simples”, mas é uma simplicidade enganosa. O código ficou curto porque ignorou separação de camadas. Isso reduz boilerplate no começo, mas aumenta complexidade de manutenção depois. Não é simplicidade sustentável.

20. Falta de tratamento para estado vazio

Se a API retornar lista vazia, a tela mostra:

Total: R$ 0.00

e uma lista vazia embaixo. Não existe UX clara para “sem transações”. Isso reduz clareza para o usuário.

21. Strings mágicas espalhadas

Essas strings estão hardcoded:

'descricao'
'valor'
'tipo'
'receita'
'https://api.example.com/v1/transactions'
'Authorization'

Isso dificulta manutenção, aumenta chance de erro e espalha conhecimento técnico em lugares errados.

22. Widget de página sem estrutura de página

O build retorna diretamente um Column, Center, etc. Dependendo do contexto, isso pode funcionar, mas como “Page” isso sugere que falta composição mais clara com Scaffold, estados visuais organizados e widgets separados.

23. Falta de internacionalização e formatação monetária adequada

O total é montado manualmente:

'Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'

Isso não usa NumberFormat, então:

* não respeita locale
* não separa milhar corretamente
* não centraliza formatação monetária

24. Nomes misturam idiomas e intenções

Temos:

* TransactionPage
* _loadTransactions
* _calcularTotal

Mistura inglês e português. Não quebra o sistema, mas prejudica consistência e legibilidade do projeto.

25. Falta de composição de widgets

O ListTile com lógica de tipo, valor e ícone está inline no itemBuilder. Isso reduz reuso e dificulta leitura. Um widget como TransactionListItem deixaria mais claro.


faça uma lista dividida por grupos para que ao invés de atacar cada erro individualmente de possa ser atacado em conjunto, para isso é necessário que eles façam sentido entre sí 

---



## TODO — Refatoração de `TransactionPage`

A lógica de agrupamento foi: problemas que compartilham a mesma causa raiz ficaram juntos (ex.: Grupo 2 todo nasce do fato de a tela ter responsabilidades demais), e os grupos foram ordenados por dependência — resolver Grupo 2 e 3 antes do Grupo 6 evita retrabalho na UI.

---

### Grupo 1 — Gerenciamento de Estado

> Problemas: #1, #2, #3, #11, #20

Todas as issues deste grupo giram em torno de como o estado da tela é inicializado, representado e atualizado. Atacar em conjunto evita retrabalho porque a solução de #3 (estado tipado) elimina naturalmente #1, #2 e #20.

- [x] Remover o `setState(() { isLoading = true; })` duplicado dentro de `initState`, pois `_loadTransactions()` já o faz internamente (#1)
- [x] Eliminar o `setState` de `initState` por completo; inicializar `isLoading = true` diretamente na declaração do campo, já que o widget ainda não foi montado (#2)
- [x] Substituir as três variáveis soltas (`transactions`, `isLoading`, `error`) por um único estado selado/enum com os casos: `initial`, `loading`, `success(data)`, `error(message)`, `empty` — eliminando combinações de estado inválidas (#3)
- [x] Adicionar `if (!mounted) return;` antes de qualquer `setState` que ocorra após um `await`, para evitar atualização de widget já desmontado (#11)
- [x] Tratar o caso de lista vazia como um estado visual explícito (`empty`), exibindo mensagem adequada ao usuário em vez de mostrar `Total: R$ 0,00` com lista em branco (#20)

---

### Grupo 2 — Arquitetura e Separação de Responsabilidades

> Problemas: #6, #7, #8, #14, #15, #16, #17

Este é o grupo de maior impacto. Todos os problemas aqui decorrem da tela assumir papéis que não são dela. Resolver em conjunto porque a introdução de `Repository`, `UseCase` e abstrações de autenticação elimina de vez o HTTP, o `SharedPrefs` e o cálculo de total da camada de apresentação — o que por consequência resolve também a baixa testabilidade.

- [x] Extrair a chamada HTTP para um `TransactionRepository` (ou `RemoteTransactionDataSource`), expondo apenas um método como `Future<List<TransactionEntity>> getTransactions()` (#7)
- [x] Mover a leitura do token para um `AuthTokenProvider` / interceptor / client HTTP centralizado, removendo qualquer referência a `SharedPrefs` da tela e do repositório (#8)
- [x] Criar um `GetTransactionsUseCase` que orquestre o repositório, aplique regras de negócio e retorne dados prontos para a camada de apresentação (#15, #16)
- [x] Mover o cálculo de `_calcularTotal()` para o `UseCase` ou para um `ViewModel`/`Cubit`/`Bloc`, eliminando lógica de negócio do widget (#6)
- [x] Fazer a tela depender apenas de abstrações (`abstract class TransactionRepository`, `abstract class AuthTokenProvider`), nunca de implementações concretas de `http` ou `SharedPrefs` (#16)
- [x] Após a reestruturação, escrever testes unitários isolados para o `UseCase` e o `Repository` sem necessidade de widget test (#17)

---

### Grupo 3 — Modelagem e Tipagem de Dados

> Problemas: #4, #5, #12, #13

Estes problemas compartilham a mesma raiz: o dado bruto da API (`Map<String, dynamic>`) atravessa todas as camadas sem ser transformado. A solução é criar as camadas de modelo corretas de uma só vez.

- [x] Criar um `TransactionDto` para representar o JSON da API, com factory `fromJson` que valida a presença e o tipo de cada campo antes de fazer cast (#12)
- [x] Criar uma `TransactionEntity` (domínio) com campos tipados: `String descricao`, `int valor` (centavos), `TransactionType tipo` (enum) — eliminando `Map<String, dynamic>` e strings mágicas de tipo (#4)
- [x] Criar um `TransactionItemViewData` (ou presentation model) com os dados já formatados para exibição: valor como `String`, ícone, label — desacoplando a UI do contrato da API e da entidade de domínio (#5, #13)
- [x] Adicionar validação de estrutura no `fromJson` do `TransactionDto`, lançando `FormatException` se a resposta não for lista ou se campos obrigatórios estiverem ausentes (#12)

---

### Grupo 4 — Tratamento de Erros e Comunicação HTTP

> Problemas: #9, #10

Estes dois problemas são inseparáveis: sem validar o `statusCode` (#9) não é possível categorizar o erro (#10). Devem ser resolvidos na mesma camada (repositório/client HTTP).

- [x] Validar o `statusCode` da resposta antes de tentar decodificar o body; lançar exceções tipadas para cada faixa: `UnauthorizedException` (401/403), `ServerException` (5xx), `UnexpectedResponseException` (outros) (#9)
- [x] Criar uma hierarquia de `Failure` / `AppError` (ex.: `NetworkFailure`, `AuthFailure`, `ParseFailure`, `ServerFailure`) para categorizar erros sem expor detalhes técnicos à UI (#10)
- [x] Mapear cada `Failure` para uma mensagem amigável e localizada antes de chegar ao widget, garantindo que a tela nunca exiba stack traces ou mensagens de exceção brutas (#10)

---

### Grupo 5 — Qualidade e Consistência de Código

> Problemas: #18, #21, #24

Problemas de consistência textual e repetição de lógica. Podem ser atacados juntos com baixo custo e alto ganho de legibilidade.

- [x] Criar um `enum TransactionType { income, expense, unknown }` puro de domínio (sem dependências de Flutter) e adicionar `icon` e `label` via `TransactionTypePresenter` extension na camada de apresentação, eliminando as condições duplicadas `tipo == 'receita'` no `itemBuilder` (#18)
- [x] Centralizar todas as strings mágicas: chaves JSON no `TransactionDto`, URL base no client HTTP ou em um arquivo de constantes/environment, strings de labels na camada de i18n ou constantes de UI (#21)
- [x] Padronizar o idioma dos identificadores para inglês (ex.: `_loadTransactions` → já ok, mas `_calcularTotal` → `_calculateTotal`); aplicar o mesmo padrão a todos os novos símbolos criados na refatoração (#24)

---

### Grupo 6 — Composição de UI e Experiência do Usuário

> Problemas: #19, #22, #23, #25

Estes problemas afetam a camada visual. Devem ser atacados após os grupos anteriores, pois dependem de `TransactionItemViewData` (Grupo 3) e do estado tipado (Grupo 1) para serem implementados corretamente.

- [x] Envolver o `build` com um `Scaffold` adequado (ou garantir que o pai já o proveja), organizando os estados visuais — loading, error, empty, success — em widgets separados e nomeados (#22)
- [x] Extrair o `ListTile` para um widget próprio `TransactionListItem` que receba um `TransactionItemViewData`, tornando o `itemBuilder` de uma linha e o widget reutilizável (#25)
- [x] Substituir a formatação manual `'R\$ ${valor.toStringAsFixed(2)}'` por `NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')` do pacote `intl`, centralizando a formatação monetária (#23)
- [x] Avaliar se a "simplicidade" atual justifica o custo de manutenção; documentar a decisão arquitetural adotada para que a equipe não repita o mesmo anti-padrão em outras pages (#19)

---

### Prompts e Refatoração:

Vale a pena mencionar sobre os **questionamentos pós prompt** que, a forma como eu trabalho com eles é: leio e reviso o código, encontro os possíveis problemas, copio o trecho e jogo em um chat a parte com os pontos que eu acredito que são importantes ou que devem ser corrijidos/melhorados, e peço para que a IA me descreva em detalhes o porque se faz sentido se não e se ela achou outros pontos que também carecem de atenção, retorno os resultados de volta para o chat onde estou implementando a solução para que a IA corrija, acho um ponto válido utilizar a própria IA para ajudar a checar e ver pontos de observação dentro do próprio código gerado por ela.



**Prompt 1** - agora, peço que ataque os grupos e escreva todo o código, vamos utilizar o padrão do flutter clean arch + mvvm, e para esse teste, utilizaremos o ValueNotifier como estado qualquer mock será um mock simples ok, crie o projeto e comece a codar código dentro de lib

lib será core/ feature/ shared/

core/app/app.dart conterá o mainApp

get_it simples para injeção de dependencias caso haja necessidade

**Questionamentos feitos após o primeiro prompt**: algumas coisas que podem ser questionáveis, e por isso quero entender o porque você fez:

O que é questionável:

* Método listFromJson:
  - Por que tirar? Geralmente, a lógica de iterar sobre uma lista e tratar erros de coleção pertence à camada de Datasource ou ao próprio repositório. O DTO deve se preocupar em converter um objeto.
  - Onde colocar? No RemoteDataSource, você receberia o Response.data, verificaria se é uma lista e chamaria o TransactionDto.fromJson dentro de um .map().
* Lançar ParseException customizada dentro do DTO:
  - Embora seja seguro, alguns desenvolvedores preferem que o DTO lance erros genéricos de cast do Dart e o Datasource capture isso, transformando em um Failure. Se o seu FailureHandler já espera essa ParseException, pode manter, mas saiba que isso acopla o DTO a uma lógica de erro específica da infraestrutura.

---

**Prompt 2**: Ok, Siga para o segundo grupo.

**Questionamentos feitos após o segundo prompt**: 
Dentro dessa classe TransactionType existe um acoplamento do flutter nele:

* O maior erro aqui é importar package:flutter/material.dart dentro de um Enum que deveria ser de Domínio.
  - Problema: Se este enum está na camada de Domain (como sugerido pelo caminho no import do DTO anterior), ele não deveria saber o que é um IconData ou Color.
  - Consequência: Você não consegue testar essa lógica em testes unitários puros (sem dependências de UI) e dificulta a reutilização do domínio em outros pacotes que não usem Flutter.

* No método fromRaw, você está usando _ => TransactionType.expense como padrão.
  - Problema: Se a API retornar um erro ou um valor vazio, ele será tratado silenciosamente como uma Despesa.
  - Sugestão: O ideal é ter um unknown ou lançar uma exceção clara, para que o desenvolvedor saiba que a API enviou algo não mapeado.

* O campo label retorna uma string fixa em português.
  - Problema: Se o app precisar de suporte a inglês futuramente, você terá que alterar o domínio.
  - Onde deveria estar: A tradução e a escolha de ícones/cores deveriam estar em uma classe de Presenter, Mapper ou uma Extension dentro da camada de UI.

* Cores deveriam estar em shared/presentation/design em um ThemeExtension.

* O Enum está fazendo coisas demais:
  - Definindo os tipos (Domínio).
  - Parseando dados da API (Infra/Data).
  - Definindo estilo visual (Apresentação).
  - Definindo tradução (Internacionalização).

**Segundo Questionamento:**

Alguns problemas que eu encontrei no UseCase:

* Imprecisão com double (O problema mais grave)
  - Estamos lidando com dinheiro (transações) usando double.
  - Problema: Em Dart (e na maioria das linguagens), somar e subtrair double causa erros de precisão decimal (ex: 0.1 + 0.2 pode resultar em 0.30000000000000004).
  - Solução: Para valores monetários, o ideal é usar int (representando centavos) ou a biblioteca decimal. Se for manter double, esteja ciente que o total pode exibir dízimas estranhas na UI.
* Acoplamento com o TransactionType.income
  - A lógica de cálculo assume que se não for income, é para subtrair.
  - Problema: Se amanhã você adicionar um tipo TransactionType.adjustment ou TransactionType.unknown (como discutimos no Enum anterior), o cálculo pode ficar errado porque ele subtrairá qualquer coisa que não seja explicitamente receita.
  - Melhoria: Use o switch ou valide todos os tipos
* Falta de um Objeto de Parâmetros
  - O método call() não recebe nada.
  - Ponto de atenção: Embora hoje você queira "todas" as transações, casos de uso geralmente seguem o padrão call(Params params). Mesmo que use NoParams, isso facilita se futuramente você precisar filtrar por data, categoria ou ID de usuário sem quebrar o contrato da chamada.
  - Revisão posterior: `NoParams` foi removido porque ainda não havia filtros reais; quando filtros existirem, o contrato deve ganhar um objeto de parâmetros concreto.
* Responsabilidade do Total: Use Case ou Entidade?
  - Este é um ponto de debate arquitetural:
  - Análise: O cálculo feito (fold) é uma Regra de Negócio. Se você precisar desse total em outro lugar (ex: em um Dashboard), terá que duplicar a lógica do fold.
  - Sugestão: Se o "Total Líquido" é algo fundamental para o conceito de uma "Lista de Transações", você poderia ter uma entidade chamada TransactionReport ou Statement que já possui esse cálculo internamente.

**Prompt 3**: Agora siga para o grupo 3, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md

**Prompt 3**: Agora siga para o grupo 4, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md

**Prompt 3**: Agora siga para o grupo 5, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md

**Prompt 3**: Agora siga para o grupo 6, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md

---

### Código Modernizado

**Localização:** [`transaction_refactor/`](../transaction_refactor/)

**Arquitetura:** Clean Architecture + MVVM + `ValueNotifier` + `get_it`

**Cobertura de testes:** 75 testes unitários — 0 falhas

> Plano de correção em grupos: [grupos_correcao.md](./grupos_correcao.md)
> Histórico de prompts: [prompt_log.md](./prompt_log.md)

---

## Parágrafo de Decisões

A IA gerou corretamente a estrutura geral da Clean Architecture com as camadas `core/`, `features/` e `shared/`, o estado selado via `ValueNotifier`, a hierarquia de `AppFailure` e a separação entre `TransactionDto`, `TransactionEntity` e `TransactionRepository`. O scaffolding inicial foi funcional e fiel ao prompt.

Foram necessárias três rodadas de correção. Na primeira, o método `listFromJson` estava no DTO — a IA centralizou a iteração no lugar errado; a responsabilidade de iterar sobre a lista da API pertence ao `DataSource`, que recebe o payload bruto e chama `TransactionDto.fromJson` por item. Na segunda, o enum `TransactionType` importava `package:flutter/material.dart` diretamente no domínio, acoplando uma camada que deve ser Dart puro a um framework de UI; ícones, cores e labels foram movidos para uma `extension` de apresentação (`TransactionTypePresenter`) e um `ThemeExtension` (`TransactionColors`). Na terceira, o `UseCase` usava `double` para somar valores monetários e o fallback do switch era `expense` para qualquer tipo desconhecido — ambos bugs silenciosos e graves; o campo foi tipado como `int` (centavos) em toda a cadeia, e o switch tornou-se exaustivo com `unknown` explícito, eliminando qualquer subtração indevida. Além disso, o `dispose()` do `ViewModel` foi removido da página, pois quem não instancia não deve descartar — a instância é gerenciada pelo `get_it`. O raciocínio em todas as correções foi o mesmo: a IA tende a compactar responsabilidades quando o prompt não impõe fronteiras rígidas de camada; o papel do desenvolvedor é reconhecer onde a coesão foi violada e mover cada responsabilidade para sua camada correta, validando com testes unitários isolados que confirmem que o domínio não tem dependências de UI e que a lógica de negócio pode ser exercitada sem widget tree.
