class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int unanswered;
  final int totalTimeSeconds;
  final String categoryName;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.unanswered,
    required this.totalTimeSeconds,
    required this.categoryName,
  });

  int get accuracyPercentage {
    if (totalQuestions == 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round();
  }

  String get formattedTime {
    final minutes = (totalTimeSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalTimeSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get isPassed => accuracyPercentage >= 50;
  bool get isHighScorer => accuracyPercentage >= 80;
}
