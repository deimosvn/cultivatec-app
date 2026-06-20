import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/providers/auth_provider.dart';
import 'package:cultivatec_flutter/providers/universe_provider.dart';
import 'package:cultivatec_flutter/data/models/level_system.dart';
import 'package:cultivatec_flutter/data/models/robot_config.dart';
import 'package:cultivatec_flutter/core/widgets/robot_avatar.dart';
import 'package:cultivatec_flutter/core/widgets/glass_card.dart';
import 'package:cultivatec_flutter/core/widgets/animated_background.dart';
import 'package:cultivatec_flutter/screens/map/world_map_screen.dart';
import 'package:cultivatec_flutter/screens/map/universe_map_screen.dart';
import 'package:cultivatec_flutter/screens/social/ranking_screen.dart';
import 'package:cultivatec_flutter/screens/social/achievements_screen.dart';
import 'package:cultivatec_flutter/screens/social/friends_screen.dart';
import 'package:cultivatec_flutter/screens/home/settings_screen.dart';
import 'package:cultivatec_flutter/screens/robot/robot_skin_editor_screen.dart';
import 'package:cultivatec_flutter/screens/learning/classroom_screen.dart';
import 'package:cultivatec_flutter/screens/learning/glossary_screen.dart';
import 'package:cultivatec_flutter/screens/robot/coding_challenges_screen.dart';
import 'package:cultivatec_flutter/screens/tournaments/tournaments_hub_screen.dart';

