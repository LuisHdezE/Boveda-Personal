import 'dart:ui';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 16.0,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          highlightColor: AppColors.surfaceHighest.withValues(alpha: 0.5),
          splashColor: AppColors.surfaceHighest.withValues(alpha: 0.5),
          child: card,
        ),
      );
    }

    return card;
  }
}
