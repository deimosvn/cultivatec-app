import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/providers/auth_provider.dart';
import 'package:cultivatec_flutter/core/widgets/themed_background.dart';
import 'package:cultivatec_flutter/data/static/stem_content.dart';
import 'package:cultivatec_flutter/core/widgets/robot_avatar.dart';
import 'package:cultivatec_flutter/data/models/robot_config.dart';
import 'package:cultivatec_flutter/data/services/tournament_service.dart';
import 'package:cultivatec_flutter/screens/tournaments/league_leaderboard_screen.dart';

class QuizScreen extends StatefulWidget {
  final String moduleId;
  final String worldKey; // e.g. 'w1'
  final List<QuizQuestionData> questions;
  final String title;

  /// When set, this quiz is a tournament round: the result is submitted to the
  /// weekly league for this STEM category and the leaderboard is offered.
  final String? leagueCategoryId;

  /// Optional: called once with the final percentage when the quiz finishes
  /// (used by friend duels to record the player's score).
  final void Function(int percentage, int correct, int total)? onResult;

  const QuizScreen({
    super.key,
    required this.moduleId,
    required this.worldKey,
    required this.questions,
    required this.title,
    this.leagueCategoryId,
    this.onResult,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class QuizQuestionData {
  final String id;
  final String question;
  final List<String> options;
  final int correct;
  final String explanation;

  const QuizQuestionData({
    required this.id,
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}

class _QuizScreenState extends State<QuizScreen> {
  final DateTime _startedAt = DateTime.now();
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _answered = false;
  int _correctCount = 0;
  int _streak = 0;
  int _maxStreak = 0;
  bool _finished = false;
  final List<bool> _results = [];

  QuizQuestionData get _currentQuestion => widget.questions[_currentIndex];
  int get _totalQuestions => widget.questions.length;

  void _selectAnswer(int idx) {
    if (_answered) return;
    setState(() {
      _selectedAnswer = idx;
      _answered = true;
      final isCorrect = idx == _currentQuestion.correct;
      _results.add(isCorrect);
      if (isCorrect) {
        _correctCount++;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
      } else {
        _streak = 0;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _totalQuestions) {
      _finishQuiz();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
    });
  }

  void _finishQuiz() {
    setState(() => _finished = true);

    // Calculate score and save
    final percentage = (_correctCount / _totalQuestions * 100).round();
    final stars = percentage >= 90 ? 3 : (percentage >= 70 ? 2 : (percentage >= 50 ? 1 : 0));
    final xp = _correctCount * 10 + (_maxStreak >= 3 ? 15 : 0) + (percentage == 100 ? 25 : 0);
    final isPerfect = percentage == 100;

    // Friend-duel hook: report the score to whoever launched this quiz.
    widget.onResult?.call(percentage, _correctCount, _totalQuestions);

    final auth = context.read<AuthProvider>();
    auth.saveScore(
      '${widget.worldKey}_${widget.moduleId}',
      {
        'completed': true,
        'score': percentage,
        'stars': stars,
        'correctAnswers': _correctCount,
        'totalQuestions': _totalQuestions,
        'maxStreak': _maxStreak,
        'perfect': isPerfect,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );

    final isTournament = widget.leagueCategoryId != null;

    // Sync stats (tournament rounds count as quizzes/points, not as modules).
    auth.syncStats({
      'addPoints': xp,
      'addModulesCompleted': isTournament ? 0 : 1,
      'addQuizzesCompleted': 1,
      'addPerfectQuizzes': isPerfect ? 1 : 0,
    });

    // Tournament round: submit to the weekly league + unlock achievements.
    if (isTournament) {
      final timeMs = DateTime.now().difference(_startedAt).inMilliseconds;
      auth.unlockAchievement('tournament_first');
      if (isPerfect) auth.unlockAchievement('tournament_ace');
      TournamentService().submitLeagueScore(
        categoryId: widget.leagueCategoryId!,
        uid: auth.user?.uid ?? '',
        username: auth.profile?.username ?? 'Explorador',
        score: percentage,
        correct: _correctCount,
        total: _totalQuestions,
        timeMs: timeMs,
      );
    }
  }

  void _retryQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswer = null;
      _answered = false;
      _correctCount = 0;
      _streak = 0;
      _maxStreak = 0;
      _finished = false;
      _results.clear();
    });
  }

  RobotConfig get _robot =>
      context.watch<AuthProvider>().profile?.robotConfig ?? const RobotConfig();

  @override
  Widget build(BuildContext context) {
    final themeArea = areaById(widget.leagueCategoryId ?? widget.worldKey);
    if (widget.questions.isEmpty) {
      return Scaffold(
        body: ThemedBackground(
          color: themeArea.color,
          icon: themeArea.icon,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🚧', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text('Quiz no disponible',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                const SizedBox(height: 24),
                _PillButton(label: 'Volver', color: AppTheme.primaryBlue, onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: ThemedBackground(
        color: themeArea.color,
        icon: themeArea.icon,
        child: SafeArea(
          child: _finished ? _buildResults() : _buildQuestion(),
        ),
      ),
    );
  }

  // ==========================================================================
  // QUESTION
  // ==========================================================================
  Widget _buildQuestion() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar: close · progress · counter
          Row(
            children: [
              _RoundIconButton(icon: Icons.close_rounded, onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: ((_currentIndex + 1) / _totalQuestions).clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppTheme.accentGreen, Color(0xFF34D399)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _softShadow,
                ),
                child: Text('${_currentIndex + 1}/$_totalQuestions',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppTheme.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_streak >= 2)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: AppTheme.accentGold),
                    const SizedBox(width: 4),
                    Text('¡Racha de $_streak!',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                  ],
                ),
              ),
            ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 14),

          // Question card with robot mascot peeking over the corner
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: _softShadow,
                ),
                child: Text(
                  _currentQuestion.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
              Positioned(
                top: -34,
                right: 14,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: RobotAvatarWidget(config: _robot, size: 64),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: 0, end: -6, duration: 1600.ms, curve: Curves.easeInOut),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Options (chunky bubbles)
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 2, bottom: 8),
              itemCount: _currentQuestion.options.length,
              itemBuilder: (context, idx) => _buildOption(idx),
            ),
          ),

          // Explanation + Next
          if (_answered) ...[
            _buildExplanation().animate().fadeIn(duration: 200.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 10),
            _PillButton(
              label: _currentIndex + 1 >= _totalQuestions ? 'Ver resultados' : 'Siguiente',
              color: AppTheme.primaryBlue,
              icon: Icons.arrow_forward_rounded,
              onTap: _nextQuestion,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanation() {
    final isCorrect = _selectedAnswer == _currentQuestion.correct;
    final color = isCorrect ? AppTheme.accentGreen : AppTheme.accentRed;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 2),
        boxShadow: _softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded, color: color, size: 20),
              const SizedBox(width: 6),
              Text(isCorrect ? '¡Correcto!' : 'Incorrecto',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(_currentQuestion.explanation,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.35)),
        ],
      ),
    );
  }

  Widget _buildOption(int idx) {
    final isSelected = _selectedAnswer == idx;
    final isCorrect = idx == _currentQuestion.correct;

    Color bg = Colors.white;
    Color badgeBg = AppTheme.primaryBlue;
    Color textColor = AppTheme.textPrimary;
    Color shadowColor = Colors.black.withValues(alpha: 0.10);

    if (_answered) {
      if (isCorrect) {
        bg = AppTheme.accentGreen;
        badgeBg = Colors.white.withValues(alpha: 0.25);
        textColor = Colors.white;
        shadowColor = AppTheme.accentGreen.withValues(alpha: 0.4);
      } else if (isSelected && !isCorrect) {
        bg = AppTheme.accentRed;
        badgeBg = Colors.white.withValues(alpha: 0.25);
        textColor = Colors.white;
        shadowColor = AppTheme.accentRed.withValues(alpha: 0.4);
      } else {
        bg = Colors.white.withValues(alpha: 0.75);
        textColor = AppTheme.textMuted;
        badgeBg = AppTheme.textHint;
      }
    } else if (isSelected) {
      bg = AppTheme.primaryLight;
      badgeBg = Colors.white.withValues(alpha: 0.3);
      textColor = Colors.white;
      shadowColor = AppTheme.primaryBlue.withValues(alpha: 0.35);
    }

    final bubble = GestureDetector(
      onTap: () => _selectAnswer(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: shadowColor, blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + idx),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: (_answered || isSelected) ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                _currentQuestion.options[idx],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textColor, height: 1.25),
              ),
            ),
            if (_answered && isCorrect) const Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
            if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel_rounded, color: Colors.white, size: 24),
          ],
        ),
      ),
    );

    // Pop the correct answer when revealed.
    if (_answered && isCorrect) {
      return bubble.animate().scale(begin: const Offset(0.97, 0.97), end: const Offset(1, 1), duration: 280.ms, curve: Curves.easeOutBack);
    }
    return bubble;
  }

  // ==========================================================================
  // RESULTS
  // ==========================================================================
  Widget _buildResults() {
    final percentage = (_correctCount / _totalQuestions * 100).round();
    final stars = percentage >= 90 ? 3 : (percentage >= 70 ? 2 : (percentage >= 50 ? 1 : 0));
    final xp = _correctCount * 10 + (_maxStreak >= 3 ? 15 : 0) + (percentage == 100 ? 25 : 0);
    final ringColor = percentage >= 70 ? AppTheme.accentGreen : (percentage >= 50 ? AppTheme.accentGold : AppTheme.accentRed);
    final title = percentage >= 90
        ? '¡Excelente!'
        : (percentage >= 70 ? '¡Muy bien!' : (percentage >= 50 ? '¡Buen intento!' : '¡Sigue practicando!'));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(title,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5))
              .animate()
              .fadeIn(duration: 300.ms)
              .slideY(begin: -0.2, end: 0),
          const SizedBox(height: 20),

          // Score ring with robot mascot peeking
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percentage / 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 18,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.white.withValues(alpha: 0.7),
                    valueColor: AlwaysStoppedAnimation(ringColor),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$percentage',
                      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, height: 1)),
                  const Text('% correcto',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textMuted)),
                ],
              ),
              Positioned(
                bottom: -18,
                right: -10,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: RobotAvatarWidget(config: _robot, size: 86),
                  ).animate().scale(delay: 300.ms, duration: 600.ms, curve: Curves.elasticOut),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 18),

          Text('$_correctCount/$_totalQuestions respuestas correctas',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
          const SizedBox(height: 16),

          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.star_rounded, size: 46, color: i < stars ? AppTheme.accentGold : Colors.white.withValues(alpha: 0.8))
                    .animate()
                    .scale(delay: (400 + i * 150).ms, duration: 400.ms, curve: Curves.easeOutBack),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Stat chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              _statChip('⚡', '+$xp XP', AppTheme.accentGreen),
              _statChip('🔥', 'Racha: $_maxStreak', AppTheme.accentOrange),
              _statChip('📊', '$percentage%', AppTheme.primaryBlue),
            ],
          ),
          const SizedBox(height: 30),

          if (widget.leagueCategoryId != null) ...[
            _PillButton(
              label: 'Ver clasificación',
              icon: Icons.leaderboard_rounded,
              color: AppTheme.accentGold,
              onTap: () => Navigator.push(
                context,
                AppTheme.smoothRoute(LeagueLeaderboardScreen(categoryId: widget.leagueCategoryId!)),
              ),
            ),
            const SizedBox(height: 12),
          ],
          _PillButton(label: 'Reintentar', icon: Icons.refresh_rounded, color: Colors.white, textColor: AppTheme.textPrimary, onTap: _retryQuiz),
          const SizedBox(height: 12),
          _PillButton(label: 'Volver', icon: Icons.check_rounded, color: AppTheme.primaryBlue, onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _statChip(String emoji, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}

// Soft drop shadow used across the playful cards.
final List<BoxShadow> _softShadow = [
  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8)),
];

/// Round white icon button (close / info) in the playful style.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: _softShadow),
        child: Icon(icon, size: 22, color: AppTheme.textSecondary),
      ),
    );
  }
}

/// Big chunky pill button.
class _PillButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  final IconData? icon;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.color,
    this.textColor,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = textColor ?? Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (color == Colors.white ? Colors.black : color).withValues(alpha: color == Colors.white ? 0.08 : 0.35),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon, size: 20, color: fg), const SizedBox(width: 8)],
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: fg)),
          ],
        ),
      ),
    );
  }
}