/// Top-level navigation destinations (learning-first information architecture).
enum _Tab { home, learn, tournaments, social, profile }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _Tab _currentTab = _Tab.home;

  void _select(_Tab tab) => setState(() => _currentTab = tab);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, UniverseProvider>(
      builder: (context, auth, universe, _) {
        final profile = auth.profile;
        final levelInfo = calculateLevel(profile?.totalPoints ?? 0);

        return Scaffold(
          extendBody: true,
          body: AnimatedBackground(
            child: Stack(
              children: [
                IndexedStack(
                  index: _currentTab.index,
                  children: [
                    _HomeTab(auth: auth, levelInfo: levelInfo, onSelectTab: _select),
                    _buildLearnTab(auth, universe),
                    const TournamentsHubScreen(),
                    _SocialHubTab(profile: profile, pendingRequests: auth.pendingRequests.length),
                    _ProfileTab(auth: auth, levelInfo: levelInfo),
                  ],
                ),
                Positioned(bottom: 24, left: 16, right: 16, child: _buildFloatingDock(auth)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLearnTab(AuthProvider auth, UniverseProvider universe) {
    return universe.showUniverseMap
        ? UniverseMapScreen(onEnterUniverse: (id) => universe.enterStemArea(id))
        : WorldMapScreen(
            stemAreaId: universe.currentStemAreaId ?? 'robotica',
            onBack: () => universe.exitToUniverseMap(),
            userScores: auth.userScores,
            friendsCount: auth.profile?.friendsCount ?? 0,
          );
  }

  Widget _buildFloatingDock(AuthProvider auth) {
    return SafeArea(
      child: Center(
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          borderRadius: 40,
          hasGlow: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              _navItem(_Tab.home, Icons.home_rounded, 'Inicio'),
              _navItem(_Tab.learn, Icons.rocket_launch_rounded, 'Aprender'),
              _navItem(_Tab.tournaments, Icons.sports_esports_rounded, 'Torneos'),
              _navItem(_Tab.social, Icons.groups_rounded, 'Social', badge: auth.pendingRequests.length),
              _navItem(_Tab.profile, Icons.person_rounded, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(_Tab tab, IconData icon, String label, {int badge = 0}) {
    final isActive = _currentTab == tab;
    return GestureDetector(
      onTap: () => _select(tab),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutExpo,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.45), blurRadius: 16, offset: const Offset(0, 6))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isActive ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: Icon(icon, color: isActive ? Colors.white : AppTheme.textMuted, size: 24),
                ),
                if (badge > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: isActive ? AppTheme.primaryBlue : Colors.white, width: 2),
                      ),
                      child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                    ),
                  ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: isActive
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(label,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 0.3))
                          .animate()
                          .fadeIn(duration: 200.ms),
                    )
                  : const SizedBox(width: 0),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INICIO — pixel-matched to the reference dashboard.
// ============================================================================
class _HomeTab extends StatelessWidget {
  final AuthProvider auth;
  final LevelInfo levelInfo;
  final ValueChanged<_Tab> onSelectTab;

  const _HomeTab({required this.auth, required this.levelInfo, required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    final robot = profile?.robotConfig ?? const RobotConfig();
    final pending = auth.pendingRequests.length;
    final modules = profile?.modulesCompleted ?? 0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(profile?.username ?? 'Explorador', robot, pending)
                    .animate().fadeIn(duration: 300.ms).slideY(begin: -0.15, end: 0),
                const SizedBox(height: 14),
                _statsBar(profile).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideY(begin: 0.15, end: 0),
                const SizedBox(height: 16),
                _missionCarousel(context, robot)
                    .animate().fadeIn(delay: 200.ms, duration: 350.ms).slideY(begin: 0.12, end: 0),
                const SizedBox(height: 24),
                _quickTiles(context).animate().fadeIn(delay: 300.ms, duration: 300.ms),
                const SizedBox(height: 26),
                const Text('Rutas de Aprendizaje',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.4)),
                const SizedBox(height: 18),
                _pathSection(modules).animate().fadeIn(delay: 380.ms, duration: 300.ms),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---- Header --------------------------------------------------------------
  Widget _header(String name, RobotConfig robot, int pending) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onSelectTab(_Tab.profile),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppTheme.shadowSm),
            child: RobotAvatarWidget(config: robot, size: 42),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('¡Hola, $name!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: -0.5)),
        ),
        GestureDetector(
          onTap: () => onSelectTab(_Tab.social),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: AppTheme.shadowSm),
                child: const Icon(Icons.notifications_rounded, color: AppTheme.textSecondary, size: 22),
              ),
              if (pending > 0)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(color: AppTheme.accentRed, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Stats bar (4 mini stats in one white card) --------------------------
  Widget _statsBar(dynamic profile) {
    final modules = profile?.modulesCompleted ?? 0;
    final challenges = profile?.challengesCompleted ?? 0;
    final trophies = (profile?.achievementsUnlocked as List?)?.length ?? 0;
    final robots = robotSkins.where((s) => s.challengesRequired <= challenges).length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: AppTheme.shadowSm),
      child: Row(
        children: [
          _statItem(Icons.bar_chart_rounded, AppTheme.primaryBlue, 'Nivel ${levelInfo.level}'),
          _statItem(Icons.assignment_turned_in_rounded, AppTheme.accentOrange, 'Misiones\nCompletas: $modules'),
          _statItem(Icons.emoji_events_rounded, AppTheme.accentGold, 'Trofeos: $trophies'),
          _statItem(Icons.smart_toy_rounded, AppTheme.primaryBlue, 'Robots\nCreados: $robots'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, Color color, String text) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 5),
          Text(text,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppTheme.textSecondary, height: 1.2)),
        ],
      ),
    );
  }

  // ---- Mission carousel ----------------------------------------------------
  Widget _missionCarousel(BuildContext context, RobotConfig robot) {
    final width = MediaQuery.of(context).size.width;
    final mainW = width * 0.82;
    return SizedBox(
      height: 246,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        children: [
          _heroMission(width: mainW, robot: robot, onTap: () => onSelectTab(_Tab.learn)),
          const SizedBox(width: 14),
          _infoCard(
            width: mainW * 0.58,
            colors: const [Color(0xFF2563EB), Color(0xFF60A5FA)],
            icon: Icons.build_rounded,
            title: 'Inventor\nde Piezas',
            subtitle: 'Arma tu robot',
            cta: 'Ver',
            onTap: () => onSelectTab(_Tab.learn),
          ),
          const SizedBox(width: 14),
          _infoCard(
            width: mainW * 0.58,
            colors: const [Color(0xFF7C3AED), Color(0xFFA855F7)],
            icon: Icons.sports_esports_rounded,
            title: 'Torneo\nsemanal',
            subtitle: 'Compite STEM',
            cta: 'Jugar',
            onTap: () => onSelectTab(_Tab.tournaments),
          ),
        ],
      ),
    );
  }

  /// Main "Misión del Día" card: blue top + robot poking out the top, with a
  /// white bottom band (lesson, progress, start button).
  Widget _heroMission({required double width, required RobotConfig robot, required VoidCallback onTap}) {
    final progress = levelInfo.progress.clamp(0.0, 1.0);
    final pct = (progress * 100).round();
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: width,
              height: 246,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.28), blurRadius: 22, offset: const Offset(0, 11))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Column(
                  children: [
                    // Blue top zone
                    Container(
                      height: 132,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(18, 16, 8, 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Misión del Día:',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            const Text('Continuar\naprendiendo',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -0.5)),
                          ],
                        ),
                      ),
                    ),
                    // White bottom band
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Siguiente Lección',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 9,
                                backgroundColor: AppTheme.bgSecondary,
                                valueColor: const AlwaysStoppedAnimation(AppTheme.primaryBlue),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text('$pct% Completado',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                  decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14)),
                                  child: const Text('¡Comenzar Misión!',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Robot mascot poking above the blue zone
            Positioned(
              right: 4,
              top: -22,
              child: IgnorePointer(
                child: SizedBox(
                  width: 138,
                  height: 158,
                  child: Image.asset(
                    'assets/images/robotimagen.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        FittedBox(fit: BoxFit.contain, child: RobotAvatarWidget(config: robot, size: 150)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required double width,
    required List<Color> colors,
    required IconData icon,
    required String title,
    required String subtitle,
    required String cta,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: colors.last.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -0.4)),
            const SizedBox(height: 3),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Text(cta, style: TextStyle(color: colors.last, fontWeight: FontWeight.w900, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Quick tiles ---------------------------------------------------------
  Widget _quickTiles(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _squareTile(Icons.smart_toy_rounded, 'Mis Robots', AppTheme.primaryBlue, Colors.white,
              () => Navigator.push(context, AppTheme.smoothRoute(const RobotSkinEditorScreen()))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _squareTile(Icons.code_rounded, 'Taller de Código', AppTheme.accentCyan, Colors.white,
              () => Navigator.push(context, AppTheme.smoothRoute(const CodingChallengesScreen()))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _squareTile(Icons.emoji_events_rounded, 'Desafíos Semanales', AppTheme.primaryBlue, AppTheme.accentGold,
              () => onSelectTab(_Tab.tournaments)),
        ),
      ],
    );
  }

  Widget _squareTile(IconData icon, String label, Color color, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, 0.14)!], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.38), blurRadius: 14, offset: const Offset(0, 7))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(height: 8),
              Text(label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, height: 1.1)),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Learning path -------------------------------------------------------
  Widget _pathSection(int modules) {
    const names = ['Robótica', 'Programación', 'Electrónica'];
    const icons = [Icons.smart_toy_rounded, Icons.code_rounded, Icons.bolt_rounded];
    const colors = [AppTheme.accentPurple, AppTheme.primaryBlue, AppTheme.accentCyan];
    final done = [modules >= 3, modules >= 6, modules >= 9];
    bool unlocked(int i) => i == 0 || done[i - 1];

    final children = <Widget>[];
    for (int i = 0; i < 3; i++) {
      children.add(_pathNode(names[i], icons[i], colors[i], done[i], unlocked(i)));
      if (i < 2) children.add(_connector(done[i]));
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _connector(bool active) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 27),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            4,
            (_) => Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: active ? AppTheme.accentGreen : AppTheme.borderColor, shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pathNode(String name, IconData icon, Color color, bool done, bool unlocked) {
    final bg = done ? AppTheme.accentGreen : (unlocked ? color : const Color(0xFFE2E8F0));
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          GestureDetector(
            onTap: unlocked ? () => onSelectTab(_Tab.learn) : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: unlocked ? [BoxShadow(color: bg.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 6))] : [],
                  ),
                  child: Icon(
                    unlocked ? icon : Icons.lock_rounded,
                    color: unlocked ? Colors.white : AppTheme.textMuted,
                    size: 27,
                  ),
                ),
                if (done)
                  Positioned(right: -2, top: -2, child: _badge(Icons.check_rounded, AppTheme.accentGreen)),
                if (!unlocked)
                  Positioned(right: -2, top: -2, child: _badge(Icons.lock_rounded, AppTheme.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: unlocked ? AppTheme.textPrimary : AppTheme.textMuted,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, Color color) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
      child: Icon(icon, color: Colors.white, size: 12),
    );
  }
}

