# IA no Design da Interface

## Contexto

A UI foi definida combinando referência visual real + iteração assistida por IA, com curadoria manual antes da implementação no Flutter.

## Como foi aplicado

- levantamento de referências de dashboards financeiros
- iteração de layout com descrição textual de intenção
- refinamento manual de hierarquia e legibilidade
- implementação final no código com foco em componentes reutilizáveis

## Decisão de design adotada

Estrutura principal em 3 níveis:

- visão geral (score)
- métricas principais (receitas, despesas, saldo)
- contexto (relação entre valores)

## Trade-off

- Decisão: usar IA para acelerar exploração visual
- Trade-off: necessidade de curadoria manual contínua
- Ganho: iteração mais rápida com menos decisão arbitrária

## Referência de processo IA

Para regras, log e learnings completos:

- [../ia/README.md](../ia/README.md)
