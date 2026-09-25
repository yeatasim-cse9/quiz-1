import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../models/quiz_config.dart';
import '../models/quiz_result.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class QuizProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  QuizProvider({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService() {
    _init();
  }

  // Categories State
  List<TriviaCategory> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoryError;
  bool _categoriesLoaded = false;

  List<TriviaCategory> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoryError => _categoryError;
  bool get categoriesLoaded => _categoriesLoaded;

  // Quiz Configuration State
  QuizConfig _config = const QuizConfig(
    categoryId: 9,
    categoryName: 'General Knowledge',
    amount: 10,
    difficulty: 'any',
    type: 'any',
  );
  QuizConfig get config => _config;

  // Quiz Gameplay State
  List<TriviaQuestion> _questions = [];
  int _currentIndex = 0;
  bool _isLoadingQuestions = false;
  String? _questionError;
  int _score = 0;

  // Timing
  static const int questionDuration = 25; // seconds per question
  int _questionTimeRemaining = questionDuration;
  int _totalElapsedSeconds = 0;
  Timer? _questionTimer;
  Timer? _stopwatchTimer;

  // Public Getters
  List<TriviaQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get questionError => _questionError;
  int get score => _score;
  int get questionTimeRemaining => _questionTimeRemaining;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  double get questionProgress =>
      _questions.isEmpty ? 0 : (_currentIndex + 1) / _questions.length;

  TriviaQuestion? get currentQuestion =>
      (_questions.isNotEmpty && _currentIndex < _questions.length)
          ? _questions[_currentIndex]
          : null;

  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentIndex == _questions.length - 1;

  QuizResult get quizResult {
    final correctCount = _questions.where((q) => q.isCorrect).length;
    final incorrectCount = _questions.where((q) => q.isAnswered && !q.isCorrect).length;
    final unansweredCount = _questions.where((q) => !q.isAnswered).length;
    return QuizResult(
      totalQuestions: _questions.length,
      correctAnswers: _score > correctCount ? _score : correctCount,
      incorrectAnswers: incorrectCount,
      unanswered: unansweredCount,
      totalTimeSeconds: _totalElapsedSeconds,
      categoryName: _config.categoryName,
    );
  }

  void _init() async {
    await loadSavedConfig();
    fetchCategories();
  }

  /// Loads saved config from SharedPreferences
  Future<void> loadSavedConfig() async {
    final saved = await _storageService.loadLastConfig();
    if (saved != null) {
      _config = saved;
      notifyListeners();
    }
  }

  /// Fetches categories once and caches them for session
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_categoriesLoaded && !forceRefresh && _categories.isNotEmpty) {
      return;
    }

    _isLoadingCategories = true;
    _categoryError = null;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
      _categoriesLoaded = true;
      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _categoryError = e.toString();
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  /// Updates current configuration
  void updateConfig(QuizConfig newConfig) {
    _config = newConfig;
    _storageService.saveLastConfig(_config);
    notifyListeners();
  }

  void selectCategory(int id, String name) {
    _config = _config.copyWith(categoryId: id, categoryName: name);
    _storageService.saveLastConfig(_config);
    notifyListeners();
  }

  void updateAmount(int amount) {
    _config = _config.copyWith(amount: amount);
    _storageService.saveLastConfig(_config);
    notifyListeners();
  }

  void updateDifficulty(String difficulty) {
    _config = _config.copyWith(difficulty: difficulty);
    _storageService.saveLastConfig(_config);
    notifyListeners();
  }

  void updateType(String type) {
    _config = _config.copyWith(type: type);
    _storageService.saveLastConfig(_config);
    notifyListeners();
  }

  /// Fetches questions and starts the quiz session
  Future<bool> startQuiz() async {
    _isLoadingQuestions = true;
    _questionError = null;
    notifyListeners();

    // Preserve chosen config in SharedPreferences
    await _storageService.saveLastConfig(_config);

    try {
      final fetchedQuestions = await _apiService.fetchQuestions(_config);
      _questions = fetchedQuestions;
      _currentIndex = 0;
      _score = 0;
      _totalElapsedSeconds = 0;
      _isLoadingQuestions = false;
      notifyListeners();

      _startQuestionTimer();
      _startStopwatch();
      return true;
    } catch (e) {
      _isLoadingQuestions = false;
      _questionError = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Restarts the quiz with preserved configuration
  Future<bool> restartQuiz() async {
    cancelTimers();
    return await startQuiz();
  }

  /// Start 25s countdown timer for active question
  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _questionTimeRemaining = questionDuration;

    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_questionTimeRemaining > 1) {
        _questionTimeRemaining--;
        notifyListeners();
      } else {
        _questionTimeRemaining = 0;
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  /// Handles when timer reaches 0
  void _handleTimeout() {
    final question = currentQuestion;
    if (question != null && !question.isAnswered) {
      question.isTimedOut = true;
      notifyListeners();
    }
  }

  /// Starts the total game stopwatch
  void _startStopwatch() {
    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _totalElapsedSeconds++;
      notifyListeners();
    });
  }

  /// User selects an answer option
  void selectAnswer(String answer) {
    final question = currentQuestion;
    if (question == null || question.isAnswered) return;

    _questionTimer?.cancel();
    question.selectedAnswer = answer;

    if (question.isCorrect) {
      _score++;
    }

    notifyListeners();
  }

  /// Advance to next question or complete quiz
  bool nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _startQuestionTimer();
      notifyListeners();
      return true;
    } else {
      // Quiz Finished!
      cancelTimers();
      notifyListeners();
      return false;
    }
  }

  /// Stops all active timers (e.g. on exit dialog, dispose or complete)
  void cancelTimers() {
    _questionTimer?.cancel();
    _questionTimer = null;
    _stopwatchTimer?.cancel();
    _stopwatchTimer = null;
  }

  /// Resets quiz state cleanly
  void resetQuiz() {
    cancelTimers();
    _currentIndex = 0;
    _score = 0;
    _totalElapsedSeconds = 0;
    _questions = [];
    _questionError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    cancelTimers();
    super.dispose();
  }
}
