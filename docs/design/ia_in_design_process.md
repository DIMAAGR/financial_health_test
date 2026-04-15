### IA no design da interface

A interface do aplicativo não foi criada de forma isolada. O processo combinou referências visuais reais com uso de IA para estruturar, validar e iterar rapidamente sobre a UI.

---

### Uso de referências visuais

Foram utilizadas imagens de interfaces reais como base de inspiração, principalmente dashboards financeiros e aplicativos de gestão.

O objetivo não foi copiar layouts, mas identificar padrões de mercado, como:

- uso de cards para métricas
- hierarquia de informação (resumo → indicadores → contexto)
- organização de dados financeiros de forma escaneável
- redução de carga cognitiva na leitura

Essas referências serviram como ponto de partida para definição da estrutura da tela.

---

### Uso do Google Stitch

O Google Stitch foi utilizado como ferramenta de apoio para transformar ideias e referências visuais em variações de layout.

A partir de descrições textuais da tela (estrutura do dashboard, componentes e hierarquia), o Stitch foi usado para:

- gerar diferentes versões da mesma tela
- explorar variações de layout rapidamente
- validar organização dos elementos antes da implementação
- visualizar estados da interface (loading, erro, edição)

Isso permitiu reduzir o tempo de iteração e tomar decisões visuais com mais segurança.

---

### Uso de IA para definição da UI

A IA foi utilizada para ajudar na estruturação da interface a partir de descrições funcionais.

Exemplo de abordagem:

- descrever a tela em termos de intenção (ex: "dashboard com score principal e métricas secundárias")
- pedir variações de layout com base nessa descrição
- ajustar a estrutura até chegar em uma organização coerente

Além disso, a IA ajudou a definir:

- divisão em seções (visão geral, métricas, contexto)
- comportamento de estados (loading, erro, vazio)
- organização de componentes reutilizáveis

---

### Iteração e validação

O processo foi iterativo:

1. referência visual  
2. descrição textual da interface  
3. geração de variações com IA / Stitch  
4. ajuste manual da estrutura  
5. implementação no Flutter  

A IA não foi usada para gerar a UI final diretamente, mas como ferramenta de apoio para explorar possibilidades e validar decisões antes da implementação.

---

### Decisão de design

A estrutura final do dashboard foi baseada em três níveis:

- visão geral (score financeiro)
- indicadores principais (receitas, despesas, saldo)
- contexto (relação entre valores)

Essa organização foi escolhida para priorizar entendimento rápido da situação financeira antes da análise detalhada.

---

### Trade-offs

**Decisão:** usar IA + ferramentas visuais para acelerar design  
**Trade-off:** necessidade de curadoria manual das sugestões  
**Evita:** decisões visuais arbitrárias e tentativa de design totalmente do zero sem referência  

---

### Conclusão

O uso combinado de referências reais, Google Stitch e IA permitiu estruturar uma interface mais consistente em menos tempo, mantendo controle manual sobre as decisões finais.

A IA foi utilizada como ferramenta de exploração e validação, não como geradora direta da interface final.