# Status de Refatoracoes e Divida Tecnica

Atualizado em: 2026-04-20
Branch base: `feature/details`

Este arquivo acompanha a lista de melhorias identificadas durante a revisao
arquitetural do app. A intencao e separar o que ja foi corrigido nesta leva do
que deve virar novas branches pequenas e revisaveis.

## Legenda

- **Feito**: corrigido no codigo ou confirmado como resolvido.
- **Parcial**: houve melhora, mas ainda falta uma etapa clara.
- **Pendente**: deve virar trabalho futuro.
- **Adiado**: valido, mas nao deve competir com a estabilizacao da entrega.

## Corrigido nesta leva

- As features de detalhe (`incomes`, `expenses`, `transactions`) deixaram de
  consumir `/dashboard/overview`.
- O fake backend passou a expor bordas por contexto:
  `/incomes/overview`, `/expenses/overview`, `/transactions/overview` e
  `/transactions`.
- `DashboardOverviewData` deixou de carregar a lista de transacoes usada por
  telas de detalhe e, depois, tambem deixou de expor campos intermediarios
  calculados que nao eram consumidos pela presentation.
- Parsing de transacao foi movido para um model compartilhado neutro.
- Calculo de breakdown por categoria foi centralizado em um servico
  compartilhado.
- Chaves de storage perderam o nome `dashboard` quando representam estado
  financeiro compartilhado.
- O MCP passou a expor guardrails operacionais em TOON via `get_rules`.
- `.dart_tool` nao esta mais versionado.

## Status item a item

