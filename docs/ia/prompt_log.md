# Prompt Log

Registro objetivo de interações com IA que influenciaram decisões do projeto.

## 2026-04-14 | Arquitetura inicial
- Objetivo: definir organização base da aplicação.
- Prompt: comparação entre `feature-first` e organização por camadas globais para um app Flutter pequeno/médio.
- Saída da IA (resumo): sugeriu `feature-first` com separação `data/domain/presentation`.
- O que foi aproveitado: proposta de estrutura por feature e critérios de separação de responsabilidades.
- O que foi descartado: camadas globais únicas para todo o projeto.
- Validação humana aplicada: revisão de clareza, esforço de manutenção e alinhamento com tempo do teste.
- Trade-offs identificados: leve duplicação estrutural vs menor acoplamento entre contextos.
- Decisão final: `feature-first + data/domain/presentation`.

## 2026-04-14 | Gerenciamento de estado
- Objetivo: selecionar state manager para estados explícitos de UI.
- Prompt: comparação entre `ValueNotifier`, `Riverpod`, `MobX` e `Cubit` considerando prazo curto.
- Saída da IA (resumo): destacou `Cubit` como equilíbrio entre estrutura e simplicidade.
- O que foi aproveitado: modelagem por estados mutuamente exclusivos.
- O que foi descartado: abordagem por múltiplas flags (`isLoading`, `error`, `data`).
- Validação humana aplicada: análise de legibilidade da UI e facilidade de teste.
- Trade-offs identificados: mais verbosidade vs menor ambiguidade de estado.
- Decisão final: `Cubit (flutter_bloc)`.

## 2026-04-15 | Refino de tema e widgets
- Objetivo: reduzir hardcode de cor e melhorar reutilização de widgets.
- Prompt: revisão dos widgets para identificar extrações e pontos de acoplamento.
- Saída da IA (resumo): recomendou mover estilos do score para `ThemeExtension`, revisar docs dos widgets e dar efeito real ao `MetricCardSize`.
- O que foi aproveitado: criação de extensão de tema para score, melhoria da documentação e ajustes de layout por tamanho.
- O que foi descartado: mudanças de escopo que exigiriam redesenho completo da tela.
- Validação humana aplicada: `flutter analyze`, revisão visual e consistência com design existente.
- Trade-offs identificados: mais estrutura de tema vs maior consistência e escalabilidade.
- Decisão final: manter tema semântico por extensão e refinar widgets incrementais.

## 2026-04-16 | Widget de análise de fluxo (chart)
- Objetivo: criar widget `Entradas x Despesas` com estado contextual e suporte light/dark.
- Prompt: especificação visual detalhada baseada em Figma + regras de variação por status (positivo, estável, atenção, crítico).
- Saída da IA (resumo): propôs estrutura reutilizável com modelo de dados, enum de status, tema dedicado e mensagem dinâmica.
- O que foi aproveitado: separação entre dados do chart, regra de status e camada visual; extração de cores para `ThemeExtension`.
- O que foi descartado: manter código cru de `figma.to.code` com hardcodes e baixa manutenção.
- Validação humana aplicada: revisão de estrutura, alinhamento com padrões do projeto e verificação estática com `flutter analyze`.
- Trade-offs identificados: maior estrutura inicial vs melhor manutenção, clareza e evolução futura.
- Decisão final: implementar widget reutilizável com tema semântico e regras de estado explícitas.

## 2026-04-16 | Ajuste de ordenação visual das barras do chart
- Objetivo: garantir leitura correta quando despesa ultrapassa entrada.
- Prompt: regra de negócio visual para inverter posição dos segmentos por ponto (topo = maior valor).
- Saída da IA (resumo): propôs tornar a ordenação dinâmica por coluna mantendo cores semânticas.
- O que foi aproveitado: cálculo por ponto e renderização dinâmica de topo/base com bordas corretas.
- O que foi descartado: layout fixo sempre com entrada em cima e despesa embaixo.
- Validação humana aplicada: revisão de comportamento visual e análise estática.
- Trade-offs identificados: pequena complexidade extra no widget vs melhor fidelidade semântica.
- Decisão final: segmento superior sempre representa o maior valor do ponto.

## 2026-04-16 | Widget de meta mensal
- Objetivo: criar card de meta do mês com estados positivo/negativo e ícone contextual.
- Prompt: referência visual light/dark com variação de cor e mensagem para meta atingida vs meta em risco.
- Saída da IA (resumo): propôs componente reutilizável com entidade de domínio, enum de status e tema dedicado.
- O que foi aproveitado: extração de tema para `ThemeExtension`, escolha de ícone por status e mensagem por regra de negócio.
- O que foi descartado: reprodução literal do `figma.to.code` com hardcodes e baixa testabilidade.
- Validação humana aplicada: ajuste de layout, revisão de textos e análise estática (`flutter analyze`).
- Trade-offs identificados: mais arquivos de suporte vs melhor manutenção e previsibilidade de evolução.
- Decisão final: `MonthlyGoalCard` com `MonthlyGoalData` tipado e estilo semântico por tema.

## 2026-04-16 | Ajuste de regra e layout do card de meta mensal
- Objetivo: corrigir ícone/spacing e tornar status proporcional ao avanço do mês.
- Prompt: regras de negócio para considerar `% atingido` e relação tempo x meta.
- Saída da IA (resumo): sugeriu combinar threshold mínimo com expectativa por dia do mês.
- O que foi aproveitado: cálculo de `expectedPercentByDate`, status com tolerância e header com ícone + título alinhados.
- O que foi descartado: regra fixa simples sem considerar data.
- Validação humana aplicada: revisão visual e `flutter analyze`.
- Trade-offs identificados: regra um pouco mais elaborada vs feedback muito mais realista para o usuário.
- Decisão final: status baseado em `%` + ritmo do mês, com ícone sem fundo e espaçamento explícito.

