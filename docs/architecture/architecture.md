# Arquitetura

A aplicação foi organizada em **feature-first + clean architecture + MVVM**, mantendo separação entre data, domain e presentation dentro de cada feature. Em vez de centralizar camadas em pastas globais, a estrutura foi agrupada por contexto funcional. Essa decisão mantém o código próximo da feature a que pertence, melhora a legibilidade e evita crescimento desordenado.

## Estrutura das Pastas
```text
src/
  core/
    di/
    routes/
    services/
    utils/

  shared/
    presentation/
      design_system/

  features/
    dashboard/
      data/
      domain/
      presentation/
        view/
        view_model/
        widgets/

    details/
      data/
      domain/
      presentation/
        view/
        view_model/
        widgets/
```

---

## Camadas e responsabilidades

A aplicação foi organizada com separação entre data, domain e presentation, adotando MVVM na camada de apresentação.
 - data -> acesso e transformação de dados
 - domain -> regras de negócio e contratos
 - presentation -> UI e orquestração de estado

Essa separação foi escolhida para manter clareza de responsabilidades, facilitar testes e evitar acoplamento entre UI e lógica de negócio.

A decisão foi tomada com apoio de IA para explorar alternativas e trade-offs, mas a definição final foi baseada na necessidade de equilibrar organização e velocidade de desenvolvimento.

---

## State management

O gerenciamento de estado foi implementado com Cubit (flutter_bloc), integrado ao padrão MVVM.

O objetivo não foi escolher a solução mais robusta possível, mas a mais adequada ao problema atual.

Alternativas como ValueNotifier, Riverpod e MobX foram consideradas. A análise levou em conta:
 - complexidade do fluxo de estado
 - necessidade de estados explícitos
 - tempo disponível
 - facilidade de manutenção

A decisão final foi pelo uso de Cubit por oferecer um bom equilíbrio entre estrutura e simplicidade.

### Por que Cubit

O requisito do projeto exige tratamento explícito dos estados de loading, sucesso e erro. Com abordagens baseadas em flags, como ValueNotifier, é comum ter estados ambíguos:

```dart
bool isLoading = false;
String? error;
Data? data;
```

Nesse modelo, o compilador não impede combinações inválidas. Com Cubit, os estados são modelados de forma explícita:

```dart
sealed class DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final DashboardSummary data;
  DashboardSuccess(this.data);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
```

Isso garante estados mutuamente exclusivos e um contrato claro entre ViewModel e UI.

---

### Relação com a arquitetura

Cada Cubit representa o view_model da feature.

Ele é responsável por:
 - coordenar casos de uso
 - controlar o fluxo da tela
 - emitir estados para a UI

Essa abordagem mantém coerência com a estrutura feature-first + MVVM.

---

## Fonte de dados e tempo de vida do estado

Os dados são mantidos em memória durante a execução.

Entradas e despesas atualizam o dashboard em tempo real, mas não persistem após reiniciar o app.

A arquitetura foi mantida preparada para suportar persistência futura, caso necessário.

---

## Injeção de dependências e navegação

A aplicação utiliza:
 - get_it para injeção de dependências
 - go_router para navegação

### Injeção de dependência

O get_it foi escolhido por ser simples, direto e amplamente utilizado.

Ele permite desacoplar a criação das dependências da sua utilização, facilitando testes e organização do código.

#### Registro de dependências por feature

Para evitar um arquivo único de injeção crescendo de forma desordenada, cada feature possui sua própria classe de registro, seguindo a separação entre `data`, `domain` e `presentation`.

Essa abordagem melhora legibilidade, facilita manutenção e mantém o bootstrap das dependências mais próximo do contexto funcional ao qual pertencem.

### Navegação

O go_router foi utilizado por oferecer navegação declarativa, com:
 - definição centralizada de rotas
 - melhor organização do fluxo
 - suporte a crescimento da aplicação

---

## Desenvolvimento orientado a testes e domínio

O projeto foi estruturado com foco em testabilidade, priorizando a implementação e validação das regras centrais da feature por meio de testes unitários e de widget.

Na modelagem, foram utilizados princípios de DDD de forma pragmática, principalmente na separação entre domínio, dados e apresentação, na nomeação das entidades e na centralização das regras de negócio no `domain`.

A proposta não foi aplicar DDD de forma completa ou cerimonial, mas usar seus princípios para manter o problema de negócio bem representado no código.

Em alguns pontos, também foi considerada uma abordagem orientada a especificações para regras de negócio mais explícitas, desde que isso trouxesse clareza real ao domínio sem adicionar complexidade desnecessária.

---

## Decisões e trade-offs

### Organização por feature

**Decisão:** usar feature-first
**Trade-off:** leve duplicação estrutural
**Evita:** acoplamento entre contextos e crescimento desorganizado

---

### Separação de camadas usando Clean Architecture

**Decisão:** separar data, domain e presentation
**Trade-off:** maior estrutura inicial
**Evita:** lógica de negócio na UI e baixa testabilidade

---

### MVVM

**Decisão:** separar view e orquestração de estado
**Trade-off:** camada adicional
**Evita:** widgets com múltiplas responsabilidades

---

### Cubit como state management

**Decisão:** usar Cubit
**Trade-off:** mais código que soluções simples
**Evita:** estados inconsistentes e ambíguos

---

### Cubit em vez de Riverpod

**Decisão:** não usar Riverpod neste momento
**Trade-off:** menor capacidade de composição reativa
**Evita:** complexidade adicional sem necessidade no escopo atual

---

### Cubit em vez de ValueNotifier

**Decisão:** não usar ValueNotifier
**Trade-off:** maior verbosidade
**Evita:** dependência de convenções frágeis para controle de estado

---

### Dados em memória

**Decisão:** não persistir dados nesta etapa
**Trade-off:** dados não sobrevivem ao restart
**Evita:** aumento de escopo e complexidade desnecessária

---

### get_it

**Decisão:** usar get_it para DI
**Trade-off:** registro manual
**Evita:** abstrações desnecessárias

---

### go_router

**Decisão:** usar go_router
**Trade-off:** configuração inicial maior
**Evita:** navegação desorganizada

---

### Separação entre core e shared

**Decisão:** manter shared fora de core
**Trade-off:** mais divisão estrutural
**Evita:** tornar core uma pasta genérica sem responsabilidade clara

---

### Controle de complexidade

**Decisão:** evitar over-engineering nesta etapa

**Não foram implementados:**
 - persistência local completa
 - dashboard customizável
 - métricas avançadas
 - gráficos complexos

**Trade-off:** menor cobertura de cenários futuros
**Evita:** comprometer a qualidade da entrega principal