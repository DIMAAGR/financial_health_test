# Arquitetura

## Objetivo

Garantir separação de responsabilidades e testabilidade sem over-engineering para o escopo do teste.

## Organização adotada

A base segue `feature-first` com separação em `data`, `domain` e `presentation` dentro da feature.

```txt
lib/src/
  core/
  shared/
  features/
    dashboard/
      domain/
      presentation/
```

## Camadas e responsabilidades

- `data`: acesso e transformação de dados
- `domain`: regras de negócio e contratos
- `presentation`: UI e orquestração de estado

## Estado

`Cubit` (`flutter_bloc`) foi escolhido para modelar estados explícitos de UI (`loading`, `success`, `error`) com menor ambiguidade do que abordagens baseadas em flags soltas.

## Dependências estruturais

- `get_it`: injeção de dependências
- `go_router`: navegação declarativa

## Decisões e trade-offs principais

### Feature-first
- Decisão: agrupar por contexto funcional.
- Trade-off: duplicação estrutural leve.
- Ganho: menor acoplamento entre contextos e manutenção mais local.

### Separação `data/domain/presentation`
- Decisão: isolar regras de negócio da UI.
- Trade-off: maior estrutura inicial.
- Ganho: evolução e testabilidade mais previsíveis.

### Cubit
- Decisão: estados mutuamente exclusivos na tela.
- Trade-off: mais código que soluções mínimas.
- Ganho: contrato de estado claro entre ViewModel e UI.

### Dados em memória (nesta etapa)
- Decisão: sem persistência local nesta versão.
- Trade-off: dados não sobrevivem ao restart.
- Ganho: foco em qualidade do fluxo principal dentro do prazo.

## DDD pragmático no projeto

DDD foi aplicado de forma pragmática, sem cerimônia excessiva.

### Como está sendo aplicado

- regras de negócio centrais ficam em entidades de domínio
- widgets não decidem regra financeira; apenas exibem estado já resolvido
- nomenclatura do domínio busca refletir linguagem de negócio (score, fluxo, meta)

Exemplo prático:
- `MonthlyGoalData` classifica status com base em `% atingido` + ritmo do mês
- `FlowAnalysisData` classifica saúde do fluxo por delta de entradas/despesas
- `MonthlyGoalStatusPolicy` isola regra de classificação que pode evoluir com produto

### Vantagens no contexto deste projeto

- menor acoplamento entre UI e regra de negócio
- melhor testabilidade das regras sem depender de widget test
- evolução mais segura quando regra muda (sem reescrever layout)
- maior clareza para onboarding de outros desenvolvedores

### Desvantagens / custos

- aumento de estrutura inicial para uma feature pequena
- risco de abstração excessiva se aplicado sem critério
- necessidade de disciplina para não duplicar regra entre domínio e UI

### Decisão

Manter DDD pragmático: usar domínio para regra real de negócio e evitar
cerimônia onde não houver ganho claro de manutenção.

## Fora de escopo intencional

- persistência offline completa
- dashboard customizável
- análises financeiras avançadas
- gráficos complexos

## Referências

- Requisitos do projeto: [../requirements/requirements.md](../requirements/requirements.md)
- Processo de IA: [../ia/README.md](../ia/README.md)
