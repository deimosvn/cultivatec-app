import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cultivatec_flutter/core/config/firebase_config.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/providers/auth_provider.dart';
import 'package:cultivatec_flutter/providers/universe_provider.dart';
import 'package:cultivatec_flutter/screens/auth/auth_screen.dart';
import 'package:cultivatec_flutter/screens/auth/onboarding_screen.dart';
import 'package:cultivatec_flutter/screens/home/home_screen.dart';
import 'package:cultivatec_flutter/core/utils/sound_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  await SoundService.init();
  runApp(const CultivaTecApp());
}

class CultivaTecApp extends StatelessWidget {
  const CultivaTecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UniverseProvider()),
      ],
      child: MaterialApp(
        title: 'CultivaTec',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: const AppRouter(),
      ),
    );
  }
}

/// Root router that decides which screen to show based on auth/onboarding state.
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'CultivaTec',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!auth.isLoggedIn) {
          return const AuthScreen();
        }

        if (!auth.onboardingDone) {
          return const OnboardingScreen();
        }

        return const HomeScreen();
      },
    );
  }
}

