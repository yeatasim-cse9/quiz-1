import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_config.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_illustrations.dart';
import 'quiz_screen.dart';

class QuizConfigScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const QuizConfigScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizConfigScreen> createState() => _QuizConfigScreenState();
}

class _QuizConfigScreenState extends State<QuizConfigScreen> {
  late int _amount;
  late String _difficulty;
  late String _type;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);
    _amount = provider.config.amount.clamp(1, 50);
    _difficulty = provider.config.difficulty;
    _type = provider.config.type;
  }

  void _onStartPressed() async {
    final provider = Provider.of<QuizProvider>(context, listen: false);

    provider.updateConfig(
      QuizConfig(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
        amount: _amount,
        difficulty: _difficulty,
        type: _type,
      ),
    );

    final success = await provider.startQuiz();
    if (success && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const QuizScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(''),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Illustration (Figma Photo 3)
                      const ConfigArtworkWidget(size: 160),
                      const SizedBox(height: 16),

                      // Title & Subtitles
                      const Text(
                        'Quizzical',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Configuration',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.categoryName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Error Banner if Question fetch failed
                      if (quizProvider.questionError != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.incorrectRedLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.incorrectRedDark.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: AppColors.incorrectRedDark,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Fetch Error',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.incorrectRedDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                quizProvider.questionError!,
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Number of Questions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Number of Questions',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Select 1–50',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$_amount',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.blue.shade600,
                              inactiveTrackColor: Colors.blue.shade100,
                              thumbColor: Colors.blue.shade700,
                              overlayColor: Colors.blue.withValues(alpha: 0.2),
                              trackHeight: 5,
                            ),
                            child: Slider(
                              value: _amount.toDouble(),
                              min: 1,
                              max: 50,
                              divisions: 49,
                              label: '$_amount',
                              onChanged: (val) {
                                setState(() {
                                  _amount = val.round();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Difficulty Level Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Difficulty Level',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _difficulty,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.surfaceBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.surfaceBorder),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                              DropdownMenuItem(value: 'easy', child: Text('Easy')),
                              DropdownMenuItem(value: 'medium', child: Text('Medium')),
                              DropdownMenuItem(value: 'hard', child: Text('Hard')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _difficulty = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Question Type Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Question Type',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: _type,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.surfaceBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: AppColors.surfaceBorder),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'any', child: Text('Any Type')),
                              DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                              DropdownMenuItem(value: 'boolean', child: Text('True / False')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _type = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),

                      // START Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: quizProvider.isLoadingQuestions ? null : _onStartPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryTeal,
                            side: const BorderSide(color: AppColors.primaryTeal, width: 1.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: quizProvider.isLoadingQuestions
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTeal),
                                  ),
                                )
                              : const Text(
                                  'START',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
