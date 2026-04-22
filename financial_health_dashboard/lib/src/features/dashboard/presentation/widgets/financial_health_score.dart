import 'package:financial_health_dashboard/src/features/dashboard/domain/entities/financial_health_score_data.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/financial_health_score_resolver.dart';
import 'package:financial_health_dashboard/src/features/dashboard/presentation/mappers/financial_health_score_text_mapper.dart';
import 'package:financial_health_design_system/financial_health_design_system.dart';
import 'package:flutter/material.dart';

/// Card principal de score de saúde financeira.
///
/// Exibe o status atual da saúde financeira do usuário, incluindo:
/// - status textual
/// - score numérico
/// - título
/// - headline explicativa
/// - descrição complementar
///
/// O componente adapta automaticamente sua aparência de acordo com o
/// [FinancialHealthStatus] presente em [data] e com o tema atual do app.
///
/// Pode ser usado como elemento clicável através de [onTap].
///
/// Exemplo:
/// ```dart
/// FinancialHealthScoreCard(
///   data: FinancialHealthScoreData(
///     status: FinancialHealthStatus.healthy,
///     score: 78,
///     incomeCommitmentPercent: 60,
///     liquidityChangePercent: 4,
///   ),
///   onTap: () {
///     // abrir detalhes
///   },
/// )
/// ```
class FinancialHealthScoreCard extends StatelessWidget {
  const FinancialHealthScoreCard({
    super.key,
    required this.data,
    this.onTap,
    this.iconAssetPath,
  });

  /// Dados de apresentação do score financeiro.
  final FinancialHealthScoreData data;

  /// Callback disparado ao tocar no card.
  ///
  /// Quando `null`, o card permanece apenas informativo.
  final VoidCallback? onTap;

  /// Caminho customizado do ícone exibido no topo direito.
  ///
  /// Quando `null`, usa o ícone padrão de score financeiro.
  final String? iconAssetPath;

  @override
  Widget build(BuildContext context) {
    final FinancialHealthCardColors style =
        FinancialHealthCardStyleResolver.resolve(context, data.status);

    final borderRadius = BorderRadius.circular(AppRadius.lg);

    return Container(
      decoration: BoxDecoration(
        color: style.useGradient ? null : style.backgroundSolid,
        gradient: style.useGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [style.backgroundStart, style.backgroundEnd],
              )
            : null,
        borderRadius: borderRadius,
        border: Border.all(
          color: style.borderColor,
          width: style.borderColor.a == 0 ? 0 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 340),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopSection(
                    data: data,
                    style: style,
                    iconAssetPath: iconAssetPath,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: style.divider,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _BottomSection(data: data, style: style),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSection extends StatelessWidget {
  const _TopSection({
    required this.data,
    required this.style,
    this.iconAssetPath,
  });

  final FinancialHealthScoreData data;
  final FinancialHealthCardColors style;
  final String? iconAssetPath;

  @override
  Widget build(BuildContext context) {
    final label = FinancialHealthScoreTextMapper.label(data.status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: style.badgeBackground,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: AppTextStyles.financialBadge.copyWith(
                  color: style.badgeText,
                ),
              ),
            ),
            const Spacer(),
            AppSvgIcon(
              asset: iconAssetPath ?? AppIcons.financialScore,
              color: style.iconColor,
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: 0.8,
          child: Text(
            FinancialHealthScoreTextMapper.title,
            style: AppTextStyles.financialCardTitle.copyWith(
              color: style.titleText,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${data.score}',
              style: AppTextStyles.financialScore.copyWith(
                color: style.scoreText,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  '/100',
                  style: AppTextStyles.financialScoreSuffix.copyWith(
                    color: style.scoreSuffixText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({required this.data, required this.style});

  final FinancialHealthScoreData data;
  final FinancialHealthCardColors style;

  @override
  Widget build(BuildContext context) {
    final headline = FinancialHealthScoreTextMapper.headline(data);
    final description = FinancialHealthScoreTextMapper.description(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headline,
          style: AppTextStyles.financialHeadline.copyWith(
            color: style.headlineText,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Opacity(
          opacity: 0.7,
          child: Text(
            description,
            style: AppTextStyles.financialDescription.copyWith(
              color: style.descriptionText,
            ),
          ),
        ),
      ],
    );
  }
}
