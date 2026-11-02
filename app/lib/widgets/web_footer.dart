import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.footerBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: const [
          Text(
            '© 2025 Medical Imaging Portal. All rights reserved.',
            textAlign: TextAlign.center,
            style: AppTextStyles.footer,
          ),
          SizedBox(height: 6),
          Text(
            'For medical emergencies, please contact your healthcare provider.',
            textAlign: TextAlign.center,
            style: AppTextStyles.footer,
          ),
        ],
      ),
    );
  }
}

