# Requisitos

## Objetivo

Implementar um Painel de Saúde Financeira para apresentar uma visão consolidada de receitas, despesas e saldo, com uma métrica adicional interpretável.

## Requisitos funcionais

1. A aplicação deve possuir duas telas principais:
- dashboard com resumo financeiro (receitas, despesas, saldo e métrica adicional)
- tela de detalhe acessada a partir de um item do dashboard

2. O dashboard deve apresentar hierarquia de informação:
- visão geral com indicador principal
- métricas financeiras em cards
- seção de contexto com relação entre receitas e despesas

3. A métrica adicional deve ser um score de saúde financeira que:
- represente o comprometimento da renda
- tenha classificação textual (`saudável`, `atenção`, `crítico`)
- inclua descrição contextual

4. A UI deve tratar explicitamente:
- carregamento
- sucesso
- erro

5. Fonte de dados:
- API REST pública ou mock local
- mantendo comportamento de loading e tratamento de estado

## Requisitos não funcionais

1. Separação de responsabilidades entre `data`, `domain` e `presentation`.
2. Arquitetura intencional e justificada para o escopo.
3. Gerenciamento de estado apropriado ao contexto com justificativa.
4. Testes automatizados mínimos:
- 2 testes unitários
- 1 widget test
- padrão Arrange-Act-Assert

5. Execução sem configuração adicional além dos comandos descritos no README.
6. Documentação de decisões, trade-offs e uso de IA.

## Decisões de produto aplicadas

### Score de saúde financeira como indicador principal

Em vez de métrica genérica, foi adotado score de saúde financeira para transformar dados brutos em leitura rápida de estado.

### Estrutura hierárquica da tela

Organização em três níveis:

- visão geral (score)
- métricas principais (receitas, despesas, saldo)
- contexto (relação entre valores)

### Controle de escopo

Não implementado nesta etapa:

- personalização completa do dashboard
- análises financeiras mais complexas
- gráficos avançados

## Referências

- Arquitetura e trade-offs técnicos: [../architecture/architecture.md](../architecture/architecture.md)
- Processo de IA: [../ia/README.md](../ia/README.md)
