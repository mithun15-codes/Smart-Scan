import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isTesting = false;
  String? _testResult;
  bool? _testSuccess;

  @override
  void initState() {
    super.initState();
    _loadCurrentUrl();
  }

  Future<void> _loadCurrentUrl() async {
    final current = await ApiConfig.getBaseUrl();
    _urlController.text = current;
    setState(() {});
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = null;
    });

    // Save controller text first
    await ApiConfig.setBaseUrl(_urlController.text.trim());

    final res = await ApiService.checkBackendHealth();

    if (mounted) {
      setState(() {
        _isTesting = false;
        _testSuccess = res['isOnline'] == true;
        _testResult = res['message'];
      });
    }
  }

  Future<void> _saveUrl() async {
    await ApiConfig.setBaseUrl(_urlController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backend URL saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _handleLogout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'User Profile & Server Settings',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 20),

        // User info card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.scanCardStart,
                child: Icon(Icons.person, size: 40, color: AppColors.headingDark),
              ),
              const SizedBox(height: 12),
              Text(
                user?.username ?? 'Researcher',
                style: const TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingDark,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user?.isGuest == true
                      ? 'Demo / Guest Mode'
                      : 'Authenticated User',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00796B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Server configuration card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FastAPI Backend Configuration',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 8),
              const Text(
                'Configure the backend endpoint IP and port for Android emulator, physical phone, or production.',
                style: AppTextStyles.bodyMuted,
              ),
              const SizedBox(height: 14),

              TextField(
                controller: _urlController,
                decoration: InputDecoration(
                  labelText: 'FastAPI Base URL',
                  hintText: 'http://10.0.2.2:5000',
                  fillColor: AppColors.inputBackground,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Presets
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildPresetChip('Emulator (10.0.2.2:5000)', ApiConfig.emulatorDefault),
                  _buildPresetChip('Localhost (5000)', ApiConfig.localhostDefault),
                  _buildPresetChip('Alternative Port (8000)', 'http://10.0.2.2:8000'),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: _isTesting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering),
                      label: const Text('Test Connection'),
                      onPressed: _isTesting ? null : _testConnection,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save_outlined, color: Colors.white),
                      label: const Text('Save URL', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                      onPressed: _saveUrl,
                    ),
                  ),
                ],
              ),

              if (_testResult != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _testSuccess == true
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _testSuccess == true
                          ? const Color(0xFFA5D6A7)
                          : const Color(0xFFEF9A9A),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _testSuccess == true ? Icons.check_circle : Icons.error,
                        color: _testSuccess == true ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _testResult!,
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 13,
                            color: _testSuccess == true
                                ? const Color(0xFF1B5E20)
                                : const Color(0xFFB71C1C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Logout
        ElevatedButton.icon(
          icon: const Icon(Icons.logout_rounded, color: Colors.white),
          label: const Text('Sign Out', style: AppTextStyles.button),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorText,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, String url) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _urlController.text = url;
      },
      backgroundColor: const Color(0xFFE3F2FD),
      side: const BorderSide(color: Color(0xFF90CAF9)),
    );
  }
}