## 2026-04-16 | Documentação de DDD pragmático
- Objetivo: deixar explícito para outros devs como DDD está sendo aplicado no projeto.
- Prompt: adicionar explicação curta em `dartdoc` e seção em `.md` com vantagens/desvantagens.
- Saída da IA (resumo): sugeriu ancorar a explicação nas entidades de domínio e arquitetura.
- O que foi aproveitado: documentação em entidades (`MonthlyGoalData`, `FlowAnalysisData`, `FinancialHealthScoreData`) e seção específica em `architecture.md`.
- O que foi descartado: abordagem extensa/cerimonial de DDD fora do escopo do teste.
- Validação humana aplicada: revisão de clareza e alinhamento com arquitetura atual.
- Trade-offs identificados: documentação mais completa vs maior esforço de manutenção textual.
- Decisão final: manter explicação objetiva, centrada em aplicação prática no código atual.

## 2026-04-16 | Refino de domínio com Policy + testes
- Objetivo: reduzir acoplamento de regra volátil na entidade e iniciar disciplina de TDD no domínio.
- Prompt: revisão de DDD pragmático para separar regra de classificação em policy e criar testes úteis.
- Saída da IA (resumo): recomendou `MonthlyGoalStatusPolicy`, validações de invariantes e suíte de testes de domínio.
- O que foi aproveitado: extração de policy, validações de entrada e testes para policy/entidades.
- O que foi descartado: introdução de objetos e camadas adicionais sem ganho direto no escopo atual.
- Validação humana aplicada: `flutter test` + `flutter analyze`.
- Trade-offs identificados: mais arquivos e estrutura vs legibilidade, manutenibilidade e evolução segura das regras.
- Decisão final: adotar DDD pragmático com policy onde regra tende a mudar e TDD para lógica de domínio.

## 2026-04-16 | Mapper de texto + ajustes pragmáticos de domínio
- Objetivo: remover texto de apresentação do domínio e reforçar consistência das regras.
- Prompt: aplicar melhorias com maior peso prático (policy injetável, data congelada, thresholds nomeados, cache e lista imutável).
- Saída da IA (resumo): recomendou separar textos via mapper e manter domínio focado em dados/decisão.
- O que foi aproveitado: `MonthlyGoalTextMapper`, validações da `MonthlyGoalStatusPolicy`, `FlowAnalysisData` com `late final` e `List.unmodifiable`.
- O que foi descartado: mudanças cerimoniais sem ganho direto para o escopo.
- Validação humana aplicada: suíte de testes atualizada + `flutter analyze`.
- Trade-offs identificados: mais componentes pequenos vs menor acoplamento e melhor caminho para i18n.
- Decisão final: domínio sem string de UI e apresentação responsável por textos finais.

## 2026-04-16 | Seção de evidência no README para avaliação
- Objetivo: tornar explícito no README um caso real de erro da IA, checagem, correção e regra preventiva.
- Prompt: reforçar documentação orientada aos critérios do teste técnico (arquitetura, uso crítico de IA e clareza).
- Saída da IA (resumo): propôs seção objetiva com evidências e links para regras/log.
- O que foi aproveitado: seção “Uso Crítico de IA (Caso Real)” no README da app e nota resumida no README raiz.
- O que foi descartado: narrativa extensa com detalhes redundantes já cobertos em docs.
- Validação humana aplicada: revisão de clareza e rastreabilidade para avaliador.
- Trade-offs identificados: README um pouco mais extenso vs melhor auditabilidade da decisão técnica.
- Decisão final: manter seção curta e factual com links diretos para `rules.md` e `prompt_log.md`.

## 2026-04-16 | Score financeiro com domínio + mapper de apresentação
- Objetivo: remover textos do domínio do score financeiro e calcular dados derivados por regra explícita.
- Prompt: aplicar separação estrita de camadas no `FinancialHealthScore`, com cálculo no domínio e texto na apresentação.
- Saída da IA (resumo): sugeriu criar `FinancialHealthScorePolicy`, manter entidade só com dados numéricos/status e mapear textos via mapper.
- O que foi aproveitado: `FinancialHealthScorePolicy`, `FinancialHealthScoreData.fromMetrics`, `FinancialHealthScoreTextMapper` e atualização do widget para consumir mapper.
- O que foi descartado: manter `label/title/headline/description` dentro da entidade de domínio.
- Validação humana aplicada: ajuste de cenários de teste para a fórmula adotada, `flutter test` e `flutter analyze`.
- Trade-offs identificados: mais arquivos e mapeamento explícito vs maior pureza arquitetural, testabilidade e caminho para i18n.
- Decisão final: domínio focado em cálculo/classificação; apresentação responsável por copy final.

## 2026-04-16 | README orientado ao critério de uso crítico de IA
- Objetivo: deixar explícito no README que o projeto demonstra filtro e validação crítica da IA (não apenas uso).
- Prompt: reforçar narrativa de avaliação com ciclo "hipótese -> checagem -> rejeição/adaptação -> decisão -> evidência".
- Saída da IA (resumo): propôs estruturar a seção com ciclo e casos concretos.
- O que foi aproveitado: ciclo de uso crítico em `financial_health_dashboard/README.md` e reforço no README raiz sobre critério de peso alto.
- O que foi descartado: texto genérico sobre IA sem evidência prática.
- Validação humana aplicada: revisão de clareza e aderência aos critérios do teste.
- Trade-offs identificados: README ligeiramente mais detalhado vs melhor leitura para avaliador técnico.
- Decisão final: manter seção objetiva, baseada em evidências reais do repositório.

