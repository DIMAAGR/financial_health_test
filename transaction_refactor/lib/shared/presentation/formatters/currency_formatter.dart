import 'package:intl/intl.dart';

/// Centraliza a formatação monetária em BRL.
///
/// Recebe valores em **centavos** (int) — a divisão por 100 acontece aqui,
/// garantindo que nenhum código externo opere com frações monetárias inseguras.
/// Substitui as ocorrências de `toStringAsFixed(2)` espalhadas pela UI (problema #23).
abstract final class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  /// Formata [centavos] como moeda BRL. Ex: `1599` → `"R$ 15,99"`.
  static String format(int centavos) => _formatter.format(centavos / 100);
}
