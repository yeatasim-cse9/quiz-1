import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo_project/models/category.dart';
import 'package:demo_project/models/question.dart';
import 'package:demo_project/models/quiz_config.dart';
import 'package:demo_project/models/quiz_result.dart';
import 'package:demo_project/providers/quiz_provider.dart';
import 'package:demo_project/screens/welcome_screen.dart';
import 'package:demo_project/screens/quiz_config_screen.dart';
import 'package:demo_project/screens/quiz_screen.dart';
import 'package:demo_project/screens/results_screen.dart';
import 'package:demo_project/theme/app_theme.dart';

void main() {
  group('Model Unit Tests', () {
    test('TriviaCategory parses json correctly and formats displayName', () {
      final json = {'id': 10, 'name': 'Entertainment: Books'};
      final category = TriviaCategory.fromJson(json);

      expect(category.id, 10);
      expect(category.displayName, 'Books');
      expect(category.icon, Icons.menu_book_rounded);
    });

    test('TriviaQuestion decodes HTML entities and manages options', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'Is 5 &gt; 3 &amp; &quot;yes&quot;?',
        'correct_answer': 'True &#039;sure&#039;',
        'incorrect_answers': ['False', 'Maybe', 'Never']
      };

      final question = TriviaQuestion.fromJson(json);
      expect(question.question, 'Is 5 > 3 & "yes"?');
      expect(question.correctAnswer, "True 'sure'");
      expect(question.allAnswers.length, 4);
      expect(question.allAnswers.contains("True 'sure'"), true);
      expect(question.isAnswered, false);
    });

    test('QuizConfig handles defaults, copyWith and serialization', () {
      const config = QuizConfig(
        categoryId: 9,
        categoryName: 'General Knowledge',
        amount: 10,
        difficulty: 'any',
        type: 'any',
      );

      final updated = config.copyWith(amount: 25, difficulty: 'hard');
      expect(updated.amount, 25);
      expect(updated.difficulty, 'hard');
      expect(updated.difficultyLabel, 'Hard');

      final json = updated.toJson();
      final parsed = QuizConfig.fromJson(json);
      expect(parsed.amount, 25);
      expect(parsed.categoryName, 'General Knowledge');
    });

    test('QuizResult calculates accuracy and formatting', () {
      const result = QuizResult(
        totalQuestions: 10,
        correctAnswers: 8,
        incorrectAnswers: 2,
        unanswered: 0,
        totalTimeSeconds: 65,
        categoryName: 'General Knowledge',
      );

      expect(result.accuracyPercentage, 80);
      expect(result.formattedTime, '01:05');
      expect(result.isPassed, true);
      expect(result.isHighScorer, true);
    });
  });

  group('Screen & Flow Widget Tests', () {
    testWidgets('WelcomeScreen displays title and navigates to Category screen',
        (WidgetTester tester) async {
      final provider = QuizProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const WelcomeScreen(),
          ),
        ),
      );

      expect(find.text('Quizzical'), findsOneWidget);
      expect(find.text('Challenge your mind with trivia'), findsOneWidget);
      expect(find.text('GET STARTED'), findsOneWidget);

      await tester.tap(find.text('GET STARTED'));
      await tester.pumpAndSettle();

      // Should now be on CategorySelectionScreen
      expect(find.text('choose a category to focus on:'), findsOneWidget);
    });

    testWidgets('QuizConfigScreen displays controls and handles inputs',
        (WidgetTester tester) async {
      final provider = QuizProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizConfigScreen(
              categoryId: 9,
              categoryName: 'General Knowledge',
            ),
          ),
        ),
      );

      expect(find.text('Configuration'), findsOneWidget);
      expect(find.text('General Knowledge'), findsOneWidget);
      expect(find.text('Number of Questions'), findsOneWidget);
      expect(find.text('Difficulty Level'), findsOneWidget);
      expect(find.text('Question Type'), findsOneWidget);
      expect(find.text('START'), findsOneWidget);
    });

    testWidgets('QuizScreen renders question, answers, and handles answer selection',
        (WidgetTester tester) async {
      final provider = QuizProvider();

      // Pre-populate with sample questions
      final testQuestion = TriviaQuestion(
        category: 'General Knowledge',
        type: 'multiple',
        difficulty: 'easy',
        question: 'What is the capital of France?',
        correctAnswer: 'Paris',
        incorrectAnswers: ['London', 'Berlin', 'Madrid'],
        allAnswers: ['London', 'Paris', 'Berlin', 'Madrid'],
      );

      // Force provider questions
      provider.questions.addAll([testQuestion]);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const QuizScreen(),
          ),
        ),
      );

      expect(find.text('1/1'), findsOneWidget);
      expect(find.text('What is the capital of France?'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('London'), findsOneWidget);

      // Select 'Paris'
      await tester.tap(find.text('Paris'));
      await tester.pumpAndSettle();

      expect(provider.score, 1);
      expect(find.text('View Results'), findsOneWidget);

      provider.cancelTimers();
    });

    testWidgets('ResultsScreen displays score badge and Play Again button',
        (WidgetTester tester) async {
      final provider = QuizProvider();

      final testQuestion = TriviaQuestion(
        category: 'General Knowledge',
        type: 'multiple',
        difficulty: 'easy',
        question: 'Sample?',
        correctAnswer: 'Yes',
        incorrectAnswers: ['No'],
        allAnswers: ['Yes', 'No'],
        selectedAnswer: 'Yes',
      );
      provider.questions.add(testQuestion);

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ResultsScreen(),
          ),
        ),
      );

      expect(find.text('Congratulation'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('PLAY AGAIN'), findsOneWidget);
      expect(find.text('Choose New Category'), findsOneWidget);
    });
  });
}
