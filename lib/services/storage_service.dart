import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_config.dart';

class StorageService {
  static const String _keyLastConfig = 'quizzical_last_config';

  /// Saves the last chosen quiz configuration
  Future<void> saveLastConfig(QuizConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(config.toJson());
      await prefs.setString(_keyLastConfig, jsonString);
    } catch (_) {
      // Graceful fallback if storage fails
    }
  }

  /// Loads the last saved quiz configuration, or default if none saved
  Future<QuizConfig?> loadLastConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyLastConfig);
      if (jsonString != null) {
        final Map<String, dynamic> map = jsonDecode(jsonString);
        return QuizConfig.fromJson(map);
      }
    } catch (_) {
      // Fallback
    }
    return null;
  }
}
