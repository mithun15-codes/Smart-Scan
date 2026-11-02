import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user_model.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_auth_token';
  static const _userKey = 'user_profile_data';

  static UserModel? _currentUser;
  static bool? _backendAuthAvailable;

  static UserModel? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  /// Initialize and restore session from secure storage
  static Future<void> initialize() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson != null) {
        _currentUser = UserModel.fromJson(jsonDecode(userJson));
      }
    } catch (_) {
      _currentUser = null;
    }
  }

  /// Get stored JWT token
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (_) {
      return null;
    }
  }

  /// Check whether the backend supports authentication endpoints
  static Future<bool> probeBackendAuth() async {
    if (_backendAuthAvailable != null) {
      return _backendAuthAvailable!;
    }
    try {
      final baseUrl = await ApiConfig.getBaseUrl();
      final url = Uri.parse('$baseUrl${ApiConfig.login}');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': 'probe_test', 'password': 'probe_test'}),
          )
          .timeout(const Duration(seconds: 4));

      // 404 indicates endpoint doesn't exist on FastAPI
      if (response.statusCode == 404) {
        _backendAuthAvailable = false;
        return false;
      }
      // If endpoint exists and returns 400, 401, 422 or 200, it's supported
      _backendAuthAvailable = true;
      return true;
    } catch (_) {
      _backendAuthAvailable = false;
      return false;
    }
  }

  /// Real backend login request
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    final url = Uri.parse('$baseUrl${ApiConfig.login}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username.trim(), 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['access_token'] ?? data['token'];
        if (token != null) {
          await _storage.write(key: _tokenKey, value: token.toString());
        }

        final user = UserModel(
          username: username.trim(),
          token: token?.toString(),
          email: data['email'],
          isGuest: false,
        );

        _currentUser = user;
        await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
        _backendAuthAvailable = true;

        return {'success': true, 'user': user};
      } else if (response.statusCode == 404) {
        _backendAuthAvailable = false;
        return {
          'success': false,
          'not_implemented': true,
          'message':
              'FastAPI backend does not currently have a /login endpoint. The backend in app.py only implements CNN prediction. You may proceed in Guest/Demo mode.',
        };
      } else {
        String msg = 'Invalid credentials. Please try again.';
        try {
          final data = jsonDecode(response.body);
          if (data['detail'] != null) {
            msg = data['detail'].toString();
          }
        } catch (_) {}
        return {'success': false, 'message': msg};
      }
    } on SocketException {
      return {
        'success': false,
        'message':
            'Cannot reach server at $baseUrl. Check network connection or backend URL in settings.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  /// Real backend registration request
  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final baseUrl = await ApiConfig.getBaseUrl();
    final url = Uri.parse('$baseUrl${ApiConfig.register}');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username.trim(),
              'email': email.trim(),
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Account created successfully!'};
      } else if (response.statusCode == 404) {
        _backendAuthAvailable = false;
        return {
          'success': false,
          'not_implemented': true,
          'message':
              'FastAPI backend does not currently have a /register endpoint. The backend repository currently only hosts model inference.',
        };
      } else {
        String msg = 'Registration failed. Please check your details.';
        try {
          final data = jsonDecode(response.body);
          if (data['detail'] != null) {
            msg = data['detail'].toString();
          }
        } catch (_) {}
        return {'success': false, 'message': msg};
      }
    } on SocketException {
      return {
        'success': false,
        'message': 'Cannot reach server at $baseUrl.',
      };
    } catch (e) {
      return {'success': false, 'message': 'Registration error: ${e.toString()}'};
    }
  }

  /// Demo / Guest mode fallback when backend auth endpoint is not deployed yet
  static Future<void> continueAsGuest(String username) async {
    final user = UserModel(
      username: username.isEmpty ? 'Researcher' : username,
      isGuest: true,
    );
    _currentUser = user;
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  /// Logout
  static Future<void> logout() async {
    _currentUser = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}

