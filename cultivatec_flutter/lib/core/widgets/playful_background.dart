import 'package:flutter/material.dart';

/// Playful, kid-friendly scenery background: a soft sky, drifting clouds and
/// rounded hills — all in the CultivaTec blue palette. Used to give learning
/// screens (quiz, results) a fun storybook feel.
class PlayfulBackground extends StatelessWidget {
  final Widget child;

  /// Sky gradient colors (top → bottom). Defaults to soft CultivaTec blues.
  final List<Color> skyColors;

  const PlayfulBackground({
    super.key,
    required this.child,
    this.skyColors = const [Color(0xFFBFE3FF), Color(0xFFE9F5FF)],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sky
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: skyColors,
            ),
          ),
          child: const SizedBox.expand(),
        ),
        // Clouds
        const Positioned(top: 70, left: 20, child: _Cloud(width: 96, height: 26)),
        const Positioned(top: 150, right: 26, child: _Cloud(width: 70, height: 20)),
        const Positioned(top: 250, left: 40, child: _Cloud(width: 56, height: 16)),
        // Rounded hills along the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 280),
            painter: _HillsPainter(),
          ),
        ),
        child,
      ],
    );
  }
}

class _Cloud extends StatelessWidget {
  final double width;
  final double height;
  const _Cloud({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 1.8,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ),
          Positioned(bottom: height * 0.35, left: width * 0.12, child: _blob(height * 1.1)),
          Positioned(bottom: height * 0.45, right: width * 0.14, child: _blob(height * 0.85)),
        ],
      ),
    );
  }

  Widget _blob(double d) => Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
        ),
      );
}

/// Two layers of rounded scenery: a soft blue mountain behind a green hill.
class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Distant blue mountains
    final mountain = Paint()..color = const Color(0xFF93C5FD).withValues(alpha: 0.55);
    final mPath = Path()
      ..moveTo(0, h * 0.55)
      ..quadraticBezierTo(w * 0.20, h * 0.20, w * 0.42, h * 0.50)
      ..quadraticBezierTo(w * 0.62, h * 0.78, w * 0.80, h * 0.40)
      ..quadraticBezierTo(w * 0.92, h * 0.18, w, h * 0.45)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mPath, mountain);

    // Front green hill
    final hill = Paint()..color = const Color(0xFF34D399);
    final hPath = Path()
      ..moveTo(0, h * 0.78)
      ..quadraticBezierTo(w * 0.30, h * 0.58, w * 0.55, h * 0.72)
      ..quadraticBezierTo(w * 0.82, h * 0.86, w, h * 0.68)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(hPath, hill);

    // Subtle lighter sheen on the hill
    final sheen = Paint()..color = const Color(0xFF6EE7B7).withValues(alpha: 0.5);
    final sPath = Path()
      ..moveTo(0, h * 0.86)
      ..quadraticBezierTo(w * 0.30, h * 0.70, w * 0.55, h * 0.82)
      ..quadraticBezierTo(w * 0.82, h * 0.94, w, h * 0.80)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(sPath, sheen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