## 2026-04-16 | Ajuste da fórmula do score para comportamento real
- Objetivo: eliminar percepção de score "travado" ao variar apenas liquidez.
- Prompt: revisar cálculo para refletir comprometimento da renda, liquidez atual e tendência de liquidez.
- Saída da IA (resumo): sugeriu score composto por três dimensões com pesos explícitos e normalização previsível.
- O que foi aproveitado: `FinancialHealthScorePolicy` com score composto (`commitment`, `liquidity level`, `liquidity trend`) e teste que garante variação do score ao mudar só liquidez.
- O que foi descartado: abordagem anterior com bônus único e saturação agressiva que mascarava mudança de liquidez em alguns cenários.
- Validação humana aplicada: atualização de cenários de teste + execução de `flutter test` e `flutter analyze`.
- Trade-offs identificados: fórmula um pouco mais extensa vs comportamento mais auditável e coerente para usuário final.
- Decisão final: manter modelo composto com pesos documentados e thresholds de status explícitos.

## 2026-04-16 | Estrutura de backend fake para dashboard (data/repository/use case)
- Objetivo: aproximar o app de cenário real onde cálculos/payload vêm consolidados do backend.
- Prompt: criar entidade agregada do dashboard, fake HTTP service estilo Dio, remote data source, repository e use cases com latência simulada.
- Saída da IA (resumo): propôs `HttpService` abstrato, `FakeHttpService` com endpoints (`/dashboard/overview`, `/dashboard/income`, `/dashboard/expense`) e fluxo completo até a View.
- O que foi aproveitado: agregado `DashboardOverviewData`, camada `data` completa (model/datasource/repository), use cases (`get/addIncome/addExpense`), DI por feature e `DashboardView` com carregamento assíncrono + estado de erro.
- O que foi descartado: continuar com dados hardcoded diretamente na View.
- Validação humana aplicada: novos testes de datasource/use case + execução de `flutter test` e `flutter analyze`.
- Trade-offs identificados: mais estrutura inicial vs maior aderência arquitetural, testabilidade e troca simples de fake por Dio no futuro.
- Decisão final: manter fake backend com contrato HTTP estável e preparar caminho para bottom sheet de lançamento de receita/despesa.

## 2026-04-16 | Desacoplamento temporário da UI (volta para mocks)
- Objetivo: manter a tela principal mockada nesta etapa, sem plugar data/use case na apresentação.
- Prompt: não integrar ainda, sem ViewModel e sem acoplamento de carregamento remoto na `DashboardView`.
- Saída da IA (resumo): sugeriu reverter apenas wiring de UI/DI mantendo a infraestrutura pronta em paralelo.
- O que foi aproveitado: `DashboardView` voltou para dados mockados locais e a injeção deixou de registrar feature/network fake.
- O que foi descartado: carregamento assíncrono real no widget da dashboard nesta fase.
- Validação humana aplicada: `flutter test` e `flutter analyze`.
- Trade-offs identificados: menor aderência ao fluxo real agora vs maior controle de escopo para evolução incremental.
- Decisão final: manter base de dados preparada, porém desacoplada da UI até próxima etapa.

## 2026-04-16 | Cobertura completa de testes para fake HTTP + remote datasource
- Objetivo: aumentar cobertura para todos os casos relevantes de `FakeHttpService` e `DashboardRemoteDataSource`.
- Prompt: criar testes de sucesso, erro, validação de payload, mutação de estado e parse resiliente.
- Saída da IA (resumo): sugeriu dividir cobertura em 3 blocos (`fake_http_service`, `dashboard_remote_data_source`, `dashboard_overview_model`).
- O que foi aproveitado: testes para rotas suportadas/não suportadas, `amount` inválido, atualização de income/expense/balance/goal/flow/liquidez, validação de endpoints/payload no datasource e fallback de parsing no model.
- O que foi descartado: testes de latência temporal exata (flaky por natureza de tempo de execução).
- Validação humana aplicada: `flutter test` + `flutter analyze`.
- Trade-offs identificados: suíte de testes maior e mais detalhada vs maior confiança para evolução da camada de dados.
- Decisão final: manter cobertura ampla nessa camada para reduzir regressões antes de plugar backend real.

## 2026-04-16 | Fake service com dados aleatórios + regra de aderência ao desafio
- Objetivo: evitar payload estático no mock local e reforçar guardrails de escopo/qualidade do teste técnico.
- Prompt: tornar o `FakeHttpService` aleatório e adicionar no `rules.md` critérios explícitos de aderência ao desafio Conta Azul.
- Saída da IA (resumo): sugeriu gerar estado inicial por `Random` com consistência financeira (income/expense/balance/liquidez/flow/meta) e incluir seção de checklist no arquivo de regras.
- O que foi aproveitado: `FakeHttpService` com seed aleatório plausível e `rules.md` com seção de aderência (escopo, estados de UI, separação de camadas, mock realista, testes AAA e documentação de IA).
- O que foi descartado: randomização caótica sem relação entre campos financeiros.
- Validação humana aplicada: `flutter test` + `flutter analyze`.
- Trade-offs identificados: resultados variáveis entre execuções vs maior realismo do mock e melhor preparação para backend real.
- Decisão final: manter randomização coerente no fake service e usar regras de aderência para reduzir desvio de escopo.

