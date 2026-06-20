import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cultivatec_flutter/core/theme/theme.dart';
import 'package:cultivatec_flutter/providers/auth_provider.dart';
import 'package:cultivatec_flutter/core/utils/sound_service.dart';
import 'package:cultivatec_flutter/core/widgets/cartoon_button.dart';

enum AuthViewState { welcome, login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthViewState _viewState = AuthViewState.welcome;
  bool _showPassword = false;
  
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    SoundService.playClick();
    setState(() => _localError = null);
    final auth = context.read<AuthProvider>();
    auth.clearError();

    if (_viewState == AuthViewState.login) {
      if (_emailCtrl.text.trim().isEmpty || _passwordCtrl.text.trim().isEmpty) {
        setState(() => _localError = 'Completa todos los campos.');
        return;
      }
      auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
    } else if (_viewState == AuthViewState.register) {
      if (_usernameCtrl.text.trim().isEmpty ||
          _emailCtrl.text.trim().isEmpty ||
          _passwordCtrl.text.trim().isEmpty) {
        setState(() => _localError = 'Completa todos los campos.');
        return;
      }
      auth.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        username: _usernameCtrl.text.trim(),
        fullName: _usernameCtrl.text.trim(), // Use username for full name to keep it simple for kids
      );
    }
  }

  void _changeState(AuthViewState newState) {
    SoundService.playClick();
    setState(() {
      _viewState = newState;
      _localError = null;
      context.read<AuthProvider>().clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF60B6E7), // Light blue from design
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildCurrentView(),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_viewState) {
      case AuthViewState.welcome:
        return _buildWelcomeView();
      case AuthViewState.login:
        return _buildLoginView();
      case AuthViewState.register:
        return _buildRegisterView();
    }
  }

  // --- WELCOME VIEW ---
  Widget _buildWelcomeView() {
    return Stack(
      key: const ValueKey('welcome'),
      children: [
        // Background decorations could go here
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              '¡Comencemos!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const Text(
              '¡Vamos a crear e inventar!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Center(
              child: Image.asset('assets/images/robot_welcome.png', height: 300),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CartoonButton(
                text: 'CREAR CUENTA',
                onPressed: () => _changeState(AuthViewState.register),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _changeState(AuthViewState.login),
              child: const Text(
                '¿Ya tienes cuenta? > Iniciar sesión',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ],
    );
  }

  // --- LOGIN VIEW ---
  Widget _buildLoginView() {
    return Column(
      key: const ValueKey('login'),
      children: [
        const Spacer(),
        // Image & Title
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Image.asset('assets/images/robot_login.png', height: 220),
            ),
            const Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Bottom White Card
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final displayError = _localError ?? auth.error;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Tu correo o el de tus papás'),
                      _buildField(
                        controller: _emailCtrl,
                        hint: 'inventor@cultivatec.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Tu contraseña secreta'),
                      _buildField(
                        controller: _passwordCtrl,
                        hint: '••••••••',
                        obscure: !_showPassword,
                        suffix: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text('A ver, ¿olvidé mi contraseña?', 
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
                      ),
                      const SizedBox(height: 20),
                      if (displayError != null) _buildError(displayError),
                      CartoonButton(
                        text: 'INICIAR SESIÓN',
                        isLoading: auth.isLoading,
                        onPressed: auth.isLoading ? null : _submit,
                      ),
                      const SizedBox(height: 20),
                      _buildSocialButtons(auth),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => _changeState(AuthViewState.register),
                          child: const Text('¿No tienes cuenta? Crea una', 
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        ),
                      ),
                      const SizedBox(height: 20), // Bottom padding
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- REGISTER VIEW ---
  Widget _buildRegisterView() {
    return Column(
      key: const ValueKey('register'),
      children: [
        // Top section with back button and small image
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _changeState(AuthViewState.welcome),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFFC64B), shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, color: Color(0xFF4A4A4A)),
                ),
              ),
            ],
          ),
        ),
        Image.asset('assets/images/robot_register.png', height: 180),
        const SizedBox(height: 16),
        // Bottom White Card
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  final displayError = _localError ?? auth.error;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text('Nuevo Inventor', 
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                      ),
                      const SizedBox(height: 24),
                      _buildLabel('Tu nombre de inventor'),
                      _buildField(
                        controller: _usernameCtrl,
                        hint: 'Leo',
                        inputFormatters: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Tu correo o el de tus papás'),
                      _buildField(
                        controller: _emailCtrl,
                        hint: 'inventor@cultivatec.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Tu contraseña secreta'),
                      _buildField(
                        controller: _passwordCtrl,
                        hint: '••••••••',
                        obscure: !_showPassword,
                        suffix: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (displayError != null) _buildError(displayError),
                      CartoonButton(
                        text: 'CREAR CUENTA',
                        isLoading: auth.isLoading,
                        onPressed: auth.isLoading ? null : _submit,
                      ),
                      const SizedBox(height: 20),
                      _buildSocialButtons(auth),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => _changeState(AuthViewState.login),
                          child: const Text('Ya tengo cuenta > Iniciar sesión', 
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    bool inputFormatters = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textHint, fontWeight: FontWeight.w600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffix,
        ),
        onChanged: inputFormatters
            ? (val) {
                final cleaned = val.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
                if (cleaned != val) {
                  controller.value = TextEditingValue(
                    text: cleaned,
                    selection: TextSelection.collapsed(offset: cleaned.length),
                  );
                }
              }
            : null,
      ),
    );
  }

  Widget _buildSocialButtons(AuthProvider auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          iconPath: 'assets/images/google_logo.png', // Or use an Icon, but image is closer to mockup
          iconWidget: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF4285F4), Color(0xFF34A853)]),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          onTap: () {
            _localError = null;
            auth.clearError();
            auth.loginWithGoogle();
          },
        ),
        const SizedBox(width: 20),
        _socialButton(
          iconWidget: const Icon(Icons.apple, size: 28),
          onTap: () {
            setState(() => _localError = 'Inicio de sesión con Apple muy pronto');
          },
        ),
      ],
    );
  }

  Widget _socialButton({required Widget iconWidget, required VoidCallback onTap, String? iconPath}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: iconWidget),
      ),
    );
  }

  Widget _buildError(String displayError) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade500, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayError,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
