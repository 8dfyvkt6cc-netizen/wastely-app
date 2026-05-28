import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';

class _Language {
  final String code;
  final String flag;
  final String nameNative;
  final String nameEn;

  const _Language(this.code, this.flag, this.nameNative, this.nameEn);
}

const _languages = [
  _Language('en', '🇺🇸', 'English', 'English'),
  _Language('ru', '🇷🇺', 'Русский', 'Russian'),
  _Language('th', '🇹🇭', 'ภาษาไทย', 'Thai'),
  _Language('es', '🇪🇸', 'Español', 'Spanish'),
  _Language('hi', '🇮🇳', 'हिन्दी', 'Hindi'),
  _Language('pt', '🇧🇷', 'Português', 'Portuguese'),
  _Language('ar', '🇸🇦', 'العربية', 'Arabic'),
];

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  String _selected = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.7, 0.7),
                          duration: 500.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeIn(),

                    const SizedBox(height: 24),

                    Text(
                      'onboarding.choose_language',
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center,
                    ).tr().animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                    const SizedBox(height: 8),

                    Text(
                      'onboarding.language_subtitle',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ).tr().animate(delay: 150.ms).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Language list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final lang = _languages[i];
                    final isSelected = _selected == lang.code;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = lang.code),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.12)
                              : AppColors.surfaceGlass,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.6)
                                : AppColors.surfaceGlassBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(lang.flag, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.nameNative,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    lang.nameEn,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: AppColors.background,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: Duration(milliseconds: 80 * i))
                        .fadeIn()
                        .slideX(begin: 0.1);
                  },
                ),
              ),

              // Continue button
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: PrimaryButton(
                  label: 'common.continue'.tr(),
                  onPressed: () async {
                    await context.setLocale(Locale(_selected));
                    await ref
                        .read(languageProvider.notifier)
                        .setLanguage(_selected);
                    if (context.mounted) {
                      context.go(AppRoutes.currencySelection);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