## 2026-04-16 | Menu de ações no `more_vert` do header
- Objetivo: adicionar caixa de opções no botão `more_vert` com ações de layout/receita/despesa.
- Prompt: criar menu visual light/dark baseado no layout fornecido, sem hardcode de cores.
- Saída da IA (resumo): propôs `PopupMenuButton` com shape customizado, 3 itens e callbacks opcionais.
- O que foi aproveitado: menu com `Editar Layout`, `Adicionar Receita`, `Adicionar Despesa`; tokens semânticos novos no `AppSemanticColors`; suporte light/dark em `theme.dart`.
- O que foi descartado: manter `InkWell` simples sem menu e sem estrutura de ações.
- Validação humana aplicada: `flutter analyze` + `flutter test`.
- Trade-offs identificados: leve aumento de complexidade no header vs maior aderência ao design e melhor escalabilidade para ações futuras.
- Decisão final: manter menu temático no header e API de callbacks explícita no `HeaderSection`.

## 2026-04-16 | Bottom sheet de adicionar receita + fluxo por Cubit
- Objetivo: iniciar fluxo de ação por `Cubit` sem `setState`, abrindo bottom sheet via efeito de estado.
- Prompt: ao clicar em `Adicionar Receita`, ViewModel deve emitir efeito e UI responder abrindo o sheet; manter lógica de domínio fora da UI.
- Saída da IA (resumo): sugeriu `DashboardCubit` com `DashboardEffect`, `BlocListener` na view e `AddIncomeFormCubit` para estado de formulário.
- O que foi aproveitado: abertura de sheet por efeito (`showAddIncomeSheet`), formatação BRL com input formatter (`0,00 -> 0,01 -> 0,10...`), categorias e validação de envio via cubit.
- O que foi descartado: controlar abertura/estado do formulário com `setState` na view.
- Validação humana aplicada: testes unitários novos (`DashboardCubit`, `AddIncomeFormCubit`, formatter BRL) + suíte completa + `flutter analyze`.
- Trade-offs identificados: mais estrutura inicial (cubit/theme/widget) vs melhor separação de responsabilidades e evolução segura para integrar com datasource depois.
- Decisão final: manter evento de UI via cubit e bottom sheet desacoplado da lógica de atualização de negócio.

## 2026-04-16 | Correção de processo: TDD e matriz de casos no fluxo de ViewModel
- Objetivo: corrigir desvio de processo (implementação antes de testes) e cobrir explicitamente cenários de acerto/falha.
- Prompt: listar todos os casos possíveis, criar testes de cada caso e adicionar widget test do campo monetário (`0,00 -> 0,01 -> 0,10 -> 1,00...`).
- Saída da IA (resumo): propôs matriz de cenários para `DashboardCubit`, `AddIncomeFormCubit/State` e cobertura de máscara BRL em nível de formatter + widget.
- O que foi aproveitado: expansão de testes de falha/sucesso (efeitos, clearEffect, amount inválido, estado inicial/copyWith, parse monetário, descrição com espaços) e widget test do `TextField` com sequência de entrada.
- O que foi descartado: manter cobertura mínima sem evidência explícita de casos negativos.
- Validação humana aplicada: `flutter test` (suíte completa passando) + `flutter analyze` sem issues.
- Trade-offs identificados: mais tempo inicial em teste/documentação vs menor risco de regressão e melhor aderência aos critérios do teste técnico.
- Decisão final: reforçar regra de TDD em mudanças de regra/comportamento e registrar correções de processo no log.

## 2026-04-16 | Bottom sheet de adicionar despesa (espelho da receita)
- Objetivo: criar fluxo completo de `Adicionar Despesa` com Cubit, mantendo o mesmo padrão arquitetural de `Adicionar Receita`.
- Prompt: implementar o bottom sheet de despesa com categorias `Alimentação`, `Transporte`, `Compras` e ação `Salvar Despesa`, lendo `rules.md` antes.
- Saída da IA (resumo): propôs novo `AddExpenseFormCubit/State`, novo widget `add_expense_bottom_sheet.dart`, ligação no `DashboardView` via `DashboardEffect` e método `addExpense` no `DashboardCubit`.
- O que foi aproveitado: estrutura em camadas sem `setState`, lista horizontal de categorias, máscara monetária reaproveitada e testes unitários adicionais para sucesso/falha.
- O que foi descartado: duplicar lógica de atualização de estado na UI.
- Validação humana aplicada: `flutter analyze` sem issues e `flutter test` com suíte completa passando.
- Trade-offs identificados: duplicação controlada entre sheets de receita/despesa vs entrega rápida com baixo risco de regressão.
- Decisão final: manter implementação espelhada por clareza e avaliar extração de base comum se houver mais formulários semelhantes.

## 2026-04-16 | Fake DB de movimentações + use cases com dartz/fold
- Objetivo: evoluir o mock local para um "db" em memória com movimentações (receita/despesa) e deslocar regra para camada de domínio via casos de uso com `Either`.
- Prompt: criar lista inicial fictícia (10 movimentos, 5 entradas e 5 saídas), persistir novas adições no fake service, atualizar overview e usar `dartz` + `.fold` nos use cases/cubit, sem lógica de negócio na view model.
- Saída da IA (resumo): propôs entidade de movimentação, payload `transactions` no overview, fake state mutável em memória e contrato de repositório/use case baseado em `Either<DashboardFailure, DashboardOverviewData>`.
- O que foi aproveitado: `DashboardTransactionData`, `DashboardFailure`, randomização inicial de movimentos, append de movimentos em `addIncome/addExpense`, expansão do datasource/repository/usecases para `title/category`, e consumo com `fold` no `DashboardCubit`.
- O que foi descartado: persistência real (SQLite/Hive) nesta etapa por escopo/tempo do teste técnico.
- Validação humana aplicada: TDD iniciado por testes de use case/datasource/fake service; validação final com `flutter analyze` e `flutter test` passando.
- Trade-offs identificados: mais estrutura e contrato tipado agora vs maior clareza de camadas, testabilidade e troca futura para backend/DB real.
- Decisão final: manter fake DB em memória e arquitetura pronta para evolução, sem introduzir banco real nesta fase.

