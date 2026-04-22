# Conta Azul — Desafio 2

**Enunciado:** Apps mobile de longa data acumulam dívida técnica. O trecho abaixo representa um padrão comum em codebases legadas Flutter — tudo acoplado na camada de UI, sem separação de responsabilidades e sem testabilidade. Sua missão é analisar, criticar e modernizar usando IA como ferramenta principal.

**IAs utilizadas:** Claude Sonnet 4.6 (GitHub Copilot) e GPT 5.4

---

## Estrutura de Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| [docs/problemas.md](./docs/problemas.md) | 5 principais problemas do código legado |
| [docs/modernizacao.md](./docs/modernizacao.md) | Prompt usado, código modernizado e decisões |
| [docs/problemas_detalhados.md](./docs/problemas_detalhados.md) | Análise completa dos 25 problemas identificados |
| [docs/grupos_correcao.md](./docs/grupos_correcao.md) | Plano de correção: 6 grupos por causa raiz (checklist) |
| [docs/prompt_log.md](./docs/prompt_log.md) | Histórico de prompts, questionamentos e correções iterativas |
| [transaction_refactor/](./transaction_refactor/) | Projeto Flutter — código modernizado |

---

## Problemas

Identificação dos 5 principais problemas do código legado.

→ [docs/problemas.md](./docs/problemas.md)

---

## Modernização

Uso da IA para gerar a versão modernizada, documentando o prompt, as decisões arquiteturais e as correções iterativas.

→ [docs/modernizacao.md](./docs/modernizacao.md)

---

## Análise Técnica

Os 25 problemas identificados foram organizados por tema e impacto:

→ [docs/problemas_detalhados.md](./docs/problemas_detalhados.md)

Os problemas foram agrupados em 6 grupos de correção por causa raiz:

→ [docs/grupos_correcao.md](./docs/grupos_correcao.md)

---

## Histórico de Prompts

Prompts completos, questionamentos pós-geração e correções iterativas:

→ [docs/prompt_log.md](./docs/prompt_log.md)

---

## Resultado

Projeto Flutter completo em [`transaction_refactor/`](./transaction_refactor/) com:

- Clean Architecture (`core/`, `features/`, `shared/`)
- MVVM com `ValueNotifier` como estado
- `get_it` para injeção de dependências
- 75 testes unitários — 0 falhas

