# Análise Detalhada — Todos os Problemas do Código Legado

> Este documento detalha todos os 25 problemas identificados no código legado `TransactionPage`.
> Para ver apenas os 5 principais, veja [problemas.md](./problemas.md).
> Para ver como cada problema foi corrigido, veja os [grupos de correção](./grupos_correcao.md).

---

## O Código Original

```dart
class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}
class _TransactionPageState extends State<TransactionPage> {
  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    setState(() { isLoading = true; });
  }

  Future<void> _loadTransactions() async {
    setState(() { isLoading = true; });
    try {
      final response = await http.get(
        Uri.parse('https://api.example.com/v1/transactions'),
        headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'},
      );
      final data = json.decode(response.body) as List;
      setState(() {
        transactions = data.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Erro ao carregar transações: $e';
        isLoading = false;
      });
    }
  }

  double _calcularTotal() {
    return transactions.fold(0, (sum, t) => sum + (t['valor'] as num));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));
    return Column(
      children: [
        Text('Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(transactions[i]['descricao'] ?? ''),
              subtitle: Text('R\$ ${transactions[i]['valor']}'),
              trailing: Icon(
                transactions[i]['tipo'] == 'receita'
                    ? Icons.arrow_upward : Icons.arrow_downward,
                color: transactions[i]['tipo'] == 'receita'
                    ? Colors.green : Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## Os 25 Problemas

### 1. `setState` redundante no `initState`

No `initState`, ele chama `_loadTransactions()` e logo depois faz:

```dart
setState(() { isLoading = true; });
```

Mas `_loadTransactions()` já começa com o mesmo `setState`. Duplicidade de atualização de estado que gera rebuild desnecessário.

---

### 2. `setState` dentro do `initState` é desnecessário

O widget ainda está no ciclo inicial de montagem. Bastaria inicializar diretamente:

```dart
bool isLoading = true;
```

O `setState` aqui piora a clareza sem adicionar valor.

---

### 3. Estado muito genérico e mal modelado

```dart
bool isLoading = false;
String? error;
List<Map<String, dynamic>> transactions = [];
```

Três variáveis soltas permitem combinações inválidas:
- `isLoading == true` e `error != null` ao mesmo tempo
- `transactions` preenchido com `error` antigo ainda salvo
- `isLoading == false` com lista vazia — sem distinguir "vazio" de "erro" ou "sucesso"

Um estado explícito (`loading`, `success`, `error`, `empty`) resolve isso.

---

### 4. Uso de `Map<String, dynamic>` em vez de modelo tipado

```dart
List<Map<String, dynamic>> transactions = [];
```

- Sem autocomplete confiável
- Sem validação forte de tipo
- Typo em strings (`'valor'`, `'descricao'`, `'tipo'`) causa erro em runtime
- Parsing espalhado pela UI
- Difícil manutenção

O ideal seria um `TransactionEntity` com campos tipados.

---

### 5. UI acoplada ao formato cru da API

```dart
transactions[i]['descricao']
transactions[i]['valor']
transactions[i]['tipo']
```

A tela conhece o contrato bruto da API. Se a API mudar `descricao` para `description`, a UI quebra. Não há camada de isolamento.

---

### 6. Regra de negócio dentro da camada de apresentação

```dart
double _calcularTotal() {
  return transactions.fold(0, (sum, t) => sum + (t['valor'] as num));
}
```

Lógica de negócio dentro do widget dificulta reuso, teste unitário isolado e separação de responsabilidades.

---

### 7. Chamada HTTP direta na tela

```dart
final response = await http.get(...)
```

A tela está fazendo tudo ao mesmo tempo: iniciar requisição, montar header, ler token, fazer parse, tratar erro, armazenar estado e renderizar UI. Viola SRP fortemente.

---

### 8. Dependência direta de `SharedPrefs.getToken()`

```dart
headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}
```

- A tela sabe como autenticação funciona
- Depende de storage local diretamente
- Dificulta mock em testes
- Mistura responsabilidade de sessão/autorização com apresentação

Deveria estar em um `AuthTokenProvider`, interceptor ou repositório.

---

### 9. Ausência de validação de `statusCode`

```dart
final response = await http.get(...)
final data = json.decode(response.body) as List;
```

Se vier `401`, `500`, HTML ou JSON com estrutura de erro, ele tenta decodificar e fazer cast do mesmo jeito. Frágil.

---

### 10. Tratamento de erro genérico e pouco confiável

```dart
error = 'Erro ao carregar transações: $e';
```

- Expõe erro técnico bruto para a UI
- Mistura mensagem amigável com detalhe interno
- Não categoriza erros (rede, auth, timeout, parse, servidor)

Falta uma abstração de falha (`Failure`, `AppError`).

---

### 11. Ausência de `mounted` antes de `setState` após `await`

Após uma chamada assíncrona o widget pode ter sido descartado. Sem verificar `if (!mounted) return;` antes do `setState`, pode ocorrer erro em tempo de execução ao tentar atualizar estado de widget desmontado.

---

### 12. Parsing inseguro

```dart
final data = json.decode(response.body) as List;
transactions = data.cast<Map<String, dynamic>>();
```

Assume que a resposta sempre é lista, todos os itens são `Map<String, dynamic>` e todos os campos existem no formato esperado. Sem validação, qualquer mudança quebra em runtime.

---

### 13. Falta de separação entre entity, model e view data

O mesmo dado cru da API é usado para cálculo, renderização, decisão de ícone/cor e exibição textual. O ideal seria:
- `TransactionDto` — para a API
- `TransactionEntity` — para o domínio
- `TransactionItemViewData` — para a UI

---

### 14. Código pouco legível por concentração de responsabilidades

A mesma classe concentra: ciclo de vida, estado, chamada remota, autenticação, parse JSON, tratamento de erro, cálculo de total, regra visual de tipo e renderização. Curta, mas cognitivamente pesada.

---

### 15. Violação do SRP (Single Responsibility Principle)

A tela tem múltiplas razões para mudar: mudança na API, na autenticação, no cálculo do total, na estrutura do dado, no tratamento de erro ou na UI. Caso clássico de violação de responsabilidade única.

---

### 16. Violação do DIP (Dependency Inversion Principle)

```dart
http.get(...)
SharedPrefs.getToken()
```

A tela depende de implementações concretas. Deveria depender de abstrações: `TransactionRepository`, `GetTransactionsUseCase`, `AuthTokenProvider`.

---

### 17. Baixa testabilidade

- Lógica misturada no widget
- Depende de HTTP real ou mock complexo diretamente na tela
- Depende de `SharedPrefs`
- Cálculo do total dentro da UI
- Parsing embutido no fluxo visual

Pode ser testado com widget test + mocks, mas é muito mais trabalhoso do que deveria.

---

### 18. DRY parcialmente violado

```dart
transactions[i]['tipo'] == 'receita' ? Icons.arrow_upward : Icons.arrow_downward
transactions[i]['tipo'] == 'receita' ? Colors.green : Colors.red
```

A mesma condição é avaliada duas vezes. Deveria ser encapsulada em um enum, model ou mapper visual.

---

### 19. KISS mal aplicado

Parece simples, mas é uma simplicidade enganosa. O código ficou curto porque ignorou separação de camadas. Não é simplicidade sustentável — é dívida técnica acumulada.

---

### 20. Falta de tratamento para estado vazio

Se a API retornar lista vazia, a tela mostra `Total: R$ 0.00` com lista em branco. Não existe UX clara para "sem transações".

---

### 21. Strings mágicas espalhadas

```
'descricao', 'valor', 'tipo', 'receita'
'https://api.example.com/v1/transactions'
'Authorization'
```

Hardcoded em vários lugares. Dificulta manutenção e aumenta chance de erro por typo.

---

### 22. Widget de página sem estrutura de página

O `build` retorna diretamente `Column`, `Center`. Falta composição clara com `Scaffold`, estados visuais organizados e widgets separados por responsabilidade.

---

### 23. Falta de formatação monetária adequada

```dart
'Total: R\$ ${_calcularTotal().toStringAsFixed(2)}'
```

Não usa `NumberFormat`, portanto não respeita locale, não separa milhar corretamente e não centraliza formatação monetária.

---

### 24. Nomes misturam idiomas

```dart
_loadTransactions   // inglês
_calcularTotal      // português
```

Inconsistência prejudica legibilidade e convenção do projeto.

---

### 25. Falta de composição de widgets

O `ListTile` com lógica de tipo, valor e ícone está inline no `itemBuilder`. Reduz reuso e dificulta leitura. Um `TransactionListItem` separado deixaria o `itemBuilder` de uma linha.
