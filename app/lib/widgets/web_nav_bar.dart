import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum NavPage {
  home,
  mri,
  ct,
  xray,
  about,
  history,
  profile,
}

class WebNavBar extends StatelessWidget {
  final NavPage activePage;
  final ValueChanged<NavPage> onPageSelected;

  const WebNavBar({
    super.key,
    required this.activePage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.navBarStart,
            AppColors.navBarEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavItem('Home', Icons.home_rounded, NavPage.home),
            _buildNavItem('MRI Scan', Icons.psychology_rounded, NavPage.mri),
            _buildNavItem('CT Scan', Icons.view_in_ar_rounded, NavPage.ct),
            _buildNavItem('X-Ray Scan', Icons.medical_services_rounded, NavPage.xray),
            _buildNavItem('About Us', Icons.groups_rounded, NavPage.about),
            _buildNavItem('History', Icons.history_rounded, NavPage.history),
            _buildNavItem('Profile', Icons.person_rounded, NavPage.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, NavPage page) {
    final bool isActive = activePage == page;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => onPageSelected(page),
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [
                      AppColors.navActiveStart,
                      AppColors.navActiveEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.navActiveStart.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isActive ? Colors.white : Colors.white70,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      color: isActive ? Colors.white : const Color(0xFFF8F9FA),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 24,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.navUnderline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

