import 'package:html_unescape/html_unescape.dart';

class TriviaQuestion {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  String? selectedAnswer;
  bool isTimedOut;

  TriviaQuestion({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.allAnswers,
    this.selectedAnswer,
    this.isTimedOut = false,
  });

  bool get isAnswered => selectedAnswer != null || isTimedOut;
  bool get isCorrect => selectedAnswer != null && selectedAnswer == correctAnswer;

  factory TriviaQuestion.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    final rawQuestion = json['question'] as String? ?? '';
    final rawCorrect = json['correct_answer'] as String? ?? '';
    final rawIncorrect = (json['incorrect_answers'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final decodedQuestion = unescape.convert(rawQuestion);
    final decodedCorrect = unescape.convert(rawCorrect);
    final decodedIncorrect = rawIncorrect.map((e) => unescape.convert(e)).toList();

    // Prepare combined and shuffled answers
    final answers = <String>[decodedCorrect, ...decodedIncorrect];
    if (json['type'] == 'boolean') {
      // For boolean, keep standard True / False order
      answers.sort((a, b) => b.compareTo(a)); // True, then False
    } else {
      // Multiple choice: shuffle once
      answers.shuffle();
    }

    return TriviaQuestion(
      category: unescape.convert(json['category'] as String? ?? ''),
      type: json['type'] as String? ?? 'multiple',
      difficulty: json['difficulty'] as String? ?? 'easy',
      question: decodedQuestion,
      correctAnswer: decodedCorrect,
      incorrectAnswers: decodedIncorrect,
      allAnswers: answers,
    );
  }
}