## 2026-04-16 | Wrapper de storage + schema versionado (TDD estrito)
- Objetivo: adicionar base de persistência chave/valor com contrato desacoplado e schema versionado para preparar evolução do fake DB.
- Prompt: criar `KeyValueWrapper` (estilo `SharedPreferences`) e `StorageSchema` com chaves versionadas, garantindo ordem TDD (testes primeiro).
- Saída da IA (resumo): propôs testes de contrato para wrapper e testes de consistência de schema antes da implementação.
- O que foi aproveitado: criação prévia dos testes (`key_value_wrapper_test.dart` e `storage_schema_test.dart`), implementação de `SharedPreferencesWrapper`, `StorageSchema` e inclusão de `shared_preferences` no projeto.
- O que foi descartado: plugar persistência real de dashboard neste passo para evitar aumento de escopo desnecessário.
- Validação humana aplicada: execução inicial com falha esperada (arquivos/dependência ausentes), seguida de implementação e validação com `flutter test` e `flutter analyze`.
- Trade-offs identificados: adicionar dependência agora vs ganho de isolamento para trocar storage sem impactar regra de domínio.
- Decisão final: manter wrapper + schema como fundação de persistência e integrar no fluxo de dados em etapa separada.

## 2026-04-16 | Correção arquitetural: wrapper agnóstico + DI da presentation
- Objetivo: remover acoplamento indevido com `shared_preferences` e alinhar a arquitetura para DI completa até a camada de presentation.
- Prompt: manter apenas interface de storage para troca futura de DB, registrar cubit na feature (`presentation`) e evitar construção manual na view.
- Saída da IA (resumo): substituiu implementação concreta por `InMemoryKeyValueWrapper`, ajustou `FakeHttpService` para depender do wrapper/schema e integrou `DashboardCubit` na `DashboardFeatureDependencies`.
- O que foi aproveitado: `KeyValueWrapper` agnóstico, `StorageSchema`, persistência fake baseada em interface, `getIt<DashboardCubit>()` na view e listener extraído em função dedicada.
- O que foi descartado: dependência de `shared_preferences` nesta etapa.
- Validação humana aplicada: `flutter analyze` e `flutter test` (suíte completa) sem regressões.
- Trade-offs identificados: pequena complexidade extra no fake service vs maior consistência arquitetural e facilidade de swap para DB real no futuro.
- Decisão final: manter fake DB atrás de interface e DI coesa em todas as camadas.

## 2026-04-16 | Skeleton, estados explícitos e bloqueio de submit
- Objetivo: modelar corretamente estados globais da dashboard (`initial`, `loading`, `success`, `error`) e evitar loading global ao salvar receita/despesa.
- Prompt: ler `rules.md`, escrever testes primeiro, criar skeleton para loading/initial, failures da feature e travar botão de salvar com loading local no bottom sheet.
- Saída da IA (resumo): propôs testes para estados, failures, skeleton e prevenção de submit duplicado antes de ajustar implementação.
- O que foi aproveitado: `DashboardSkeleton`, enum com quatro estados explícitos, hierarquia de `DashboardFailure`, mapeamento de exceções no repository, `isSubmitting` nos form cubits e widget test garantindo `CircularProgressIndicator` + fechamento após 2 segundos.
- O que foi descartado: usar o loading global da dashboard durante mutações de receita/despesa, pois isso causaria regressão de UX e misturaria estado da tela com estado local do formulário.
- Validação humana aplicada: execução inicial dos testes com falha esperada, implementação guiada por TDD, `flutter analyze` sem issues e `flutter test` completo passando.
- Trade-offs identificados: mais boilerplate de estado/failure vs comportamento mais previsível, testável e coerente com loading/success/error explícitos exigidos pelo desafio.
- Decisão final: manter loading global apenas para carregamento geral da dashboard e loading local/idempotente para submits dos bottom sheets.

## 2026-04-16 | Refatoração dos bottom sheets de transação
- Objetivo: reduzir duplicação entre `Adicionar Receita` e `Adicionar Despesa` sem alterar comportamento visual ou regras dos formulários.
- Prompt: quebrar widgets compartilhados dos bottom sheets em arquivos internos e reutilizá-los para melhorar legibilidade.
- Saída da IA (resumo): extraiu shell do modal, campos, seletor horizontal de categorias e botão primário para componentes compartilhados em `sheets/components`.
- O que foi aproveitado: `TransactionSheetScaffold`, `TransactionAmountField`, `TransactionDescriptionField`, `TransactionCategorySelector` e `TransactionSubmitButton`, mantendo cada bottom sheet apenas com cubit/state, textos e categorias específicas.
- O que foi descartado: criar uma abstração genérica única para todo o formulário, porque isso misturaria tipos de resultado/cubit e deixaria a leitura menos direta.
- Validação humana aplicada: `dart format`, `flutter analyze`, testes focados dos bottom sheets/campo monetário e `flutter test` completo.
- Trade-offs identificados: mais arquivos pequenos vs redução de duplicação de quase 600 linhas e manutenção mais segura das futuras mudanças visuais.
- Decisão final: manter componentes compartilhados internos à feature e preservar os arquivos de receita/despesa como pontos explícitos de composição.

