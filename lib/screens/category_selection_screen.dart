import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/category_card.dart';
import '../widgets/shimmer_loading.dart';
import 'quiz_config_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      if (!provider.categoriesLoaded) {
        provider.fetchCategories();
      }
    });
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
            constraints: const BoxConstraints(maxWidth: 800),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, _) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header Section (Matches Figma Photo 2)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Quizzical',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'choose a category to focus on:',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // Error Banner with Retry
                    if (quizProvider.categoryError != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.incorrectRedLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.incorrectRedDark.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.wifi_off_rounded,
                                  color: AppColors.incorrectRedDark,
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  quizProvider.categoryError!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => quizProvider.fetchCategories(forceRefresh: true),
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Retry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTeal,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Loading State: Skeleton Shimmer Grid
                    if (quizProvider.isLoadingCategories)
                      const SliverToBoxAdapter(
                        child: CategorySkeletonGrid(count: 8),
                      ),

                    // Loaded Categories Grid
                    if (!quizProvider.isLoadingCategories &&
                        quizProvider.categories.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = constraints.crossAxisExtent > 600 ? 3 : 2;

                            return SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.95,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final category = quizProvider.categories[index];
                                  return CategoryCard(
                                    category: category,
                                    index: index,
                                    onTap: () {
                                      quizProvider.selectCategory(category.id, category.name);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => QuizConfigScreen(
                                            categoryId: category.id,
                                            categoryName: category.name,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                childCount: quizProvider.categories.length,
                              ),
                            );
                          },
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
