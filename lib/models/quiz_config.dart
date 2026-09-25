class QuizConfig {
  final int categoryId;
  final String categoryName;
  final int amount;
  final String difficulty; // 'any', 'easy', 'medium', 'hard'
  final String type; // 'any', 'multiple', 'boolean'

  const QuizConfig({
    required this.categoryId,
    required this.categoryName,
    this.amount = 10,
    this.difficulty = 'any',
    this.type = 'any',
  });

  QuizConfig copyWith({
    int? categoryId,
    String? categoryName,
    int? amount,
    String? difficulty,
    String? type,
  }) {
    return QuizConfig(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'difficulty': difficulty,
      'type': type,
    };
  }

  factory QuizConfig.fromJson(Map<String, dynamic> json) {
    return QuizConfig(
      categoryId: json['categoryId'] as int? ?? 9,
      categoryName: json['categoryName'] as String? ?? 'General Knowledge',
      amount: json['amount'] as int? ?? 10,
      difficulty: json['difficulty'] as String? ?? 'any',
      type: json['type'] as String? ?? 'any',
    );
  }

  String get difficultyLabel {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return 'Any Difficulty';
    }
  }

  String get typeLabel {
    switch (type) {
      case 'multiple':
        return 'Multiple Choice';
      case 'boolean':
        return 'True / False';
      default:
        return 'Any Type';
    }
  }
}
