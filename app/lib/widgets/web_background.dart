import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class WebBackground extends StatelessWidget {
  final Widget child;

  const WebBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base solid background
        Container(color: AppColors.scaffoldBackground),

        // CDC Medical background image from the website with graceful fallback
        Positioned.fill(
          child: Image.network(
            AppConstants.bgImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Graceful medical abstract gradient fallback if offline
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFE3F2FD),
                      Color(0xFFBBDEFB),
                      Color(0xFFE0F7FA),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
        ),

        // Subtle overlay to match web opacity and improve contrast
        Positioned.fill(
          child: Container(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),

        // Foreground content
        SafeArea(child: child),
      ],
    );
  }
}

