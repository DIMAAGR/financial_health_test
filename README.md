# Financial Health Test

Repositório principal do teste técnico assíncrono de Flutter.

Este repositório está organizado para separar código da aplicação e documentação de decisão técnica, com foco em clareza para revisão.

## Estrutura

```txt
financial_health_test/
  financial_health_dashboard/   # app Flutter
  docs/                         # documentação técnica e de processo
  README.md
```

## Onde encontrar cada informação

- Código da aplicação: [financial_health_dashboard/README.md](./financial_health_dashboard/README.md)
- Requisitos e decisões de produto: [docs/requirements/requirements.md](./docs/requirements/requirements.md)
- Arquitetura e trade-offs técnicos: [docs/architecture/architecture.md](./docs/architecture/architecture.md)
- Processo de IA (regras, log e learnings): [docs/ia/README.md](./docs/ia/README.md)

## Uso de IA

A IA foi usada como ferramenta assistiva para acelerar exploração, boilerplate e revisão de escrita.

As decisões finais de arquitetura, escopo e validação de qualidade foram feitas manualmente.

No contexto deste teste, "uso crítico de IA" foi tratado como critério de peso alto: toda sugestão relevante passou por filtro técnico, validação manual, decisão com trade-off e registro de evidência.

### Exemplo de validação crítica aplicada

Um caso concreto de correção foi a remoção de textos de exibição do `domain` para `presentation` (via mapper), para manter separação estrita de camadas.

- Detalhe do caso: [financial_health_dashboard/README.md](./financial_health_dashboard/README.md)
- Regras criadas: [docs/ia/rules.md](./docs/ia/rules.md)
- Registro da correção: [docs/ia/prompt_log.md](./docs/ia/prompt_log.md)

## Objetivo de documentação

A documentação foi separada por tema para evitar um README único muito extenso e reduzir repetição.
Cada arquivo deve ter responsabilidade única e apontar links para os demais quando necessário.
