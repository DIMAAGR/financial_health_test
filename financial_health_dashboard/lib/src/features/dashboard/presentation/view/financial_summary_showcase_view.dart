import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

class FinancialSummaryShowcaseView extends StatelessWidget {
  const FinancialSummaryShowcaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões de Resumo'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: const [
          _ShowcaseLabel('Padrão — Positivo (light)'),
          SizedBox(height: AppSpacing.sm),
          _DefaultPositiveCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Padrão — Negativo (light)'),
          SizedBox(height: AppSpacing.sm),
          _DefaultNegativeCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Preto'),
          SizedBox(height: AppSpacing.sm),
          _DarkCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Branco'),
          SizedBox(height: AppSpacing.sm),
          _WhiteCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Verde'),
          SizedBox(height: AppSpacing.sm),
          _GreenCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Vermelho'),
          SizedBox(height: AppSpacing.sm),
          _RedCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Amarelo'),
          SizedBox(height: AppSpacing.sm),
          _YellowCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Azul'),
          SizedBox(height: AppSpacing.sm),
          _BlueCard(),
          SizedBox(height: AppSpacing.xl),
          _ShowcaseLabel('Roxo'),
          SizedBox(height: AppSpacing.sm),
          _PurpleCard(),
          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _ShowcaseLabel extends StatelessWidget {
  const _ShowcaseLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        letterSpacing: 0.5,
      ),
    );
  }
}

// ─── Padrão positivo ────────────────────────────────────────────────────────

class _DefaultPositiveCard extends StatelessWidget {
  const _DefaultPositiveCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'ENTRADAS',
      value: 'R\$ 12.400,00',
      variationPercent: 15.4,
      icon: const Icon(Icons.trending_up),
      onTap: () {},
    );
  }
}

// ─── Padrão negativo ────────────────────────────────────────────────────────

class _DefaultNegativeCard extends StatelessWidget {
  const _DefaultNegativeCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'GASTOS',
      value: 'R\$ 8.750,00',
      variationPercent: -6.2,
      icon: const Icon(Icons.trending_down),
      onTap: () {},
    );
  }
}

// ─── Paletas customizadas ────────────────────────────────────────────────────

const _darkPalette = FinancialSummaryCardPalette(
  background: Color(0xFF1A1A1A),
  foreground: Color(0xFFFFFFFF),
  accentBackground: Color(0xFF333333),
  accentForeground: Color(0xFFFFFFFF),
  border: Color(0x00000000),
  shadow: Color(0x33000000),
);

const _whitePalette = FinancialSummaryCardPalette(
  background: Color(0xFFFFFFFF),
  foreground: Color(0xFF1A1A1A),
  accentBackground: Color(0xFFF0F0F0),
  accentForeground: Color(0xFF1A1A1A),
  border: Color(0xFFDDDDDD),
  shadow: Color(0x1A000000),
);

const _greenPalette = FinancialSummaryCardPalette(
  background: Color(0xFF1B4332),
  foreground: Color(0xFFFFFFFF),
  accentBackground: Color(0xFF2D6A4F),
  accentForeground: Color(0xFFFFFFFF),
  border: Color(0x00000000),
  shadow: Color(0x3300C853),
);

const _redPalette = FinancialSummaryCardPalette(
  background: Color(0xFF7B1618),
  foreground: Color(0xFFFFFFFF),
  accentBackground: Color(0xFF9D1F22),
  accentForeground: Color(0xFFFFFFFF),
  border: Color(0x00000000),
  shadow: Color(0x33D32F2F),
);

const _yellowPalette = FinancialSummaryCardPalette(
  background: Color(0xFFF9C74F),
  foreground: Color(0xFF1A1A1A),
  accentBackground: Color(0xFFFFB703),
  accentForeground: Color(0xFF1A1A1A),
  border: Color(0x00000000),
  shadow: Color(0x33F9A825),
);

const _bluePalette = FinancialSummaryCardPalette(
  background: Color(0xFF1B4F8A),
  foreground: Color(0xFFFFFFFF),
  accentBackground: Color(0xFF2563A8),
  accentForeground: Color(0xFFFFFFFF),
  border: Color(0x00000000),
  shadow: Color(0x331565C0),
);

const _purplePalette = FinancialSummaryCardPalette(
  background: Color(0xFF4A1072),
  foreground: Color(0xFFFFFFFF),
  accentBackground: Color(0xFF6A1B9A),
  accentForeground: Color(0xFFFFFFFF),
  border: Color(0x00000000),
  shadow: Color(0x336A1B9A),
);

// ─── Cards temáticos ─────────────────────────────────────────────────────────

class _DarkCard extends StatelessWidget {
  const _DarkCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'SALDO TOTAL',
      value: 'R\$ 42.000,00',
      variationPercent: 8.0,
      icon: const Icon(Icons.account_balance_wallet),
      themePalette: _darkPalette,
      onTap: () {},
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'INVESTIMENTOS',
      value: 'R\$ 18.300,00',
      variationPercent: 3.7,
      icon: const Icon(Icons.show_chart),
      themePalette: _whitePalette,
      onTap: () {},
    );
  }
}

class _GreenCard extends StatelessWidget {
  const _GreenCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'ENTRADAS',
      value: 'R\$ 9.600,00',
      variationPercent: 22.1,
      icon: const Icon(Icons.arrow_upward),
      themePalette: _greenPalette,
      onTap: () {},
    );
  }
}

class _RedCard extends StatelessWidget {
  const _RedCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'DÍVIDAS',
      value: 'R\$ 3.200,00',
      variationPercent: -11.5,
      icon: const Icon(Icons.arrow_downward),
      themePalette: _redPalette,
      onTap: () {},
    );
  }
}

class _YellowCard extends StatelessWidget {
  const _YellowCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'RESERVA',
      value: 'R\$ 5.000,00',
      variationPercent: 0.0,
      icon: const Icon(Icons.savings),
      themePalette: _yellowPalette,
      onTap: () {},
    );
  }
}

class _BlueCard extends StatelessWidget {
  const _BlueCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'CARTÃO DE CRÉDITO',
      value: 'R\$ 2.850,00',
      variationPercent: -4.3,
      icon: const Icon(Icons.credit_card),
      themePalette: _bluePalette,
      onTap: () {},
    );
  }
}

class _PurpleCard extends StatelessWidget {
  const _PurpleCard();

  @override
  Widget build(BuildContext context) {
    return FinancialSummaryCard(
      title: 'METAS',
      value: 'R\$ 1.200,00',
      variationPercent: 60.0,
      icon: const Icon(Icons.flag),
      themePalette: _purplePalette,
      onTap: () {},
    );
  }
}
