import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newCtrl     = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureNew     = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // TODO: call Supabase to update password & set is_first_login = false
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully!'),
        backgroundColor: AppColors.statusApproved,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
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
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AppCard(
                    width: 360,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon + title
                          Center(
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: AppColors.gradientLeft.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 32,
                                color: AppColors.gradientLeft,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'Set New Password',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'First login detected. Please set a\npersonal password to continue.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textGrey,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // New password
                          const Text(
                            'New Password',
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _newCtrl,
                            obscureText: _obscureNew,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(fontSize: 14),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter new password';
                              }
                              if (v.trim().length < 6) {
                                return 'Minimum 6 characters';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Min. 6 characters',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureNew
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscureNew = !_obscureNew),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm password
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textDark),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            style: const TextStyle(fontSize: 14),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Confirm your password';
                              }
                              if (v.trim() != _newCtrl.text.trim()) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Re-enter password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                                onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          AppButton(
                            label: 'Set Password & Continue',
                            onTap: _submit,
                            loading: _loading,
                            icon: Icons.arrow_forward,
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