## 2026-04-16 | Correção da abstração unificada de transações
- Objetivo: manter a unificação de receita/despesa sem carregar estado duplicado nem reutilizar cubit de formulário entre bottom sheets.
- Prompt: corrigir `AddTransactionCubit/State` para receber `SheetType`, criar cubit por sheet via DI, remover `AddTransactionCubit` do construtor da `DashboardView` e preservar `DashboardCubit` vindo da rota.
- Saída da IA (resumo): propôs `SheetType` em model de apresentação, `AddTransactionState` com uma única `category`, `AddTransactionCubit.submit()`, factory parametrizada no GetIt e mapper para converter resultado da sheet em input de domínio.
- O que foi aproveitado: state com categoria única, remoção de `bool isIncome`, criação de `AddTransactionCubit` por abertura da sheet, DI via `registerFactoryParam`, `DashboardView` sem cubit de formulário e `AddTransactionInputMapper`.
- O que foi descartado: manter dois campos (`incomeCategory`/`expenseCategory`) no state e reutilizar uma instância externa do cubit de formulário, por risco de estado contaminado e ownership ambíguo.
- Validação humana aplicada: testes ajustados antes da implementação, falha esperada observada, `flutter analyze` sem issues e `flutter test` completo passando.
- Trade-offs identificados: DI dentro do fluxo de sheet aumenta acoplamento com composição, mas garante uso consistente do GetIt e instância nova por modal sem expor esse cubit na dashboard.
- Decisão final: manter um único fluxo de transação, porém com `SheetType` como contexto do cubit e ciclo de vida local ao bottom sheet.

## 2026-04-16 | Polimento final de snapshot e documentação
- Objetivo: eliminar recomputação desnecessária no `DashboardState`, reduzir duplicação textual nas categorias e documentar decisões defensáveis para o teste técnico.
- Prompt: revisar refinamentos restantes após unificar transações, priorizando `DashboardState` como snapshot consolidado, labels centralizadas, mapper mais idiomático e README claro sobre DI/loading fake.
- Saída da IA (resumo): sugeriu armazenar `financialHealthScore` e `flowAnalysis` vindos do `DashboardOverviewData`, trocar labels hardcoded por `TransactionCategory.label`, transformar mapper em `final class`, extrair helpers no handler de efeitos e documentar trade-offs.
- O que foi aproveitado: `DashboardState.fromOverview` agora preserva objetos consolidados, opções da sheet usam extensão de categoria, `AddTransactionInputMapper` virou `final class`, handlers da `DashboardView` foram separados e o README ganhou seção sobre formulário unificado, cubit efêmero, mapper e delay simulado.
- O que foi descartado: remover o delay de 2 segundos agora, porque ele cumpre papel demonstrativo de loading local no escopo do teste.
- Validação humana aplicada: teste novo para snapshot consolidado falhou antes da implementação, depois passou; `flutter analyze` sem issues e `flutter test` completo passando.
- Trade-offs identificados: o estado inicial ainda usa placeholders neutros, mas a renderização inicial fica em skeleton e o snapshot real passa a vir exclusivamente do overview.
- Decisão final: tratar `DashboardOverviewData` como fonte consolidada da tela e deixar a apresentação apenas adaptar/mostrar esse snapshot.

## 2026-04-16 | Categorias tipadas no domínio e mapper na fronteira
- Objetivo: fortalecer a camada de domínio sem desfazer a UI unificada de transações.
- Prompt: avaliar trade-offs de separar `IncomeCategory`/`ExpenseCategory`, mover `TransactionCategory` para presentation, usar `code` em data e validar inputs nos use cases.
- Saída da IA (resumo): recomendou manter a sheet unificada, mas deixar o domínio aceitar apenas categorias específicas de receita/despesa e usar mapper como fronteira explícita.
- O que foi aproveitado: `IncomeCategory` e `ExpenseCategory` no domínio, `TransactionCategory` em presentation, `AddTransactionInputMapper` convertendo entre camadas, repository tipado e serialização por `category.code`.
- O que foi descartado: tipar `DashboardTransactionData.category` agora, por ser uma mudança mais invasiva no payload de leitura e não essencial para corrigir o fluxo de escrita.
- Validação humana aplicada: testes foram escritos/ajustados antes da implementação; falha esperada ocorreu por enums inexistentes; depois `flutter test` passou com 102 testes e `flutter analyze` sem issues.
- Trade-offs identificados: mais tipos e mapeamento explícito vs domínio mais seguro, sem aceitar despesa com categoria de receita em tempo de compilação.
- Decisão final: preservar a experiência unificada da UI e endurecer o contrato do domínio/data com categorias específicas e códigos estáveis.

## 2026-04-16 | Clock no core e data de referência explícita
- Objetivo: remover dependência implícita de `DateTime.now()` da regra de meta mensal e da conversão de model para entidade.
- Prompt: avaliar uso de `Clock`, com entidade recebendo `referenceDate` em vez de receber o serviço diretamente.
- Saída da IA (resumo): sugeriu `Clock` em `core/services/clock`, `SystemClock` na DI, `MonthlyGoalData` com `referenceDate` obrigatório e repository como ponto de leitura do tempo.
- O que foi aproveitado: entidade determinística com `referenceDate`, `DashboardOverviewModel.toEntity(referenceDate:)` obrigatório, `DashboardRepositoryImpl` recebendo `Clock` e normalizando a data para ano/mês/dia.
- O que foi descartado: injetar `Clock` diretamente na entidade, porque isso levaria infraestrutura para o domínio.
- Validação humana aplicada: testes escritos antes da implementação com falha esperada; depois `flutter test` passou com 106 testes e `flutter analyze` sem issues.
- Trade-offs identificados: mais uma abstração transversal vs regra temporal explícita, testável e sem comportamento fantasma na virada do dia.
- Decisão final: manter tempo como dependência de infraestrutura e passar ao domínio apenas o valor de negócio (`referenceDate`).

