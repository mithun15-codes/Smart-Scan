import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class WebContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? maxWidth;

  const WebContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth = 900,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 900),
        child: Container(
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.containerGradientStart,
                AppColors.containerGradientEnd,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.containerBorder,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

