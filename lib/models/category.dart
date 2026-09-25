import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TriviaCategory {
  final int id;
  final String name;

  const TriviaCategory({
    required this.id,
    required this.name,
  });

  factory TriviaCategory.fromJson(Map<String, dynamic> json) {
    return TriviaCategory(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// Short, clean name matching Figma style (e.g. "Entertainment: Books" -> "Books")
  String get displayName {
    if (name.startsWith('Entertainment: ')) {
      return name.replaceFirst('Entertainment: ', '');
    }
    if (name.startsWith('Science: ')) {
      return name.replaceFirst('Science: ', '');
    }
    return name;
  }

  /// Icon matching the category topic
  IconData get icon {
    final lower = name.toLowerCase();
    if (lower.contains('book')) return Icons.menu_book_rounded;
    if (lower.contains('film')) return Icons.movie_rounded;
    if (lower.contains('music') && !lower.contains('theatre')) return Icons.headphones_rounded;
    if (lower.contains('theatre') || lower.contains('musical')) return Icons.theater_comedy_rounded;
    if (lower.contains('television') || lower.contains('tv')) return Icons.tv_rounded;
    if (lower.contains('video game')) return Icons.sports_esports_rounded;
    if (lower.contains('board game')) return Icons.casino_rounded;
    if (lower.contains('nature') || lower.contains('science & nature')) return Icons.biotech_rounded;
    if (lower.contains('computer')) return Icons.laptop_chromebook_rounded;
    if (lower.contains('mathematics') || lower.contains('math')) return Icons.calculate_rounded;
    if (lower.contains('gadget')) return Icons.devices_rounded;
    if (lower.contains('myth')) return Icons.auto_awesome_rounded;
    if (lower.contains('sport')) return Icons.sports_soccer_rounded;
    if (lower.contains('geography')) return Icons.explore_rounded;
    if (lower.contains('history')) return Icons.history_edu_rounded;
    if (lower.contains('politic')) return Icons.account_balance_rounded;
    if (lower.contains('art')) return Icons.palette_rounded;
    if (lower.contains('celebrity') || lower.contains('celebrities')) return Icons.star_rounded;
    if (lower.contains('animal')) return Icons.pets_rounded;
    if (lower.contains('vehicle')) return Icons.directions_car_rounded;
    if (lower.contains('comic')) return Icons.menu_book_outlined;
    if (lower.contains('anime') || lower.contains('manga')) return Icons.animation_rounded;
    if (lower.contains('cartoon')) return Icons.smart_toy_rounded;
    return Icons.lightbulb_outline_rounded;
  }

  /// Card pastel color for this category
  Color getCardColor(int index) {
    return AppColors.getPastelColor(index);
  }
}
