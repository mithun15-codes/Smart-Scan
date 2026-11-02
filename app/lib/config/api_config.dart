import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized API Configuration for Smart Scan
class ApiConfig {
  // Key for persistent base URL storage
  static const String _prefBaseUrlKey = 'custom_backend_base_url';

  // Preset addresses
  static const String emulatorDefault = 'http://10.0.2.2:5000';
  static const String localhostDefault = 'http://127.0.0.1:5000';
  static const String physicalDeviceDefault = 'http://192.168.1.100:5000';
  static const String productionDefault = 'https://api.smartscan.ai';

  // In-memory cached base URL
  static String? _cachedBaseUrl;

  /// Returns the initial default base URL depending on runtime environment
  static String getInitialDefault() {
    if (Platform.isAndroid) {
      // 10.0.2.2 maps to the host machine loopback inside standard Android emulator
      return emulatorDefault;
    }
    return localhostDefault;
  }

  /// Initialize and load saved base URL from SharedPreferences
  static Future<String> getBaseUrl() async {
    if (_cachedBaseUrl != null && _cachedBaseUrl!.isNotEmpty) {
      return _cachedBaseUrl!;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefBaseUrlKey);
      if (saved != null && saved.isNotEmpty) {
        _cachedBaseUrl = saved;
        return saved;
      }
    } catch (_) {}

    _cachedBaseUrl = getInitialDefault();
    return _cachedBaseUrl!;
  }

  /// Update the base URL dynamically (e.g. from the Profile/Settings screen)
  static Future<void> setBaseUrl(String newUrl) async {
    String cleanUrl = newUrl.trim();
    if (cleanUrl.endsWith('/')) {
      cleanUrl = cleanUrl.substring(0, cleanUrl.length - 1);
    }
    _cachedBaseUrl = cleanUrl;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefBaseUrlKey, cleanUrl);
    } catch (_) {}
  }

  /// Synchronous fallback when async is not possible
  static String get baseUrlSync => _cachedBaseUrl ?? getInitialDefault();

  // API Endpoints
  // Health Check
  static const String healthCheck = '/';

  // CNN Prediction Endpoints
  // FastAPI app.py has @app.post("/predict/"), while web index.html uses /predict_mri, /predict_ct, /predict_xray
  static const String genericPredict = '/predict/';
  static const String predictMri = '/predict_mri';
  static const String predictCt = '/predict_ct';
  static const String predictXray = '/predict_xray';

  // Authentication Endpoints (if supported by backend)
  static const String login = '/login';
  static const String register = '/register';
  static const String refreshToken = '/refresh';

  // Database / Scan History Endpoints (if supported by backend)
  static const String history = '/history';
  static const String profile = '/profile';
}

