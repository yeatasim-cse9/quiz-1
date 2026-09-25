import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnswerOptionTile extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final bool isActualCorrect;
  final VoidCallback onTap;

  const AnswerOptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.isActualCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.optionDefaultBg;
    Color borderColor = AppColors.optionDefaultBorder;
    Widget trailingIcon = const Icon(
      Icons.radio_button_unchecked,
      color: Color(0xFF2D3748),
      size: 24,
    );

    if (isAnswered) {
      if (isSelected) {
        if (isCorrect) {
          backgroundColor = AppColors.correctGreenBg;
          borderColor = const Color(0xFF81C784);
          trailingIcon = const Icon(
            Icons.check_circle,
            color: Color(0xFF004D40),
            size: 24,
          );
        } else {
          backgroundColor = AppColors.incorrectRedBg;
          borderColor = const Color(0xFFE57373);
          trailingIcon = const Icon(
            Icons.cancel,
            color: Color(0xFFD32F2F),
            size: 24,
          );
        }
      } else if (isActualCorrect) {
        backgroundColor = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF81C784);
        trailingIcon = const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF2E7D32),
          size: 24,
        );
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isAnswered && isActualCorrect) ? 1.8 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                trailingIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