## 2026-04-17 | Transações separadas no fake storage
- Objetivo: preparar a futura tela de detalhes sem reescrever a dashboard atual.
- Prompt: avaliar se `dashboardTransactionsKey` vale a pena considerando que o app terá tela de detalhe.
- Saída da IA (resumo): recomendou abordagem pragmática: manter overview estável para a dashboard, persistir transactions em chave própria e expor endpoint fake para detalhes.
- O que foi aproveitado: `FakeHttpService` passou a gravar `dashboardTransactionsKey`, atualizar essa lista em `addIncome/addExpense` e responder `GET /dashboard/transactions`.
- O que foi descartado: reescrever todo o fake DB para `profile + transactions` agora, porque seria mais limpo conceitualmente, mas maior em escopo e risco.
- Validação humana aplicada: testes foram escritos antes da implementação; falha esperada ocorreu por chave não usada e endpoint ausente; depois `flutter test` passou com 108 testes e `flutter analyze` sem issues.
- Trade-offs identificados: manter `dashboardOverviewKey` como snapshot/cache por enquanto vs preparar o detalhe com transações separadas sem desestabilizar a tela principal.
- Decisão final: adotar separação intermediária, onde transações têm persistência própria e podem alimentar a próxima tela, enquanto o overview segue compatível com a dashboard.

## 2026-04-17 | Code review e remoção de loops abertos

- Objetivo: realizar revisão completa do código para identificar pontos que comprometiam a credibilidade do entregável.
- Prompt: leitura integral do código pedindo pontuação por área e identificação de "loops abertos" (código que promete funcionalidade mas não entrega).
- Saída da IA (resumo): identificou 6 problemas concretos: `CommitmentStatus` declarado e nunca consumido, `App` como StatefulWidget sem estado, `Future.delayed(2s)` artificial no submit, error state sem retry, pastas/rotas vazias e DI de feature dentro de `_registerCore`.
- O que foi aproveitado: remoção de `CommitmentStatus`, conversão de `App` para StatelessWidget, remoção do delay artificial, criação de `canRetry` no error state, limpeza de pastas/rotas vazias e extração de `_registerFeatures()` na DI.
- O que foi descartado: refatorações estéticas que não corrigiam problemas reais.
- Validação humana aplicada: `flutter test` (117 → 118 testes passando) e `flutter analyze` sem issues após cada mudança.
- Trade-offs identificados: mais mudanças pontuais vs entregável mais coerente e sem ruído para avaliação.
- Decisão final: corrigir todos os loops abertos antes de prosseguir com novas features.

## 2026-04-17 | Connectivity check + latência + skeleton com shimmer

- Objetivo: verificar conectividade real antes de requests, aumentar tempo de loading para skeleton ser perceptível e adicionar animação de shimmer ao skeleton.
- Prompt: usar `connectivity_plus` para checar rede no datasource, subir latência do fake service e tornar o skeleton animado.
- Saída da IA (resumo): propôs `NetworkInfo` abstrato em core, injeção no datasource com `_ensureConnected()` antes de cada request, e skeleton reescrito como `StatefulWidget` com `AnimationController` + `_ShimmerContext` (InheritedWidget).
- O que foi aproveitado: `NetworkInfo`/`NetworkInfoImpl` com `connectivity_plus`, check de rede que lança `SocketException` (que o repository já mapeia para `DashboardNetworkFailure` com retry), latência de 800ms → 1500ms e shimmer animado com gradiente varrendo em loop de 1.2s.
- O que foi descartado: usar package de shimmer externo (desnecessário para o padrão visual simples do skeleton).
- Validação humana aplicada: teste de `SocketException` adicionado ao datasource + 118 testes passando + `flutter analyze` sem issues.
- Trade-offs identificados: dependência extra (`connectivity_plus`) vs demonstração real de tratamento de offline no fluxo de erro.
- Decisão final: manter check de rede no datasource (system boundary) e skeleton com animação nativa.

## 2026-04-17 | Bottom sheet permanece aberto durante update da dashboard

- Objetivo: corrigir UX onde o sheet fechava antes de confirmar se a transação foi salva com sucesso.
- Prompt: o sheet deveria manter loading no botão enquanto a dashboard processa, sem exibir skeleton.
- Saída da IA (resumo): propôs callback `onSubmit` no sheet que retorna `Future<bool>`, `addIncome`/`addExpense` no cubit retornando `Future<bool>` sem chamar `_setLoading()`, e `submit()` mantendo `isSubmitting: true` até confirmação.
- O que foi aproveitado: `showTransactionBottomSheet` com `onSubmit` callback; sheet só faz `pop` no sucesso e chama `resetSubmitting()` na falha; dashboard não mostra skeleton durante add de transação.
- O que foi descartado: fechar sheet imediatamente e deixar o usuário sem feedback visual durante a operação.
- Validação humana aplicada: 4 testes ajustados/criados + 118 testes passando + `flutter analyze` sem issues.
- Trade-offs identificados: callback no sheet aumenta acoplamento com a view, mas garante que o feedback de loading é real (não simulado).
- Decisão final: sheet com ownership do loading local e dashboard sem regressão visual durante mutações.

## 2026-04-17 | Reorganização: score resolver movido para mappers

