import 'dart:async';

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

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _checkTimer;
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  bool _isChecking = false;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    // Poll every 3 seconds for email verification
    _checkTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkVerification(),
    );
  }

  @override
  void dispose() {
    _checkTimer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkVerification() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        _checkTimer?.cancel();
        if (mounted) context.go(AppRoutes.home);
      }
    } catch (_) {}

    _isChecking = false;
  }

  Future<void> _resendEmail() async {
    if (!_canResend) return;

    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('auth.verification_resent'.tr()),
            backgroundColor: AppColors.primary,
          ),
        );
      }
      // Start cooldown
      setState(() {
        _canResend = false;
        _cooldownSeconds = 60;
      });
      _cooldownTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_cooldownSeconds <= 1) {
          timer.cancel();
          if (mounted) setState(() => _canResend = true);
        } else {
          if (mounted) setState(() => _cooldownSeconds--);
        }
      });
    } catch (_) {}
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Icon
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    color: AppColors.primary,
                    size: 48,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(),

                const SizedBox(height: 32),

                Text(
                  'auth.verify_email_title'.tr(),
                  style: AppTextStyles.displayMedium,
                  textAlign: TextAlign.center,
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

                const SizedBox(height: 12),

                Text(
                  'auth.verify_email_body'.tr(args: [widget.email]),
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 40),

                GlassCard(
                  child: Column(
                    children: [
                      // Steps
                      _VerificationStep(
                        number: 1,
                        text: 'auth.verify_step_1'.tr(),
                      ),
                      const Divider(height: 24),
                      _VerificationStep(
                        number: 2,
                        text: 'auth.verify_step_2'.tr(),
                      ),
                      const Divider(height: 24),
                      _VerificationStep(
                        number: 3,
                        text: 'auth.verify_step_3'.tr(),
                      ),

                      const SizedBox(height: 20),

                      // Auto-checking indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'auth.checking_verification'.tr(),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),

                const Spacer(),

                // Resend button
                PrimaryButton(
                  label: _canResend
                      ? 'auth.resend_email'.tr()
                      : 'auth.resend_cooldown'.tr(args: ['$_cooldownSeconds']),
                  onPressed: _canResend ? _resendEmail : null,
                  backgroundColor: AppColors.surfaceElevated,
                  textColor: _canResend ? AppColors.primary : AppColors.textMuted,
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _signOut,
                  child: Text(
                    'auth.sign_in_different'.tr(),
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textMuted),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerificationStep extends StatelessWidget {
  final int number;
  final String text;

  const _VerificationStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
