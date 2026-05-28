import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';

const _languages = [
  ('en', '🇺🇸', 'English'),
  ('ru', '🇷🇺', 'Русский'),
  ('th', '🇹🇭', 'ภาษาไทย'),
  ('es', '🇪🇸', 'Español'),
  ('hi', '🇮🇳', 'हिन्दी'),
  ('pt', '🇧🇷', 'Português'),
  ('ar', '🇸🇦', 'العربية'),
];

const _currencies = [
  ('USD', '\$', 'US Dollar'),
  ('EUR', '€', 'Euro'),
  ('THB', '฿', 'Thai Baht'),
  ('RUB', '₽', 'Russian Ruble'),
  ('INR', '₹', 'Indian Rupee'),
  ('BRL', 'R\$', 'Brazilian Real'),
  ('GBP', '£', 'British Pound'),
];

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final currency = ref.watch(currencyProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text('nav.settings'.tr(), style: AppTextStyles.headlineLarge),
                const SizedBox(height: 24),

                // Profile card
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (user?.email ?? 'W')[0].toUpperCase(),
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.email ?? '', style: AppTextStyles.titleLarge),
                            Text(
                              user?.emailVerified == true
                                  ? 'settings.verified'.tr()
                                  : 'settings.not_verified'.tr(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: user?.emailVerified == true
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 20),

                // Language
                _SectionLabel(label: 'settings.language'.tr()),
                const SizedBox(height: 10),
                GlassCard(
                  onTap: () => _showLanguagePicker(context, ref, lang),
                  child: Row(
                    children: [
                      const Icon(Icons.language_rounded, color: AppColors.primary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(_langName(lang), style: AppTextStyles.bodyLarge),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: 12),

                // Currency
                _SectionLabel(label: 'settings.currency'.tr()),
                const SizedBox(height: 10),
                GlassCard(
                  onTap: () => _showCurrencyPicker(context, ref, currency),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(_currencyName(currency), style: AppTextStyles.bodyLarge),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 20),

                // More settings
                _SectionLabel(label: 'settings.more'.tr()),
                const SizedBox(height: 10),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        label: 'settings.notifications'.tr(),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'settings.privacy'.tr(),
                        onTap: () {},
                      ),
                      const Divider(height: 1, indent: 56),
                      _SettingsTile(
                        icon: Icons.help_outline_rounded,
                        label: 'settings.help'.tr(),
                        onTap: () {},
                      ),
                    ],
                  ),
                ).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: 20),

                // Sign out
                GlassCard(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                      const SizedBox(width: 14),
                      Text(
                        'settings.sign_out'.tr(),
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Wastely v1.0.0',
                    style: AppTextStyles.caption,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _langName(String code) {
    for (final l in _languages) {
      if (l.$1 == code) return '${l.$2}  ${l.$3}';
    }
    return code;
  }

  String _currencyName(String code) {
    for (final c in _currencies) {
      if (c.$1 == code) return '${c.$2}  $code — ${c.$3}';
    }
    return code;
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('settings.language'.tr(), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          ...(_languages.map((l) => ListTile(
            leading: Text(l.$2, style: const TextStyle(fontSize: 24)),
            title: Text(l.$3, style: AppTextStyles.bodyLarge),
            trailing: l.$1 == current
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () async {
              await context.setLocale(Locale(l.$1));
              await ref.read(languageProvider.notifier).setLanguage(l.$1);
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, String current) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text('settings.currency'.tr(), style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          ...(_currencies.map((c) => ListTile(
            leading: Text(c.$2, style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primary)),
            title: Text('${c.$1} — ${c.$3}', style: AppTextStyles.bodyLarge),
            trailing: c.$1 == current
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () async {
              await ref.read(currencyProvider.notifier).setCurrency(c.$1);
              if (ctx.mounted) Navigator.pop(ctx);
            },
          ))),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: AppTextStyles.caption.copyWith(letterSpacing: 1.2),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    leading: Icon(icon, color: AppColors.textSecondary, size: 22),
    title: Text(label, style: AppTextStyles.bodyLarge),
    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
    onTap: onTap,
  );
}