// ============================================================================
// SOCIAL — Hub with a segmented control over Ranking / Logros / Amigos.
// ============================================================================
class _SocialHubTab extends StatefulWidget {
  final dynamic profile;
  final int pendingRequests;
  const _SocialHubTab({required this.profile, required this.pendingRequests});

  @override
  State<_SocialHubTab> createState() => _SocialHubTabState();
}

class _SocialHubTabState extends State<_SocialHubTab> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: const [
                Text('Social', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue, letterSpacing: -0.8)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: AppTheme.shadowSm),
              child: Row(
                children: [
                  _segmentBtn(0, Icons.emoji_events_rounded, 'Ranking'),
                  _segmentBtn(1, Icons.military_tech_rounded, 'Logros'),
                  _segmentBtn(2, Icons.people_rounded, 'Amigos', badge: widget.pendingRequests),
                ],
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _segment,
              children: [
                const RankingScreen(embedded: true),
                AchievementsScreen(profile: widget.profile, embedded: true),
                const FriendsScreen(embedded: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentBtn(int idx, IconData icon, String label, {int badge = 0}) {
    final isActive = _segment == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _segment = idx),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? AppTheme.primaryGradient : null,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isActive ? [BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 18, color: isActive ? Colors.white : AppTheme.textMuted),
                  if (badge > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.accentRed, shape: BoxShape.circle)),
                    ),
                ],
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: isActive ? Colors.white : AppTheme.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PERFIL — Account home.
// ============================================================================
class _ProfileTab extends StatelessWidget {
  final AuthProvider auth;
  final LevelInfo levelInfo;
  const _ProfileTab({required this.auth, required this.levelInfo});

