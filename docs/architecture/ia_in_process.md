# IA no Processo


O uso de IA foi parte ativa durante todo o desenvolvimento deste projeto, não apenas como gerador de código, mas como ferramenta de apoio para tomada de decisão, validação de hipóteses e aceleração de tarefas repetitivas. A abordagem adotada foi utilizar IA de forma assistiva, mantendo validação crítica sobre todas as sugestões.

---

## Como a IA foi utilizada

#### 1. Exploração de arquitetura

A IA foi utilizada para simular cenários de decisão arquitetural antes da implementação.

Foram feitos prompts considerando:

- tamanho da equipe
- prazo
- número de funcionalidades
- necessidade de escalabilidade
- continuidade do projeto após a V1

Exemplo de prompt:

```text
imagine que estamos iniciando o desenvolvimento de um novo aplicativo, nesse MVP temos 5 telas que se conectam a uma API REST.

A linguagem e framework adotados para desenvolvimento foram o Dart e Flutter, e agora precisamos decidir a arquitetura do projeto.

Algumas perguntas foram feitas:
- Quantos desenvolvedores tem nesse projeto?
Resp: 2 desenvolvedores front-end
- Quanto tempo os desenvolvedores tem até concluir o projeto?
Resp: 3 meses
- Quantas funcionalidades há dentro do projeto:
Resp: 5 funcionalidades
- Qual é o tipo de projeto?
Resp: Overview (Dashboard) de saúde financeira
- Haverá no projeto conexão com API externa?
Resp: Sim
- Haverá persistencia de dados (Offline) + Offline First?
Resp: Sim
- o MVP funcionará como prova de conceito (POC) e uma vez aprovado poderá ser refatorado para uma aplicação mais robusta
Resp: Não
- Há alguma possíbilidade de, no futuro, haver o reuso das funcionalidades em outro app?
Resp: Não
```

A partir disso, foram analisadas alternativas como:
 - feature-first vs camadas globais
 - MVVM vs abordagens mais simples
 - diferentes estratégias de organização de código

**Resultado:** ajudou a antecipar trade-offs e evitar decisões baseadas apenas em preferência pessoal.

---

### 2. Escolha do gerenciamento de estado
A IA foi utilizada para comparar diferentes soluções:
 - ValueNotifier
 - Riverpod
 - MobX
 - Cubit

Durante os testes, foi observado que:
 - com contexto reduzido, a IA sugeria soluções mais simples
 - com contexto completo (incluindo roadmap), a sugestão mudava para soluções mais estruturadas

**Insight importante:** a IA responde ao contexto fornecido, não define a solução ideal sozinha.

**Resultado:** reforçou a decisão de usar Cubit como equilíbrio entre estrutura e complexidade.

---

### 3. Geração de boilerplate

A IA foi utilizada para acelerar:
 - estrutura inicial de pastas
 - criação de classes base (states, models)
 - organização inicial de arquivos

**Validação aplicada:**
 - revisão manual de nomes
 - ajuste de responsabilidades
 - adaptação ao padrão arquitetural escolhido

---

### 4. Apoio na modelagem de estados
A IA auxiliou na geração inicial de estruturas de estado.

Em alguns casos, sugeriu abordagens baseadas em múltiplas flags (isLoading, data, error), que foram descartadas manualmente.

**Correção aplicada:**
 - substituição por estados selados (mutuamente exclusivos)
 - garantia de contrato explícito entre ViewModel e UI

---

### 5. Escrita e organização da documentação
**A IA foi utilizada para:**
 - estruturar o README
 - organizar seções de arquitetura
 - revisar clareza de explicações
 - sugerir melhorias de escrita

**Validação aplicada:**
 - adaptação do texto para manter consistência com meu estilo
 - remoção de trechos genéricos
 - ajuste para refletir decisões reais do projeto

---

O que NÃO foi delegado à IA
 - decisões finais de arquitetura
 - definição de trade-offs
 - estrutura final do projeto
 - validação de consistência entre camadas

Todas essas decisões foram feitas manualmente, utilizando a IA apenas como ferramenta de apoio.

---

### Limitações observadas

Durante o uso, algumas limitações ficaram claras:
 - a IA pode sugerir soluções diferentes dependendo do contexto fornecido
 - nem sempre as sugestões consideram custo de manutenção real
 - algumas respostas tendem a priorizar “boas práticas” genéricas sem avaliar o escopo específico

Por isso, todas as sugestões foram tratadas como hipóteses, não como decisões finais.

---

### Conclusão

A IA foi utilizada como um acelerador e ferramenta de exploração, não como substituto do raciocínio técnico.

O uso crítico da IA permitiu:
 - reduzir tempo em tarefas repetitivas
 - comparar alternativas rapidamente
 - validar decisões com mais segurança

Mantendo sempre a responsabilidade final das decisões no desenvolvimento humano.