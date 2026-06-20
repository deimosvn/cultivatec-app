import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/data/static/stem_content.dart';
import 'package:cultivatec_flutter/core/widgets/themed_background.dart';
import 'package:cultivatec_flutter/screens/learning/module_list_screen.dart';
import 'package:cultivatec_flutter/screens/robot/circuit_builder_screen.dart';

class WorldMapScreen extends StatelessWidget {
  final String stemAreaId;
  final VoidCallback onBack;
  final Map<String, dynamic> userScores;
  final int friendsCount;

  const WorldMapScreen({
    super.key,
    required this.stemAreaId,
    required this.onBack,
    required this.userScores,
    required this.friendsCount,
  });

  @override
  Widget build(BuildContext context) {
    final area = areaById(stemAreaId);

    return Scaffold(
      body: ThemedBackground(
        color: area.color,
        icon: area.icon,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, area),
              // Gamified Path Map
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  itemCount: area.lessons.length,
                  itemBuilder: (context, idx) {
                    final lesson = area.lessons[idx];
                    
                    // Logic to unlock linearly
                    final isFirst = idx == 0;
                    bool previousCompleted = false;
                    if (!isFirst) {
                      final prevLesson = area.lessons[idx - 1];
                      final prevKey = '${area.id}_${prevLesson.id}';
                      final prevScore = userScores[prevKey];
                      if (prevScore != null && prevScore is Map && prevScore['completed'] == true) {
                        previousCompleted = true;
                      }
                    }
                    final unlocked = isFirst || previousCompleted;

                    bool currentCompleted = false;
                    final currentKey = '${area.id}_${lesson.id}';
                    final currentScore = userScores[currentKey];
                    if (currentScore != null && currentScore is Map && currentScore['completed'] == true) {
                      currentCompleted = true;
                    }

                    final isNextUnlocked = currentCompleted; // Simplification

                    return _PathNode(
                      lesson: lesson,
                      area: area,
                      index: idx,
                      unlocked: unlocked,
                      isCompleted: currentCompleted,
                      isNextUnlocked: isNextUnlocked,
                      isLast: idx == area.lessons.length - 1,
                      onTap: unlocked
                          ? () => Navigator.of(context).push(
                                AppTheme.smoothRoute(LessonScreen(
                                    stemAreaId: area.id,
                                    moduleId: lesson.id,
                                )),
                              )
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Debes completar la lección anterior para desbloquear esta.'),
                                  backgroundColor: AppTheme.textPrimary,
                                ),
                              );
                            },
                    ).animate().fadeIn(delay: (80 * idx).ms, duration: 400.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StemArea area) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppTheme.shadowSm,
              ),
              child: const Icon(Icons.arrow_back_rounded, color: AppTheme.textPrimary, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              area.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          if (area.id == 'electronica')
            // Quick access to the electronics practice (Simulador)
            GestureDetector(
              onTap: () => Navigator.of(context).push(AppTheme.smoothRoute(const CircuitBuilderScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: AppTheme.accentCyan,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppTheme.accentCyan.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.memory_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('Práctica', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PathNode extends StatelessWidget {
  final Lesson lesson;
  final StemArea area;
  final int index;
  final bool unlocked;
  final bool isCompleted;
  final bool isNextUnlocked;
  final bool isLast;
  final VoidCallback? onTap;

  const _PathNode({
    required this.lesson,
    required this.area,
    required this.index,
    required this.unlocked,
    required this.isCompleted,
    required this.isNextUnlocked,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Zig-zag calculation
    const double maxOffset = 100.0;
    final double horizontalOffset = math.sin(index * 1.0) * maxOffset;
    
    final bool isActive = unlocked && !isCompleted;
    
    final Color mainColor = unlocked ? area.color : AppTheme.borderColor;
    final Color bgColor = unlocked ? area.color.withValues(alpha: 0.1) : AppTheme.bgSecondary;
    
    return SizedBox(
      height: 150, // Fixed height for consistent path drawing
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // The connecting path line to the next node
          if (!isLast)
            Positioned(
              top: 75, // Start from center of current node
              bottom: -75, // End at center of next node
              child: CustomPaint(
                size: const Size(300, 150),
                painter: _PathPainter(
                  startX: horizontalOffset,
                  endX: math.sin((index + 1) * 1.0) * maxOffset,
                  color: isNextUnlocked ? area.color : AppTheme.borderColor,
                  isUnlocked: isNextUnlocked,
                ),
              ),
            ),
            
          // The node itself
          Transform.translate(
            offset: Offset(horizontalOffset, 0),
            child: GestureDetector(
              onTap: onTap,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Shadow/Glow
                  if (isActive)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: mainColor.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 1.seconds),
                    
                  // Main Bubble
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bgColor,
                      border: Border.all(
                        color: mainColor,
                        width: isActive ? 4 : 2,
                      ),
                      boxShadow: isActive ? [] : [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        lesson.emoji,
                        style: TextStyle(
                          fontSize: 36,
                          color: unlocked ? null : AppTheme.textMuted.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  
                  // Title Badge
                  Positioned(
                    bottom: -15,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.bgSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: mainColor.withValues(alpha: 0.5), width: 1.5),
                        boxShadow: AppTheme.shadowSm,
                      ),
                      child: Text(
                        lesson.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: unlocked ? AppTheme.textPrimary : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),
                  
                  // Completed Checkmark
                  if (isCompleted)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981), // Success green
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 16),
                      ).animate().scale(curve: Curves.easeOutBack),
                    ),
                    
                  // Lock Icon
                  if (!unlocked)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.bgSecondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: const Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: 14),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  final double startX;
  final double endX;
  final Color color;
  final bool isUnlocked;

  _PathPainter({
    required this.startX,
    required this.endX,
    required this.color,
    required this.isUnlocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    
    // Draw a curved line between the two nodes
    path.moveTo(size.width / 2 + startX, 0);
    
    // Control points for a smooth Bezier curve
    path.cubicTo(
      size.width / 2 + startX, size.height / 2, // Control 1
      size.width / 2 + endX, size.height / 2,   // Control 2
      size.width / 2 + endX, size.height,       // End point
    );
    
    // If not unlocked, draw a dashed line instead
    if (!isUnlocked) {
      // Draw a lighter solid line for locked paths
      paint.color = AppTheme.borderColor.withValues(alpha: 0.5);
      paint.strokeWidth = 10;
    }

    canvas.drawPath(path, paint);
    
    // Add inner highlight for 3D tube effect if unlocked
    if (isUnlocked) {
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.3)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) {
    return oldDelegate.startX != startX || oldDelegate.endX != endX || oldDelegate.color != color || oldDelegate.isUnlocked != isUnlocked;
  }
}
