import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../models/models.dart';
import 'change_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    // ── Simulate network delay (remove when backend is ready) ──
    await Future.delayed(const Duration(milliseconds: 800));

    final username = _usernameCtrl.text.trim().toLowerCase();
    final password = _passwordCtrl.text.trim();

    // Mock auth: username == password on first login
    // TODO: replace with Supabase API call
    final isValid = password == username || password == 'admin';

    setState(() => _loading = false);

    if (!isValid) {
      setState(() => _error = 'Invalid username or password');
      return;
    }

    if (!mounted) return;

    // Mock first-login check
    final isFirstLogin = MockData.currentUser.isFirstLogin;

    if (isFirstLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 400;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            // ── Top app bar ──
            SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                child: const Text(
                  'Century Plyboards (I) Ltd.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.companyRed,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),

            // ── Centered login card ──
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AppCard(
                    width: isSmall ? double.infinity : 360,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo / title
                          const Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Username
                          const Text(
                            'Username:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _usernameCtrl,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            style: const TextStyle(fontSize: 14),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                            decoration: const InputDecoration(
                              hintText: 'e.g. kdl13562',
                              prefixIcon: Icon(Icons.badge_outlined, size: 20),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          const Text(
                            'Password:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _login(),
                            style: const TextStyle(fontSize: 14),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Enter password' : null,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Error
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.companyRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          const SizedBox(height: 4),
                          AppButton(
                            label: 'Login',
                            onTap: _login,
                            loading: _loading,
                            color: AppColors.btnGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
