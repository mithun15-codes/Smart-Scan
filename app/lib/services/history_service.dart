import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_result.dart';

class HistoryService {
  static const String _prefHistoryKey = 'smart_scan_history_records';
  static List<ScanResult> _cachedHistory = [];
  static bool _isInitialized = false;

  /// Load scan history from persistent storage
  static Future<List<ScanResult>> getHistory() async {
    if (_isInitialized) {
      return _cachedHistory;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefHistoryKey) ?? [];
      _cachedHistory = list.map((item) {
        return ScanResult.fromJson(jsonDecode(item));
      }).toList();
      // Sort newest first
      _cachedHistory.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      _cachedHistory = [];
    }
    _isInitialized = true;
    return _cachedHistory;
  }

  /// Add a new scan result to history
  static Future<void> addRecord(ScanResult result) async {
    _cachedHistory.insert(0, result);
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _cachedHistory.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_prefHistoryKey, list);
    } catch (_) {}
  }

  /// Clear all history
  static Future<void> clearHistory() async {
    _cachedHistory.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefHistoryKey);
    } catch (_) {}
  }

  /// Delete a single record
  static Future<void> deleteRecord(String id) async {
    _cachedHistory.removeWhere((r) => r.id == id);
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _cachedHistory.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_prefHistoryKey, list);
    } catch (_) {}
  }
}

