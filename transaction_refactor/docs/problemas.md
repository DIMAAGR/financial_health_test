
## Problemas

O enunciado pede: **Identifique e liste todos os problemas do código acima — violações de princípios, acoplamentos, riscos, ausência de testabilidade. Mínimo de 5 problemas distintos, com explicação de cada um.**

Diversos problemas foram encontrados, segue-se uma lista, iniciando pelos 5 principais:

### OS 5 PRINCIPAIS PROBLEMAS

1 - Chamada HTTP direta dentro da UI

O trecho abaixo é um dos piores porque faz a tela depender diretamente da infraestrutura. A tela deixa de ser só tela e vira também serviço, controller e parser.

```dart 
    final response = await http.get(...)
```

Tendo como impacto:

* acoplamento alto
* dificulta troca de API/client
* dificulta testes
* mistura apresentação com acesso a dados

---

2 - Uso de Map<String, dynamic> em vez de modelo tipado

O trecho abaixo é muito grave porque contamina quase tudo. Esse tipo de escolha costuma virar dívida técnica rápido.

Impacto:

* perde segurança de tipo
* aumenta chance de erro em runtime
* torna o código menos legível
* espalha strings mágicas como 'descricao', 'valor', 'tipo'
* dificulta refatoração e autocomplete

```dart
    List<Map<String, dynamic>> transactions = [];
```

---

3 - Estado mal modelado

```dart
bool isLoading = false;
String? error;
List<Map<String, dynamic>> transactions = [];
```

O problema aqui é que o estado fica “solto”, permitindo combinações ambíguas. 

Exemplo: pode existir erro antigo salvo, lista preenchida e loading em momentos confusos. Um estado explícito (loading, success, error, empty) resolve muito disso.

Impacto:

* fluxo difícil de entender
* chance de estados inválidos
* manutenção pior
* UI menos previsível

---

4 - Muitas responsabilidades na mesma classe

Esse talvez seja o problema mais “estrutural” do código. A mesma classe:

* busca dados
* monta header
* pega token
* trata erro
* faz parse
* calcula total
* decide UI
* renderiza lista

Impacto:

* viola SRP forte
* aumenta complexidade cognitiva
* qualquer mudança quebra mais coisas
* manutenção e evolução ficam caras

---

5 - Baixa testabilidade

Como consequência dos pontos acima, testar isso fica ruim. Quando o código não é testável, normalmente ele também não está bem separado.

Impacto:

* testes unitários quase inexistentes
* lógica depende do widget
* precisa mockar HTTP/storage no lugar errado
* regras simples ficam presas na UI

#### RESUMO DOS 5 PRINCIPAIS PROBLEMAS:
Em ordem de impacto, eu colocaria assim:

1. Muitas responsabilidades na mesma classe
2. HTTP direto na UI
3. Uso de Map<String, dynamic>
4. Estado mal modelado
5. Baixa testabilidade

Porque os 4 primeiros causam o quinto.

---

### OS OUTROS PROBLEMAS ENCONTRADOS.

Aqui, é importante enteder que, todos eles são problemas tão graves quantos os problemas acima, devem ser corrigidos para que o código tenha uma melhor clareza, testabilidade desacoplamento, etc. 

**Disclaimer** como são muitos (cerca de +20), vou deixar em lista simples, mostrando pois se não o arquivo ficaria muito grande.

1. setState redundante no initState
2. setState dentro do initState é desnecessário nesse caso
3. UI acoplada ao formato cru da API
4. Regra de negócio dentro da camada de apresentação
5. Dependência direta de SharedPrefs.getToken()
6. Ausência de validação de statusCode
7. Tratamento de erro genérico e pouco confiável
8. Ausência de mounted antes de setState após await
9. Parsing inseguro
10. Falta de separação entre entity, model e view data
11. Código pouco legível por causa da concentração de responsabilidades
12. Violação do SRP (Single Responsibility Principle)
13. Violação de DIP (Dependency Inversion Principle)
14. DRY parcialmente violado
15. KISS mal aplicado
16. Falta de tratamento para estado vazio
17. Strings mágicas espalhadas
18. Widget de página sem estrutura de página
19. Falta de internacionalização e formatação monetária adequada
20. Nomes misturam idiomas e intenções
21. Falta de composição de widgets

