import 'package:flutter/material.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';

/// Solid, playful "candy" card: white surface, big rounded corners and a soft
/// floating shadow. (Formerly a glassmorphism card — kept the same name and API
/// so every call site keeps working while the whole app shifts to the flat,
/// kid-friendly look.)
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool hasGlow;

  /// Optional surface color override (defaults to white).
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppTheme.radiusLg,
    this.hasGlow = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasGlow
            ? [
                BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.18), blurRadius: 28, offset: const Offset(0, 14)),
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ]
            : [
                BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 18, offset: const Offset(0, 8)),
              ],
      ),
      child: child,
    );
  }
}
