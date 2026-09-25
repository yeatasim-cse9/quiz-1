import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/confetti_animation.dart';
import '../widgets/custom_illustrations.dart';
import 'category_selection_screen.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<int> _countAnimation;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final targetAccuracy = quizProvider.quizResult.accuracyPercentage;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
      ),
    );

    _countAnimation = IntTween(begin: 0, end: targetAccuracy).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _shareResult(BuildContext context, String summary) {
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Color(0xFF00E676), size: 20),
            SizedBox(width: 10),
            Text(
              'Result copied to clipboard!',
              style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReviewModal(BuildContext context, List<TriviaQuestion> questions) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Review Answers',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: questions.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final isCorrect = q.isCorrect;
                    final isTimedOut = q.isTimedOut && q.selectedAnswer == null;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? const Color(0xFFF1F8F5)
                            : const Color(0xFFFFF5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFFA8E6CF)
                              : const Color(0xFFFFCDD2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFD32F2F),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Q${index + 1}',
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q.question,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // User answer
                          Row(
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 16,
                                color: isCorrect
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFFD32F2F),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isTimedOut
                                      ? 'Your Answer: Time Expired'
                                      : 'Your Answer: ${q.selectedAnswer ?? "None"}',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isCorrect
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFD32F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (!isCorrect) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 16,
                                  color: Color(0xFF2E7D32),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Correct Answer: ${q.correctAnswer}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final result = quizProvider.quizResult;
    final isPassed = result.isPassed;

    final shareText =
        '🏆 Quizzical Trivia\nI scored ${result.correctAnswers}/${result.totalQuestions} (${result.accuracyPercentage}%) in ${result.categoryName}!\nTime: ${result.formattedTime}';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          quizProvider.resetQuiz();
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: CelebrationConfettiOverlay(
        isEnabled: isPassed,
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded, color: AppColors.textDark),
                tooltip: 'Share Score',
                onPressed: () => _shareResult(context, shareText),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top 3D Illustration (Party Popper in photo 6 or Settings in photo 7)
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          );
                        },
                        child: isPassed
                            ? Image.asset('assets/images/image.png', height: 230, fit: BoxFit.contain)
                            : const ConfigArtworkWidget(size: 190),
                      ),
                      const SizedBox(height: 18),

                      // Header Title (Figma Photo 6: "Congratulation", Photo 7: "Keep Trying!")
                      Text(
                        isPassed ? 'Congratulation' : 'Keep Trying!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Double-layer Pill Badge with Live Counting Animation (Matches photo 6 & 7)
                      AnimatedBuilder(
                        animation: _countAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: isPassed
                                  ? const Color(0xFFD7F5E7).withValues(alpha: 0.65)
                                  : const Color(0xFFFFEBEE).withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isPassed
                                    ? const Color(0xFFA8E6CF).withValues(alpha: 0.8)
                                    : const Color(0xFFFFCDD2).withValues(alpha: 0.8),
                                width: 1.5,
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 56,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isPassed
                                    ? const Color(0xFF75DBA2)
                                    : const Color(0xFFFF4118),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isPassed
                                            ? const Color(0xFF75DBA2)
                                            : const Color(0xFFFF4118))
                                        .withValues(alpha: 0.3),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${_countAnimation.value}%',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: isPassed
                                      ? const Color(0xFF1B3D2F)
                                      : Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Motivational Subtext (Matches Figma copy)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          isPassed
                              ? "You've got a great foundation. Ready to try a different category?"
                              : "Don't give up! Practice makes perfect. Try again to improve your score",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Stats Card (Time, Correct, Incorrect, Speed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.surfaceBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.timer_outlined,
                              label: 'Time Taken',
                              value: result.formattedTime,
                              color: Colors.blue.shade700,
                            ),
                            Container(
                              height: 38,
                              width: 1,
                              color: AppColors.surfaceBorder,
                            ),
                            _buildStatItem(
                              icon: Icons.check_circle_outline_rounded,
                              label: 'Correct',
                              value: '${result.correctAnswers}/${result.totalQuestions}',
                              color: const Color(0xFF2E7D32),
                            ),
                            Container(
                              height: 38,
                              width: 1,
                              color: AppColors.surfaceBorder,
                            ),
                            _buildStatItem(
                              icon: Icons.speed_rounded,
                              label: 'Avg Pace',
                              value: result.totalQuestions > 0
                                  ? '${(result.totalTimeSeconds / result.totalQuestions).toStringAsFixed(1)}s'
                                  : '0s',
                              color: Colors.deepPurple.shade600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Review Answers Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _showReviewModal(
                            context,
                            quizProvider.questions,
                          ),
                          icon: const Icon(
                            Icons.fact_check_outlined,
                            size: 20,
                            color: AppColors.primaryTeal,
                          ),
                          label: const Text(
                            'Review Questions & Answers',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primaryTeal,
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Primary CTA: "PLAY AGAIN" (Matches Figma photo 6 & 7)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await quizProvider.restartQuiz();
                            if (success && context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const QuizScreen(),
                                ),
                              );
                            } else if (context.mounted) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: AppColors.primaryTeal.withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'PLAY AGAIN',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Secondary CTA: "Choose New Category"
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: TextButton(
                          onPressed: () {
                            quizProvider.resetQuiz();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const CategorySelectionScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text(
                            'Choose New Category',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
