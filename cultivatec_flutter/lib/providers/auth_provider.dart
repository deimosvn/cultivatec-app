import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cultivatec_flutter/data/services/auth_service.dart';
import 'package:cultivatec_flutter/data/services/firestore_service.dart';
import 'package:cultivatec_flutter/data/models/user_profile.dart';
import 'package:cultivatec_flutter/data/models/level_system.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  UserProfile? _profile;
  Map<String, dynamic> _userScores = {};
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;
  String? _error;
  bool _onboardingDone = false;

  StreamSubscription? _profileSub;
  StreamSubscription? _scoresSub;
  StreamSubscription? _requestsSub;

  // Getters
  User? get user => _user;
  UserProfile? get profile => _profile;
  Map<String, dynamic> get userScores => _userScores;
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;
  bool get hasProfile => _profile != null;
  bool get onboardingDone => _onboardingDone;
  LevelInfo get levelInfo => calculateLevel(_profile?.totalPoints ?? 0);
  bool get isAdmin => _firestoreService.isAdminEmail(_profile?.email);

  AuthProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      if (user != null) {
        _listenToProfile(user.uid);
        _listenToScores(user.uid);
        _listenToRequests(user.uid);
        _checkStreak(user.uid);
        _firestoreService.syncFriendsCount(user.uid);
      } else {
        _cancelSubscriptions();
        _profile = null;
        _userScores = {};
        _pendingRequests = [];
        _onboardingDone = false;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  void _listenToProfile(String uid) {
    _profileSub?.cancel();
    _profileSub = _firestoreService.onUserProfileChange(uid).listen((profile) {
      _profile = profile;
      if (profile != null) {
        _onboardingDone = profile.robotConfig != null;
      }
      notifyListeners();
    });
  }

  void _listenToScores(String uid) {
    _scoresSub?.cancel();
    _scoresSub = _firestoreService.onUserScoresChange(uid).listen((scores) {
      _userScores = scores;
      notifyListeners();
    });
  }

  void _listenToRequests(String uid) {
    _requestsSub?.cancel();
    _requestsSub = _firestoreService.onPendingRequestsChange(uid).listen((requests) {
      _pendingRequests = requests;
      notifyListeners();
    });
  }

  Future<void> _checkStreak(String uid) async {
    try {
      await _firestoreService.checkAndUpdateStreak(uid);
    } catch (_) {}
  }

  void _cancelSubscriptions() {
    _profileSub?.cancel();
    _scoresSub?.cancel();
    _requestsSub?.cancel();
  }

  // Auth actions
  Future<void> login(String identifier, String password) async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.loginUser(identifier, password);
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    String fullName = '',
    Map<String, dynamic>? robotConfig,
    String robotName = '',
  }) async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.registerUser(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
        robotConfig: robotConfig,
        robotName: robotName,
      );
    } on FirebaseAuthException catch (e) {
      _error = _mapAuthError(e.code);
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _error = null;
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'cancelled' && e.code != 'popup-closed-by-user') {
        _error = _mapAuthError(e.code);
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> unlockAchievement(String id) async {
    if (_user == null) return;
    if (_profile?.achievementsUnlocked.contains(id) ?? false) return;
    try {
      await _firestoreService.unlockAchievement(_user!.uid, id);
    } catch (_) {}
  }

  Future<void> unlockSkin(String skinId) async {
    if (_user == null) return;
    if (_profile?.unlockedSkins.contains(skinId) ?? false) return;
    try {
      final currentSkins = List<String>.from(_profile?.unlockedSkins ?? []);
      currentSkins.add(skinId);
      await updateProfile({'unlockedSkins': currentSkins});
    } catch (_) {}
  }

  Future<void> logout() async {
    await _authService.logoutUser();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_user == null) return;
    await _firestoreService.updateUserProfile(_user!.uid, data);
    if (data.containsKey('robotConfig')) {
      _onboardingDone = true;
      notifyListeners();
    }
  }

  Future<void> saveScore(String moduleId, Map<String, dynamic> scoreData) async {
    if (_user == null) return;
    await _firestoreService.saveModuleScore(_user!.uid, moduleId, scoreData);
  }

  Future<void> syncStats(Map<String, dynamic> statsUpdate) async {
    if (_user == null) return;
    await _firestoreService.syncUserStats(_user!.uid, statsUpdate);
  }

  // Helper: check if module is completed (>= 70%)
  bool isModuleCompleted(String moduleId) {
    final s = _userScores[moduleId];
    if (s == null || s is! Map) return false;
    final score = (s['score'] ?? 0) as int;
    final total = (s['total'] ?? 0) as int;
    if (total == 0) return false;
    return ((score / total) * 100).round() >= 70;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No se encontró la cuenta.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'El email ya está registrado.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'Email no válido.';
      case 'username-taken':
        return 'El nombre de usuario ya está en uso.';
      default:
        return 'Error de autenticación: $code';
    }
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }
}

