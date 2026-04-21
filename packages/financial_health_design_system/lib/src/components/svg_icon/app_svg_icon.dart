import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Componente base para ícones SVG do design system.
///
/// Garante consistência de tamanho, cor e comportamento.
///
/// Exemplo:
/// ```dart
/// AppSvgIcon(
///   asset: AppIcons.financialScore,
///   size: 20,
/// )
/// ```
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
  });

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? IconTheme.of(context).color;

    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: iconColor != null
          ? ColorFilter.mode(iconColor, BlendMode.srcIn)
          : null,
    );
  }
}
