import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class ApiService {
  /// Check if the FastAPI backend is running
  static Future<Map<String, dynamic>> checkBackendHealth() async {
    final baseUrl = await ApiConfig.getBaseUrl();
    try {
      final url = Uri.parse('$baseUrl${ApiConfig.healthCheck}');
      final response = await http.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {
            'isOnline': true,
            'message': data['message'] ?? 'API is running',
            'statusCode': response.statusCode,
          };
        } catch (_) {
          return {
            'isOnline': true,
            'message': 'API is running (HTTP 200)',
            'statusCode': response.statusCode,
          };
        }
      } else {
        return {
          'isOnline': false,
          'message': 'Server responded with status code ${response.statusCode}',
          'statusCode': response.statusCode,
        };
      }
    } on SocketException catch (_) {
      return {
        'isOnline': false,
        'message': 'Could not connect to $baseUrl. Please verify backend is running.',
      };
    } catch (e) {
      return {
        'isOnline': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  /// Prepare headers including Bearer token if user is authenticated
  static Future<Map<String, String>> getHeaders({bool isJson = true}) async {
    final headers = <String, String>{};
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }
    final token = await AuthService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}

