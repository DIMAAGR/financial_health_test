# Regras de Uso de IA

Regras operacionais para manter uso de IA consistente, auditável e útil ao projeto.

## Regras obrigatórias

1. Toda decisão relevante deve ser registrada no log quando houver influência direta da IA.
2. Toda sugestão de IA deve passar por validação manual antes de entrar no código.
3. Nenhuma decisão arquitetural é aceita sem análise de trade-off.
4. Quando a IA errar, o erro e a correção devem ser documentados em `learnings.md`.
5. Evitar prompts vagos. Sempre incluir contexto de escopo, prazo e restrições do teste.

## Quando registrar no log

Registrar em `prompt_log.md` quando houver:

- escolha de arquitetura ou state management
- geração de boilerplate com impacto estrutural
- criação/refatoração de widget reutilizável
- mudança de documentação que altera entendimento técnico

## Template de registro mínimo

Use este template ao adicionar uma entrada no log:

```md
## [AAAA-MM-DD] Tema
- Objetivo:
- Prompt:
- Saída da IA (resumo):
- O que foi aproveitado:
- O que foi descartado:
- Validação humana aplicada:
- Trade-offs identificados:
- Decisão final:
```

## Critérios de qualidade da resposta da IA

Uma resposta só é considerada aproveitável quando:

- respeita o escopo e o prazo do teste
- reduz esforço operacional real
- não aumenta acoplamento sem justificativa
- mantém consistência com a arquitetura definida

## Regras padrão para criação de widgets

Quando a solicitação for "criar um widget" (especialmente vindo de Figma/IA), aplicar por padrão:

1. Não copiar o código bruto gerado pelo Figma literalmente; adaptar para um componente reutilizável.
2. Não deixar cor hardcoded no widget; mover para `ThemeExtension` com suporte light/dark.
3. Antes de criar novo `TextStyle`, verificar `app_text_styles.dart`; só adicionar se não existir equivalente.
4. Priorizar manutenção:
- separar dados visuais em modelos/enums quando houver estado (ex.: positivo, estável, atenção, crítico)
- evitar números mágicos sem contexto
- deixar API do widget clara e tipada

5. Preservar fidelidade visual com atenção explícita a:
- espaçamentos e margens
- tamanhos dos elementos
- posição de título/ícone/conteúdo
- comportamento responsivo

6. Quando houver mensagens contextuais por estado:
- centralizar regra de variação no widget/modelo
- manter texto coerente com o estado financeiro exibido
- preferir mapper/presenter na camada de apresentação para textos finais
- evitar string de exibição dentro do domínio (salvo exceções documentadas)

7. Quando houver categorias ou valores enviados para API/storage:
- usar `code` estável no domínio/data
- manter `label`/copy final apenas em presentation
- preferir enums específicas de domínio quando isso impedir estados inválidos em tempo de compilação

8. Sempre validar ao final:
- `dart format`
- `flutter analyze`

## Regra de TDD (quando aplicável)

Para mudanças em regra de domínio:

1. Escrever/ajustar teste antes da implementação sempre que viável.
2. Garantir que cenários positivos e negativos estejam cobertos.
3. Só considerar a mudança pronta após os testes passarem.

## Regras de aderência ao desafio (Conta Azul)

Antes de implementar qualquer mudança, validar impacto nestes pontos:

1. Manter foco no escopo do mini-app: dashboard + tela de detalhe.
2. Tratar estados explícitos de UI (`loading`, `success`, `error`) quando houver consumo de dados.
3. Preservar separação de camadas (`data`, `domain`, `presentation`) sem mistura de responsabilidade.
4. Se usar mock local de API, simular comportamento real (latência e dados plausíveis/variáveis).
5. Garantir cobertura de testes intencionais (mínimo exigido + casos críticos), seguindo AAA.
6. Registrar no README e no `prompt_log.md` decisões, correções e trade-offs com IA.
7. Evitar over-engineering: priorizar o que aumenta clareza, testabilidade e aderência aos critérios de avaliação.
