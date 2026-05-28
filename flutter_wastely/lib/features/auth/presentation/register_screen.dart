import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _captchaCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _captchaSolved = false;
  String? _errorMessage;

  // Math CAPTCHA — no API keys needed
  late int _captchaA;
  late int _captchaB;
  late String _captchaOp;
  late int _captchaAnswer;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final rng = Random();
    _captchaA = rng.nextInt(12) + 1;
    _captchaB = rng.nextInt(12) + 1;
    final ops = ['+', '×'];
    _captchaOp = ops[rng.nextInt(ops.length)];
    _captchaAnswer =
        _captchaOp == '+' ? _captchaA + _captchaB : _captchaA * _captchaB;
    _captchaCtrl.clear();
    _captchaSolved = false;
  }

  bool _checkCaptcha() {
    final input = int.tryParse(_captchaCtrl.text.trim());
    return input == _captchaAnswer;
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _captchaCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_checkCaptcha()) {
      setState(() {
        _errorMessage = 'auth.captcha_wrong'.tr();
        _generateCaptcha();
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      await credential.user!.sendEmailVerification();

      if (!mounted) return;
      context.go(AppRoutes.emailVerification, extra: _emailCtrl.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _mapError(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'auth.error_email_in_use'.tr();
      case 'weak-password':
        return 'auth.error_weak_password'.tr();
      case 'invalid-email':
        return 'auth.error_invalid_email'.tr();
      default:
        return 'auth.error_generic'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Back
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary),
                  onPressed: () => context.go(AppRoutes.login),
                ),

                const SizedBox(height: 16),

                Text(
                  'auth.create_account'.tr(),
                  style: AppTextStyles.displayMedium,
                ).animate().fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 8),
                Text(
                  'auth.create_account_subtitle'.tr(),
                  style: AppTextStyles.bodyMedium,
                ).animate(delay: 100.ms).fadeIn(),

                const SizedBox(height: 32),

                GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'auth.email_hint'.tr(),
                            prefixIcon: const Icon(Icons.mail_outline_rounded,
                                color: AppColors.textMuted),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'auth.email_required'.tr();
                            if (!v.contains('@'))
                              return 'auth.error_invalid_email'.tr();
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: _obscurePass,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'auth.password_hint'.tr(),
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppColors.textMuted),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePass
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 8)
                              return 'auth.password_min_length'.tr();
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Confirm password
                        TextFormField(
                          controller: _confirmPassCtrl,
                          obscureText: _obscureConfirm,
                          style: AppTextStyles.bodyLarge,
                          decoration: InputDecoration(
                            hintText: 'auth.confirm_password_hint'.tr(),
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppColors.textMuted),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (v) {
                            if (v != _passCtrl.text)
                              return 'auth.passwords_not_match'.tr();
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        // ── CAPTCHA ──────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.security_rounded,
                                      color: AppColors.primary, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'auth.captcha_title'.tr(),
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceGlass,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                                AppColors.surfaceGlassBorder),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$_captchaA $_captchaOp $_captchaB = ?',
                                          style: AppTextStyles.headlineLarge
                                              .copyWith(
                                            color: AppColors.primary,
                                            fontFeatures: const [
                                              FontFeature.tabularFigures()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Refresh
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _generateCaptcha()),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceGlass,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                            color:
                                                AppColors.surfaceGlassBorder),
                                      ),
                                      child: const Icon(
                                        Icons.refresh_rounded,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _captchaCtrl,
                                keyboardType: TextInputType.number,
                                style: AppTextStyles.bodyLarge,
                                decoration: InputDecoration(
                                  hintText: 'auth.captcha_hint'.tr(),
                                  prefixIcon: const Icon(
                                    Icons.calculate_outlined,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (_errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.error.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: AppColors.error, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(color: AppColors.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        PrimaryButton(
                          label: 'auth.create_account'.tr(),
                          onPressed: _register,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('auth.have_account'.tr(),
                        style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text('auth.sign_in'.tr()),
                    ),
                  ],
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
