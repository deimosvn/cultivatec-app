import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static bool _enabled = true;
  static double _volume = 0.5;

  static bool get isEnabled => _enabled;
  static double get volume => _volume;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('cultivatec_soundEnabled') ?? true;
    _volume = prefs.getDouble('cultivatec_soundVolume') ?? 0.5;
  }

  static Future<void> setEnabled(bool val) async {
    _enabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('cultivatec_soundEnabled', val);
  }

  static Future<void> setVolume(double val) async {
    _volume = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cultivatec_soundVolume', val);
  }

  // Sound effect stubs - in a real implementation these would use audioplayers
  // For now they're no-ops that can be filled in with actual audio later
  static void playClick() {}
  static void playTab() {}
  static void playNavigate() {}
  static void playBack() {}
  static void playCorrect() {}
  static void playWrong() {}
  static void playXP() {}
  static void playLevelUp() {}
  static void playVictory() {}
  static void playAchievement() {}
  static void playSkinUnlock() {}
  static void playError() {}
  static void playLogin() {}
  static void playLogout() {}
  static void playFriendAccept() {}
  static void playNotification() {}
  static void playStreak() {}
  static void playWorldEnter() {}
  static void playSave() {}
  static void playSelect() {}
}
