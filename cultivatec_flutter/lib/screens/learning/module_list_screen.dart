import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/data/static/stem_content.dart';
import 'package:cultivatec_flutter/core/widgets/themed_background.dart';
import 'package:cultivatec_flutter/screens/learning/quiz_screen.dart';
import 'package:cultivatec_flutter/screens/robot/circuit_builder_screen.dart';
import 'package:cultivatec_flutter/screens/robot/block_coding_screen.dart';

// We keep this class signature to avoid breaking any other rogue imports,
// but it is no longer used in the new STEM Area flow.
class ModuleListScreen extends StatelessWidget {
  const ModuleListScreen({super.key, int? worldIndex, Map? userScores});
  @override
  Widget build(BuildContext context) => const Scaffold();
}

/// Generic Lesson Screen - shows interactive lesson content (cards)
class LessonScreen extends StatefulWidget {
  final String stemAreaId;
  final String moduleId; // This is the lesson.id

  const LessonScreen({
    super.key,
    required this.stemAreaId,
    required this.moduleId,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final area = areaById(widget.stemAreaId);
    final lesson = area.lessons.firstWhere((l) => l.id == widget.moduleId, orElse: () => area.lessons.first);

    return Scaffold(
      body: ThemedBackground(
        color: area.color,
        icon: area.icon,
        child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, area, lesson),
            
            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  lesson.cards.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == index ? area.color : AppTheme.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            
            // Cards Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (idx) {
                  setState(() => _currentIndex = idx);
                },
                itemCount: lesson.cards.length,
                itemBuilder: (context, idx) {
                  final card = lesson.cards[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _buildLessonCard(card, area),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
                },
              ),
            ),

            // Navigation Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.bgSurface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppTheme.shadowSm,
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: AppTheme.textSecondary),
                      ),
                    ),
                  
                  if (_currentIndex > 0) const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < lesson.cards.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutCubic,
                          );
                        } else if (_currentIndex == lesson.cards.length - 1 && lesson.practiceType != PracticeType.none) {
                          // Go to practice first, but stay on this index for when they return
                          if (lesson.practiceType == PracticeType.electronics) {
                            Navigator.of(context).push(AppTheme.smoothRoute(CircuitBuilderScreen(challengeId: lesson.challengeId)));
                          } else if (lesson.practiceType == PracticeType.coding) {
                            Navigator.of(context).push(AppTheme.smoothRoute(BlockCodingScreen(challengeId: lesson.challengeId ?? 'c1')));
                          }
                          // Wait for them to return, then move to Quiz step (virtually advancing current index)
                          setState(() {
                             _currentIndex++; // advance to virtual "Quiz" card index
                          });
                        } else {
                          // Go to Quiz
                          Navigator.of(context).pushReplacement(
                            AppTheme.smoothRoute(QuizScreen(
                              moduleId: lesson.id,
                              worldKey: area.id, // using area.id instead of 'w1'
                              title: lesson.title,
                              questions: lesson.questions, // pass the lesson's questions
                            )),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: area.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        elevation: 8,
                        shadowColor: area.color.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentIndex < lesson.cards.length - 1 
                                ? 'Siguiente' 
                                : (_currentIndex == lesson.cards.length - 1 && lesson.practiceType != PracticeType.none) 
                                    ? '¡Ir a Práctica!' 
                                    : '¡Empezar Quiz!',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          if (_currentIndex >= lesson.cards.length - 1) ...[
                            const SizedBox(width: 8),
                            Icon(_currentIndex == lesson.cards.length - 1 && lesson.practiceType != PracticeType.none ? Icons.science_rounded : Icons.rocket_launch_rounded),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(LessonCard card, StemArea area) {
    IconData icon;
    String label;
    Color cardColor;
    
    switch (card.type) {
      case CardType.concept:
        icon = Icons.lightbulb_rounded;
        label = 'Concepto';
        cardColor = area.color;
        break;
      case CardType.example:
        icon = Icons.visibility_rounded;
        label = 'Ejemplo';
        cardColor = AppTheme.accentGreen;
        break;
      case CardType.funFact:
        icon = Icons.star_rounded;
        label = 'Dato Curioso';
        cardColor = AppTheme.accentGold;
        break;
      case CardType.tip:
        icon = Icons.tips_and_updates_rounded;
        label = 'Tip';
        cardColor = AppTheme.accentOrange;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            // Colored header block
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: cardColor.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cardColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: cardColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      card.body,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppTheme.textSecondary,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StemArea area, Lesson lesson) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.bgSecondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.close_rounded, color: AppTheme.textPrimary, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: area.color,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
