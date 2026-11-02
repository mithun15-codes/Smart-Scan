import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/web_background.dart';
import '../widgets/web_container.dart';
import '../widgets/web_footer.dart';
import '../widgets/web_nav_bar.dart';
import 'about_screen.dart';
import 'ct_screen.dart';
import 'history_screen.dart';
import 'mri_screen.dart';
import 'profile_screen.dart';
import 'xray_screen.dart';

class DashboardScreen extends StatefulWidget {
  final NavPage initialPage;

  const DashboardScreen({super.key, this.initialPage = NavPage.home});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late NavPage _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  void _navigateTo(NavPage page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == NavPage.home,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentPage != NavPage.home) {
          setState(() {
            _currentPage = NavPage.home;
          });
        }
      },
      child: Scaffold(
        body: WebBackground(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: WebContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main Heading from index.html: h1 "Medical Imaging Analysis"
                  const Text(
                    'Medical Imaging Analysis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headingDark,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigation Bar from index.html
                  WebNavBar(
                    activePage: _currentPage,
                    onPageSelected: _navigateTo,
                  ),

                  // Active Page Content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey<NavPage>(_currentPage),
                      child: _buildCurrentPage(),
                    ),
                  ),

                  // Website Footer
                  const WebFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case NavPage.home:
        return _buildDashboardHome();
      case NavPage.mri:
        return const MriScreen();
      case NavPage.ct:
        return const CtScreen();
      case NavPage.xray:
        return const XrayScreen();
      case NavPage.about:
        return const AboutScreen();
      case NavPage.history:
        return const HistoryScreen();
      case NavPage.profile:
        return const ProfileScreen();
    }
  }

  Widget _buildDashboardHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Welcome to Medical Imaging Portal',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 10),
        const Text(
          'Select a scan type from the navigation menu to begin analysis',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMuted,
        ),
        const SizedBox(height: 24),

        // Scan Options
        _buildScanOptionCard(
          title: 'MRI Scan',
          description:
              'Magnetic Resonance Imaging for detailed soft tissue analysis',
          buttonText: 'Go to MRI Analysis',
          icon: Icons.psychology_rounded,
          onTap: () => _navigateTo(NavPage.mri),
        ),
        const SizedBox(height: 18),

        _buildScanOptionCard(
          title: 'CT Scan',
          description:
              'Computed Tomography for cross-sectional imaging and pathology',
          buttonText: 'Go to CT Analysis',
          icon: Icons.view_in_ar_rounded,
          onTap: () => _navigateTo(NavPage.ct),
        ),
        const SizedBox(height: 18),

        _buildScanOptionCard(
          title: 'X-Ray Scan',
          description:
              'X-Ray imaging for bone, thoracic and pulmonary visualization',
          buttonText: 'Go to X-Ray Analysis',
          icon: Icons.medical_services_rounded,
          onTap: () => _navigateTo(NavPage.xray),
        ),
      ],
    );
  }

  Widget _buildScanOptionCard({
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.scanCardStart,
            AppColors.scanCardEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 38, color: AppColors.headingDark),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.headingDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 15,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

