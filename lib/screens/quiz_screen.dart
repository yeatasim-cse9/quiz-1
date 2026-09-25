import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/timer_widget.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  void _onExitPressed() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit Quiz?',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit? Your current progress will be lost.',
          style: TextStyle(fontFamily: 'Outfit'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.incorrectRedDark,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              final provider = Provider.of<QuizProvider>(context, listen: false);
              provider.cancelTimers();
              Navigator.of(context).pop();
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _onNextPressed(QuizProvider quizProvider) {
    if (quizProvider.isLastQuestion) {
      quizProvider.cancelTimers();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ResultsScreen(),
        ),
      );
    } else {
      quizProvider.nextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onExitPressed();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Consumer<QuizProvider>(
            builder: (context, provider, _) {
              final currentNum = provider.currentIndex + 1;
              final totalNum = provider.questions.length;
              return Text(
                '$currentNum/$totalNum',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              );
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: _onExitPressed,
              icon: const Text(
                'EXIT',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              label: const Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.textDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: Consumer<QuizProvider>(
              builder: (context, provider, _) {
                return LinearProgressIndicator(
                  value: provider.questionProgress,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 5,
                );
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Consumer<QuizProvider>(
                builder: (context, provider, _) {
                  final question = provider.currentQuestion;

                  if (question == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      children: [
                        // Timer & Live Category Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                question.difficulty.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            QuizTimerWidget(
                              secondsRemaining: provider.questionTimeRemaining,
                              totalSeconds: QuizProvider.questionDuration,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Question Card (Matches Figma photo 4 & 5)
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 180),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                question.question,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.35,
                                ),
                              ),
                              if (question.isTimedOut && question.selectedAnswer == null) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.incorrectRedLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Time Expired!',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.incorrectRedDark,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Shuffled Answer Options
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: question.allAnswers.length,
                            itemBuilder: (context, index) {
                              final answer = question.allAnswers[index];
                              final isSelected = question.selectedAnswer == answer;
                              final isActualCorrect = answer == question.correctAnswer;

                              return AnswerOptionTile(
                                text: answer,
                                isSelected: isSelected,
                                isCorrect: question.isCorrect,
                                isAnswered: question.isAnswered,
                                isActualCorrect: isActualCorrect,
                                onTap: () => provider.selectAnswer(answer),
                              );
                            },
                          ),
                        ),

                        // Bottom Action CTA: Next or View Results
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: question.isAnswered
                                ? () => _onNextPressed(provider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryTeal,
                              disabledBackgroundColor: AppColors.primaryTeal.withValues(alpha: 0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              provider.isLastQuestion ? 'View Results' : 'Next',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
