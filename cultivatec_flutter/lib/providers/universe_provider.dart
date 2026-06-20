import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages STEM Area navigation state.
/// We kept the class name UniverseProvider to minimize widespread refactoring,
/// but it now manages `currentStemAreaId`.
class UniverseProvider extends ChangeNotifier {
  String? _currentStemAreaId;
  String? _userRole;
  bool _diagnosticCompleted = false;
  bool _showUniverseMap = true; // Still used to show the top-level selection map

  String? get currentStemAreaId => _currentStemAreaId;
  String? get userRole => _userRole;
  bool get diagnosticCompleted => _diagnosticCompleted;
  bool get showUniverseMap => _showUniverseMap;

  // Retrocompatibility alias
  int? get currentUniverse => _currentStemAreaId != null ? 1 : null;

  UniverseProvider() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _currentStemAreaId = prefs.getString('cultivatec_currentStemAreaId');
    _userRole = prefs.getString('cultivatec_userRole');
    _diagnosticCompleted = prefs.getBool('cultivatec_diagnosticCompleted') ?? false;
    _showUniverseMap = _currentStemAreaId == null;
    notifyListeners();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentStemAreaId != null) {
      await prefs.setString('cultivatec_currentStemAreaId', _currentStemAreaId!);
    } else {
      await prefs.remove('cultivatec_currentStemAreaId');
    }
    if (_userRole != null) {
      await prefs.setString('cultivatec_userRole', _userRole!);
    }
    await prefs.setBool('cultivatec_diagnosticCompleted', _diagnosticCompleted);
  }

  void enterUniverse(int index) {
    // For compatibility if called from old code
  }

  void enterStemArea(String areaId) {
    _currentStemAreaId = areaId;
    _showUniverseMap = false;
    _saveState();
    notifyListeners();
  }

  void exitToUniverseMap() {
    _currentStemAreaId = null;
    _showUniverseMap = true;
    _saveState();
    notifyListeners();
  }

  void assignRole(String role, {bool autoNavigate = true}) {
    _userRole = role;
    _diagnosticCompleted = true;
    if (autoNavigate) {
      // If we auto navigate, let's just go to 'robotica' by default
      enterStemArea('robotica');
    }
    _saveState();
    notifyListeners();
  }

  void resetDiagnostic() {
    _userRole = null;
    _diagnosticCompleted = false;
    _currentStemAreaId = null;
    _showUniverseMap = true;
    _saveState();
    notifyListeners();
  }
}