- Objetivo: eliminar pasta `styles/` com arquivo único que fazia papel de mapper (resolução de tema por status).
- Prompt: mover `FinancialHealthCardStyleResolver` para `mappers/` onde vivem os demais resolvers de apresentação.
- Saída da IA (resumo): sugeriu move direto com atualização de import e remoção da pasta vazia.
- O que foi aproveitado: arquivo movido, import atualizado no widget, pasta `styles/` removida.
- O que foi descartado: criar uma nova abstração ou renomear a classe (o nome já expressa bem o papel).
- Validação humana aplicada: `flutter analyze` sem issues e `flutter test` passando.
- Trade-offs identificados: nenhum trade-off real — apenas organização mais coerente.
- Decisão final: manter resolvers/mappers de apresentação em um único diretório por feature.

## 2026-04-17 | MCP Server — automação de contexto e scaffolding

- Objetivo: criar um servidor MCP em Dart que conecta assistentes de IA ao contexto do projeto, padroniza logging e automatiza scaffolding de features e testes.
- Prompt: implementar MCP server com ferramentas para leitura de docs (rules, learnings, prompt_log, architecture), logging de interações, geração de feature structure e geração de teste a partir de Cubit.
- Saída da IA (resumo): servidor Dart usando `mcp_dart` SDK com 8 ferramentas MCP (get_project_context, get_rules, get_learnings, search_prompt_log, log_interaction, add_learning, generate_feature_structure, generate_cubit_test), 28 testes unitários, README completo com estimativa de produtividade.
- O que foi aproveitado: todas as 8 ferramentas implementadas; funções helper expostas como API pública para testabilidade direta; `.vscode/mcp.json` configurado; README com documentação, exemplos e análise de ganho.
- O que foi descartado: testes via protocolo MCP (complexidade desnecessária — testar as funções diretamente é mais robusto e rápido).
- Validação humana aplicada: `dart analyze` sem issues, `dart test` 28 testes passando, `flutter test` 118 testes do app inalterados.
- Trade-offs identificados: funções helper públicas (não-privadas) para testabilidade vs. encapsulamento estrito; leitura de docs a cada chamada vs. cache em memória (docs são pequenos, cache adiciona complexidade de invalidação).
- Decisão final: MCP server como pacote Dart puro em `tools/mcp_server/`, independente do app Flutter, configurado como stdio server para VS Code.

### 1. Criação das 3 telas de detalhe com widgets compartilhados (2026-04-17)

**Prompt:** Criar telas de detalhe para Movimentações, Receitas e Despesas a partir de designs SwiftUI gerados no Google Stitch

**Decisão:** Criados 5 widgets compartilhados (DetailAppBar, MonthSummaryCard, CategoryBreakdownSection, ContextualFab, TransactionListSection) com ThemeExtension individual para cada um. 3 views separadas em features distintas, roteadas via go_router.

**Trade-offs:** Widgets separados por feature vs. widget genérico com type param — optou-se por views separadas para flexibilidade (ex: transactions não tem CategoryBreakdown nem FAB). ThemeExtension por componente adiciona verbosidade mas garante light/dark isolado e lerp correto.

**Resultado:** 5 widgets, 5 theme extensions, 3 views, 3 SVG icons, rotas configuradas. dart analyze sem erros. Dados hardcoded como placeholder — state management pendente.
### 2. Variante de TransactionList para Movimentações (valores coloridos) (2026-04-17)

**Prompt:** Variante de lista para Movimentações: sem paymentMethod, valores coloridos por tipo (despesa=vermelho, receita=verde)

**Decisão:** TransactionListSection adaptado com paymentMethod opcional e isExpense flag. 2 novos tokens (itemAmountExpense, itemAmountIncome) no TransactionListTheme. Na view de movimentações, despesas em vermelho e receitas em verde — sem paymentMethod. Nas views de receitas/despesas, cor neutra com paymentMethod visível.

**Trade-offs:** Widget único com flags opcionais vs. dois widgets separados — optou-se por widget único com isExpense?/paymentMethod? opcionais para evitar duplicação. Risco de complexidade condicional aceito porque são apenas 2 variações simples.

**Resultado:** Widget reutilizado sem duplicação. dart analyze limpo. Ambas variantes (movimentações e receitas/despesas) compartilham o mesmo componente.
### 3. Business logic layer for detail screens (Movimentações, Receitas, Despesas) (2025-07-15)

**Prompt:** Adicionar lógica de negócio às 3 telas de detalhe: entidades, use cases, cubits, DI init, popular dados reais do FakeHttpService. Seguir TDD conforme as rules.

**Decisão:** Cada feature (transactions, incomes, expenses) reutiliza o DashboardRepository já registrado como singleton. Cada uma recebe: (1) entity própria no domain, (2) use case que depende de DashboardRepository e filtra/transforma os dados, (3) Cubit + State com padrão exclusivo de status (initial/loading/success/error), (4) FeatureDependencies para DI. Adicionado DateTime? date ao DashboardTransactionData para suportar agrupamento por data nas telas de detalhe. Nenhum novo datasource, model ou repository impl foi criado — máximo reuso da data layer existente.

**Trade-offs:** Reusar DashboardRepository cria dependência cross-feature no nível de interface (domain), mas evita duplicação de datasource/model que chamariam os mesmos endpoints. Para o escopo do desafio, isso é pragmático e não viola o contrato de Clean Architecture (features dependem de abstrações, não de implementações). O campo date foi adicionado como optional (DateTime?) para não quebrar os 118 testes existentes.

**Resultado:** 29 novos testes criados (13 domain + 16 cubit), todos passando. 147 testes totais, 0 issues no flutter analyze. Arquivos criados: 3 entities, 3 use cases, 3 cubits, 3 states, 3 inits, 1 shared entity (CategoryBreakdownData), 6 arquivos de teste. Views atualizadas de hardcoded para BlocBuilder com estados loading/error/success.