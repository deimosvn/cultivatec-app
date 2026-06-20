import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/data/static/stem_content.dart';
import 'package:cultivatec_flutter/core/widgets/animated_background.dart';

class UniverseMapScreen extends StatelessWidget {
  final void Function(String) onEnterUniverse; // Now receives stemAreaId

  const UniverseMapScreen({super.key, required this.onEnterUniverse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                itemCount: stemAreas.length,
                itemBuilder: (context, idx) {
                  final area = stemAreas[idx];
                  return _AreaCard(
                    area: area,
                    onTap: () => onEnterUniverse(area.id),
                  ).animate().fadeIn(delay: (120 + idx * 90).ms, duration: 450.ms).slideY(begin: 0.18, end: 0, curve: Curves.easeOutBack);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🚀 Áreas STEM', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppTheme.primaryBlue, letterSpacing: -0.8)),
          SizedBox(height: 4),
          Text('Elige qué quieres aprender hoy y diviértete practicando.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary, height: 1.35)),
        ],
      ),
    );
  }
}

class _AreaCard extends StatefulWidget {
  final StemArea area;
  final VoidCallback onTap;

  const _AreaCard({required this.area, required this.onTap});

  @override
  State<_AreaCard> createState() => _AreaCardState();
}

class _AreaCardState extends State<_AreaCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final area = widget.area;
    final color = area.color;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, 0.16)!], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 22, offset: const Offset(0, 11))],
          ),
          child: Row(
            children: [
              // Area emblem
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(area.icon, size: 34, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(area.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.4)),
                    const SizedBox(height: 3),
                    Text(area.tagline,
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85), height: 1.3)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
