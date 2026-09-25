import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/question.dart';
import '../models/quiz_config.dart';

class ApiException implements Exception {
  final String message;
  final int? responseCode;

  ApiException(this.message, {this.responseCode});

  @override
  String toString() => message;
}

class ApiService {
  static const String _categoryUrl = 'https://opentdb.com/api_category.php';
  static const String _questionBaseUrl = 'https://opentdb.com/api.php';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches all categories from OpenTDB
  Future<List<TriviaCategory>> fetchCategories() async {
    try {
      final response = await _client.get(
        Uri.parse(_categoryUrl),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> categoriesJson = data['trivia_categories'] ?? [];
        return categoriesJson
            .map((item) => TriviaCategory.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException(
          'Failed to load categories (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Unable to connect to quiz server. Please check your internet connection and try again.',
      );
    }
  }

  /// Fetches quiz questions based on QuizConfig
  Future<List<TriviaQuestion>> fetchQuestions(QuizConfig config) async {
    final queryParams = <String, String>{
      'amount': config.amount.toString(),
    };

    if (config.categoryId > 0) {
      queryParams['category'] = config.categoryId.toString();
    }
    if (config.difficulty != 'any') {
      queryParams['difficulty'] = config.difficulty;
    }
    if (config.type != 'any') {
      queryParams['type'] = config.type;
    }

    final uri = Uri.parse(_questionBaseUrl).replace(queryParameters: queryParams);

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int responseCode = data['response_code'] as int? ?? 0;

        switch (responseCode) {
          case 0:
            final List<dynamic> results = data['results'] as List<dynamic>? ?? [];
            if (results.isEmpty) {
              throw ApiException(
                'No questions returned from server for this configuration.',
                responseCode: 0,
              );
            }
            return results
                .map((q) => TriviaQuestion.fromJson(q as Map<String, dynamic>))
                .toList();

          case 1:
            throw ApiException(
              'Not enough questions available for this specific combination. Try reducing the amount or selecting "Any Difficulty".',
              responseCode: 1,
            );

          case 2:
            throw ApiException(
              'Invalid quiz parameters provided. Please check your settings.',
              responseCode: 2,
            );

          case 5:
            throw ApiException(
              'Server rate limit reached. Please wait 5 seconds before retrying.',
              responseCode: 5,
            );

          default:
            throw ApiException(
              'Server returned error code: $responseCode. Please try again.',
              responseCode: responseCode,
            );
        }
      } else {
        throw ApiException(
          'Server error (${response.statusCode}). Please try again later.',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to connect to quiz server. Please check your connection and retry.',
      );
    }
  }
}
