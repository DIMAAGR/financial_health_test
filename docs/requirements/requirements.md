# Requisitos

O objetivo do projeto é implementar um Painel de Saúde Financeira capaz de apresentar ao usuário uma visão consolidada do seu estado financeiro a partir de receitas e despesas.

O desafio propõe a construção de uma feature completa, incluindo interface, gerenciamento de estado, separação de camadas, testes e documentação das decisões técnicas.

Além dos requisitos base do desafio, foram adicionadas algumas decisões de produto com o objetivo de tornar o painel mais interpretável e próximo de um cenário real de uso.

## Requisitos Funcionais

A aplicação deve possuir duas telas principais:
	•	um dashboard com resumo financeiro contendo receitas, despesas, saldo e uma métrica adicional
	•	uma tela de detalhe acessada a partir do dashboard, responsável por exibir os dados que compõem cada métrica

O dashboard deve apresentar os dados de forma estruturada, priorizando hierarquia de informação, com:
	•	uma visão geral contendo um indicador principal
	•	métricas financeiras organizadas em formato de cards
	•	uma seção de contexto com representação visual da relação entre receitas e despesas

Como métrica adicional, o sistema deve calcular um score de saúde financeira baseado na relação entre receitas e despesas do período. Esse score deve:
	•	representar o nível de comprometimento da renda
	•	possuir uma classificação textual (ex: saudável, atenção, crítico)
	•	incluir uma descrição contextual que explique o resultado

A interface deve tratar explicitamente os estados de:
	•	carregamento
	•	sucesso
	•	erro

Os dados podem ser obtidos de uma API REST pública ou de um mock local, desde que o comportamento de carregamento e tratamento de estados seja mantido.

## Requisitos Não Funcionais

A aplicação deve ser estruturada com separação de responsabilidades entre camadas, evitando acoplamento direto entre apresentação, domínio e acesso a dados.

A escolha de arquitetura e organização do projeto deve ser intencional, considerando o equilíbrio entre clareza, escalabilidade e tempo de desenvolvimento.

O sistema deve utilizar uma solução de gerenciamento de estado apropriada ao contexto, com justificativa documentada.

O projeto deve conter testes automatizados, incluindo pelo menos:
	•	dois testes unitários
	•	um teste de widget

seguindo o padrão Arrange-Act-Assert.

A aplicação deve ser executável sem configuração adicional, utilizando apenas comandos padrão do Flutter descritos no README.

A documentação deve registrar decisões técnicas, trade-offs e o uso de IA durante o processo de desenvolvimento.

---

## Decisões & trade-offs

### Score de saúde financeira como indicador principal

O desafio pede uma métrica adicional. Em vez de adicionar uma métrica genérica, foi implementado um score de saúde financeira como indicador principal do dashboard.

A decisão foi tomada para transformar dados brutos em um valor único e fácil de interpretar, permitindo que o usuário entenda rapidamente sua situação financeira sem precisar analisar múltiplos números isolados.

---

### Estrutura hierárquica do dashboard

O dashboard foi organizado em três níveis:
	•	visão geral (score)
	•	métricas principais (receitas, despesas, saldo)
	•	contexto (relação visual entre receitas e despesas)

Essa estrutura reduz a carga cognitiva e permite que o usuário primeiro entenda o estado geral antes de analisar os detalhes.

---

### Controle de escopo

Algumas ideias foram intencionalmente não implementadas para evitar expansão excessiva do escopo:
	•	personalização completa do dashboard (drag and drop)
	•	análises financeiras mais complexas
	•	gráficos avançados

A decisão foi manter o foco em uma feature bem estruturada e coerente dentro do tempo disponível.

---

### Fonte de dados simplificada

A aplicação foi estruturada para suportar tanto mock local quanto API real.

A escolha prioriza simplicidade de implementação, mantendo ao mesmo tempo a flexibilidade necessária para simular um cenário real.

---

### Estados de UI explícitos

Os estados de carregamento, sucesso e erro são tratados explicitamente na interface.

Isso garante previsibilidade na renderização e evita estados ambíguos ou inconsistentes.

---

### Separação das camadas

A aplicação foi organizada com separação entre `data`, `domain` e `presentation`, adotando MVVM na camada de apresentação e organização por feature (`feature-first`).

Essa estrutura foi escolhida para manter clareza de responsabilidades, facilitar a evolução do projeto e evitar acoplamento direto entre UI e lógica de negócio.

Mais detalhes são descritos na documentação de arquitetura.