  @override
  Widget build(BuildContext context) {
    final profile = auth.profile;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionTitle(title: 'Perfil'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: AppTheme.shadowMd),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(color: AppTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(22)),
                            child: Center(child: RobotAvatarWidget(config: profile?.robotConfig ?? const RobotConfig(), size: 62)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(profile?.username ?? 'Explorador',
                                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                                const SizedBox(height: 2),
                                Text(profile?.email ?? '',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _miniStat('Nivel', '${levelInfo.level}', AppTheme.primaryBlue),
                          _miniStat('Puntos', '${profile?.totalPoints ?? 0}', AppTheme.accentGold),
                          _miniStat('Módulos', '${profile?.modulesCompleted ?? 0}', AppTheme.accentGreen),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 20),
                _profileTile(context, Icons.smart_toy_rounded, AppTheme.accentPurple, 'Editar Robot', 'Personaliza tu compañero',
                    () => Navigator.push(context, AppTheme.smoothRoute(const RobotSkinEditorScreen()))),
                const SizedBox(height: 12),
                _profileTile(context, Icons.menu_book_rounded, AppTheme.accentOrange, 'Glosario', 'Conceptos clave de robótica',
                    () => Navigator.push(context, AppTheme.smoothRoute(const GlossaryScreen()))),
                const SizedBox(height: 12),
                _profileTile(context, Icons.school_rounded, AppTheme.accentGreen, 'Mi clase', 'Conecta con tu grupo',
                    () => Navigator.push(context, AppTheme.smoothRoute(const ClassroomScreen()))),
                const SizedBox(height: 12),
                _profileTile(context, Icons.settings_rounded, AppTheme.textSecondary, 'Configuración', 'Sonido, cuenta y más',
                    () => Navigator.push(context, AppTheme.smoothRoute(const SettingsScreen()))),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _profileTile(BuildContext context, IconData icon, Color color, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: AppTheme.shadowSm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}

/// Big bold colored section heading.
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue, letterSpacing: -0.8));
  }
}
