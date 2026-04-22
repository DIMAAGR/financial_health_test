import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Base SVG icon widget for the design system.
///
/// Renders an SVG asset at a consistent size and applies a [ColorFilter] so
/// icons always adapt to the surrounding theme color.
///
/// When [color] is omitted, the icon inherits the nearest [IconTheme] color
/// from the widget tree — making it compatible with [IconTheme] overrides.
///
/// ## Usage
/// ```dart
/// AppSvgIcon(
///   asset: AppIcons.wallet,
///   size: 20,
///   color: theme.iconColor,
/// )
/// ```
class AppSvgIcon extends StatelessWidget {
  /// Creates an [AppSvgIcon].
  const AppSvgIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
  });

  /// Path to the SVG asset. Use [AppIcons] constants for built-in icons.
  final String asset;

  /// Width and height of the rendered icon in logical pixels. Defaults to 24.
  final double size;

  /// Explicit tint color for the icon.
  ///
  /// When `null`, the icon inherits the color from the nearest [IconTheme].
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
