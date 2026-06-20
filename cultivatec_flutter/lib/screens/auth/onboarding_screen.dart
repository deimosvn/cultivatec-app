import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/providers/auth_provider.dart';
import 'package:cultivatec_flutter/data/models/robot_config.dart';
import 'package:cultivatec_flutter/core/widgets/animated_background.dart';
import 'package:cultivatec_flutter/core/widgets/glass_card.dart';
import 'package:cultivatec_flutter/core/widgets/modern_button.dart';

/// Onboarding screen: welcome flow and robot naming.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0; // 0=welcome, 1=name
  final _robotNameCtrl = TextEditingController(text: 'Mi Robot');
  bool _isLoading = false;

  Future<void> _finishOnboarding() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      await auth.updateProfile({
        'robotConfig': const RobotConfig(skinImage: 'skin_1').toMap(),
        'robotName': _robotNameCtrl.text.trim().isEmpty
            ? 'Mi Robot'
            : _robotNameCtrl.text.trim(),
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _robotNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _step == 0 ? _buildWelcome() : _buildNameStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      key: const ValueKey('welcome'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassCard(
          hasGlow: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.smart_toy, size: 80, color: AppTheme.primaryBlue),
              const SizedBox(height: 24),
              const Text(
                '¡Bienvenido a CultivaTec!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Antes de entrar a la Academia Robótica, vamos a darle un nombre a tu compañero.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ModernButton(
                label: '¡Empezar!',
                icon: Icons.rocket_launch,
                onPressed: () => setState(() => _step = 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Center(
      key: const ValueKey('name'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: GlassCard(
          hasGlow: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.shadowMd,
                  border: Border.all(color: AppTheme.primaryBlue, width: 4),
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/images/skin_1.webp',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.smart_toy, size: 60, color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Este es tu primer robot, ¡desbloquearás más diseños mientras aprendes!',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Dale un nombre a tu robot!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _robotNameCtrl,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Mi Robot',
                  hintStyle: const TextStyle(color: AppTheme.textHint),
                  filled: true,
                  fillColor: AppTheme.bgSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                  ),
                ),
                maxLength: 20,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ModernButton(
                      label: 'Volver',
                      isPrimary: false,
                      onPressed: () => setState(() => _step = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ModernButton(
                      label: '¡Listo!',
                      icon: Icons.check_circle,
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _finishOnboarding,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

