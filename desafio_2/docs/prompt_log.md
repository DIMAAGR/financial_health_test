# Histórico de Prompts — Desafio 2

> Registro de todos os prompts utilizados e questionamentos feitos durante a geração e revisão do código modernizado.

---

## Prompt 1 — Análise dos Problemas

**Prompt enviado:**

> Observe o código abaixo: [código legado colado]
>
> é necessária que seja feita uma refatoração de forma urgente nesse código, para isso geraremos um arquivo dentro de desafio_2/questoes/ com o nome questão_2.md
>
> o arquivo conterá uma lista TODO de correções para serem feitas com base nos problemas identificados [...] faça uma lista dividida por grupos para que ao invés de atacar cada erro individualmente se possa ser atacado em conjunto, para isso é necessário que eles façam sentido entre si.

**Resultado:** Lista de 25 problemas agrupados em 6 grupos com causa raiz e dependências entre grupos documentadas.

---

## Prompt 2 — Implementação (Grupos 1–6)

**Prompt enviado:**

> agora, peço que ataque os grupos e escreva todo o código, vamos utilizar o padrão do flutter clean arch + mvvm, e para esse teste, utilizaremos o ValueNotifier como estado. Qualquer mock será um mock simples. Crie o projeto e comece a codar código dentro de lib.
>
> lib será core/ feature/ shared/
>
> core/app/app.dart conterá o mainApp
>
> get_it simples para injeção de dependências caso haja necessidade

**Resultado:** Projeto Flutter criado com Clean Architecture + MVVM + ValueNotifier + get_it.

**Questionamentos feitos após revisão do output:**

- `listFromJson` estava no DTO — a responsabilidade de iterar sobre a lista da API pertence ao DataSource, não ao DTO. O DTO deve mapear um único objeto.
- `TransactionDto` lançava `ParseException` customizada — alguns preferem que o DTO lance erros genéricos do Dart e o DataSource transforme em Failure. Com `FormatException` nativa o acoplamento é menor.

**Correções aplicadas:** `listFromJson` movido para `MockTransactionRemoteDataSource`; `ParseException` substituída por `FormatException` nativa.

---

## Prompt 3 — Revisão Grupo 2

**Questionamentos feitos após revisão:**

Dentro de `TransactionType` foi encontrado acoplamento indevido com Flutter:

- Importava `package:flutter/material.dart` dentro de um enum de domínio — o domínio não deve saber o que é `IconData` ou `Color`.
- `fromRaw` usava `_ => TransactionType.expense` como fallback silencioso — qualquer valor desconhecido virava despesa.
- `label` retornava string hardcoded em PT-BR dentro do domínio — quebraria em app com i18n.
- Cores estavam diretamente no enum em vez de em `ThemeExtension`.
- O enum estava fazendo: definição de tipos (domínio) + parse de API (infra) + estilo visual (apresentação) + tradução (i18n).

No `UseCase`:

- Valores monetários usavam `double` — causa erros de precisão decimal (`0.1 + 0.2 = 0.30000000000000004`).
- Switch assumia que "qualquer coisa que não é `income` é subtração" — adicionando `unknown` o cálculo ficaria errado.
- `call()` sem parâmetros — padrão `call(Params params)` é preferível para extensibilidade futura.
- Total calculado no `UseCase` — debate: se é regra de negócio fundamental, pode ir em uma entidade `TransactionReport`.

**Correções aplicadas:**
- `TransactionType` virou enum puro Dart sem nenhum import Flutter
- `icon` e `label` movidos para `TransactionTypePresenter` (extension de apresentação)
- Cores movidas para `TransactionColors extends ThemeExtension`
- `_parseType` movido para `TransactionDto` (camada de dados)
- `unknown` adicionado como fallback explícito
- `amount: double → int` (centavos) em toda a cadeia
- `NoParams` criado seguindo o padrão `call(Params)`
- `TransactionReport` criado como entidade com getter `total` (switch exaustivo)

---

## Prompts dos Grupos 3–6

> "Agora siga para o grupo 3, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md"

> "Agora siga para o grupo 4, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md"

> "Agora siga para o grupo 5, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md"

> "Agora siga para o grupo 6, lembre-se de marcar os pontos já resolvidos no arquivo questao_2.md"

Cada grupo foi revisado e corrigido de forma iterativa. Os itens concluídos foram marcados `[x]` no checklist de correção.

---

## Questionamentos Sobre o Resultado Final

> "o que é widget e o que é só a tela para mostrar o widget aqui? os dois estão integrados um ao outro? Hoje eu poderia usar o mesmo widget em outra telas sem me preocupar com nada de reescrita por exemplo de viewmodel? o componente é de fato reutilizável? Ele está separado na camada de design system da aplicação?"

**Resposta resumida:** `TransactionPage` orquestra (observa ViewModel, despacha estados). `TransactionListItem` só renderiza (recebe `TransactionItemViewData`, zero conhecimento de ViewModel). São desacoplados — o widget é reutilizável em qualquer tela que forneça um `TransactionItemViewData`. A única dependência visual é `TransactionColors` via `ThemeExtension` do tema global. O widget está em `features/transactions/presentation/widgets/` (escopo de feature), não em `shared/` — o próximo passo natural seria movê-lo para `shared/presentation/widgets/` ou um pacote de design system se for usado em múltiplas features.

---

## Correções Pós-Revisão Final

> "Corrija apenas os problemas reais: ownership do dispose, consistência de tipo no total, overflow na lista."

**Correções aplicadas:**
- `dispose()` removido da `TransactionPage` — quem não instancia não deve descartar; instância gerenciada pelo `get_it`
- `addPostFrameCallback` removido do `initState` — `loadTransactions()` não depende de `BuildContext`, chamada direta é correta
- `maxLines: 1` + `overflow: TextOverflow.ellipsis` adicionados em `description` e `typeLabel` no `TransactionListItem`