| ID | Status | Tema | Situacao atual | Proxima acao |
|---:|---|---|---|---|
| 1 | Pendente | Freezed em states/objetos | Existem `copyWith` manuais e estados ainda escritos a mao. | Aplicar depois que os modelos estabilizarem, para evitar churn antes da avaliacao. |
| 2 | Feito | Remover dependencia de detalhes com dashboard | Details usam endpoints/contratos proprios ou compartilhados neutros. | Manter teste de fronteira para evitar regressao. |
| 3 | Feito | Contratos proprios de repository | `IncomesRepository`, `ExpensesRepository` e `TransactionsRepository` existem separados. | Preservar contratos por feature. |
| 4 | Feito | Datasource proprio ou borda neutra | Datasources de detalhe usam endpoints proprios no fake backend. | Se o fake crescer, separar store/rotas por contexto. |
| 5 | Feito | `DashboardTransactionData` fora da dashboard | Conceito neutro de transacao esta em `shared/domain` e parser em `shared/data`. | Manter nomes compartilhados sem prefixo de feature. |
| 6 | Feito | Failure generica | Codigo usa `AppFailure` sealed em core e o teste antigo de dashboard foi movido para `test/core/failures`. | Continuar a revisao de mensagens no item 23. |
| 7 | Feito | Categorias em shared/domain | `IncomeCategory` e `ExpenseCategory` estao em `shared/domain/enum`. | Manter labels/copy fora dos enums de dominio. |
| 8 | Feito | Reduzir papel do aggregate do dashboard | `DashboardOverviewData` nao e mais fonte de transacoes das details nem expoe inputs crus ja convertidos em objetos de tela. | Evitar recolocar dados de outras telas no overview. |
| 9 | Pendente | Dinheiro sem erro de arredondamento | Valores monetarios ainda usam `double`. | Criar `Money` ou padronizar centavos em `int`. |
| 10 | Pendente | Remover `double` de dinheiro no dominio | Entidades e repositorios ainda expõem valores monetarios como `double`. | Migrar dominio primeiro, depois data/presentation. |
| 11 | Pendente | Revisar inputs de comando | Inputs de add ainda parecem entidade de dominio. | Separar command/input de regra central. |
| 12 | Pendente | Inputs fora do core de dominio | Inputs seguem em `domain/entities`. | Mover para camada de aplicacao/value objects quando houver tempo. |
| 13 | Feito | Aplicar linter | `analysis_options.yaml` esta mais restritivo. | Evitar novas ondas grandes de lint sem necessidade. |
| 14 | Parcial | Lints graduais | Linter foi aplicado, mas a base ja passou por uma leva grande. | Daqui para frente, adicionar regra por valor tecnico claro. |
| 15 | Parcial | Priorizar lints de problema real | Ha regras de robustez, mas tambem regras esteticas. | Manter foco em regras que pegam bug/acoplamento. |
| 16 | Parcial | Duplicacao entre incomes e expenses | Breakdown e parsing foram centralizados; views/states ainda sao parecidos. | Refatorar so se a duplicacao continuar crescendo. |
| 17 | Parcial | Cubits/views/states/adapters duplicados | Pontos principais foram identificados, mas nem tudo foi abstraido. | Criar checklist antes de extrair novos componentes. |
| 18 | Parcial | Centralizar compartilhado real | `TransactionModel` e `CategoryBreakdownService` foram extraidos. | Nao mover UI/state para shared sem semantica forte. |
| 19 | Parcial | Revisar `FakeHttpService` | Endpoints foram separados, mas a classe ainda concentra muitas responsabilidades. | Dividir store, seed, rotas e serializacao em outra branch. |
| 20 | Parcial | Separar storage/seed/mutacao do fake backend | Houve melhora de fronteira, nao de tamanho interno. | Extrair um fake store com testes proprios. |
| 21 | Pendente | Evitar catch generico demais | Repositories ainda precisam revisao fina de tratamento de erro. | Separar erro esperado de erro de programacao. |
| 22 | Parcial | Falhas tecnicas vs dominio | `AppFailure` e generica, mas mensagens e tipos ainda podem melhorar. | Criar failures mais semanticas sem acoplar UI. |
| 23 | Pendente | Remover mensagens de presentation do dominio/failure | `AppFailure.message` ainda carrega textos exibiveis. | Mapear failures para copy na presentation. |
| 24 | Parcial | Padronizar Clock/data de referencia | Existe `Clock`, mas nem todos os fluxos usam. | Injetar `Clock`/`referenceDate` nos pontos temporais. |
| 25 | Pendente | Evitar `DateTime.now()` espalhado | Ainda aparece em presentation e fake backend. | Substituir por `Clock` ou argumento explicito. |
| 26 | Pendente | Helpers de UI com regra demais | Ainda precisa revisao especifica dos helpers/mappers de presentation. | Mover regra de negocio para domain/application. |
| 27 | Pendente | Melhorar README arquitetural | README ficou para a fase final. | Reescrever depois das correcoes principais. |
| 28 | Pendente | Reduzir log detalhado de IA | Ainda precisa curadoria narrativa. | Manter exemplos fortes e remover ruido. |
| 29 | Pendente | Documentar IA com foco em decisao/validacao | Sera tratado junto do README final. | Escrever relato curto: aceito, rejeitado, corrigido, validado. |
| 30 | Feito | Nao crescer bonus antes do app | O bonus recebeu apenas guardrails MCP, sem desviar a arquitetura principal. | So evoluir MCP depois de estabilizar app e README. |
| 31 | Pendente | Cobrir melhor UI principal | Ainda falta reforco de widget tests da tela principal. | Adicionar testes de loading/success/error e interacao principal. |
| 32 | Parcial | Investigar testes frageis | Suite passou, mas nao houve auditoria completa de flakiness. | Rodar testes repetidos antes da entrega final. |
| 33 | Feito | Limpar narrativa antes de grandes refatoracoes | Este arquivo passa a registrar direcao e pendencias. | Usar como base antes do README final. |
| 34 | Feito | Hotfixes pequenos e claros | A leva atual ficou focada em fronteira entre features, fake backend e guardrails. | Manter proximos commits pequenos. |
| 35 | Feito | Corrigir primeiro boundary entre features | Boundary das details foi corrigido antes dos refinamentos. | Proximas branches podem atacar fake backend, dinheiro e tempo. |

## Proximas branches recomendadas

1. **Fake backend menor**: separar store, seed, mutacao e serializacao do
   `FakeHttpService`.
2. **Dinheiro e inputs**: introduzir `Money`/centavos e revisar commands de add.
3. **Tempo deterministico**: substituir `DateTime.now()` por `Clock` ou
   `referenceDate` nos pontos testaveis.
4. **Failures e copy**: manter failures sem texto de UI e mapear mensagens na
   presentation.
5. **README final**: reescrever narrativa humana depois que o codigo parar de
   se mover.
