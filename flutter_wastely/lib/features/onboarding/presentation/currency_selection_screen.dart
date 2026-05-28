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

class _Currency {
  final String code;
  final String symbol;
  final String name;
  final String flag;

  const _Currency(this.code, this.symbol, this.name, this.flag);
}

const _currencies = [
  _Currency('USD', '\$', 'US Dollar', '🇺🇸'),
  _Currency('EUR', '€', 'Euro', '🇪🇺'),
  _Currency('THB', '฿', 'Thai Baht', '🇹🇭'),
  _Currency('RUB', '₽', 'Russian Ruble', '🇷🇺'),
  _Currency('INR', '₹', 'Indian Rupee', '🇮🇳'),
  _Currency('BRL', 'R\$', 'Brazilian Real', '🇧🇷'),
  _Currency('GBP', '£', 'British Pound', '🇬🇧'),
  _Currency('JPY', '¥', 'Japanese Yen', '🇯🇵'),
  _Currency('CNY', '¥', 'Chinese Yuan', '🇨🇳'),
  _Currency('AED', 'د.إ', 'UAE Dirham', '🇦🇪'),
];

class CurrencySelectionScreen extends ConsumerStatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  ConsumerState<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState
    extends ConsumerState<CurrencySelectionScreen> {
  String _selected = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 48),

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
                        Icons.attach_money_rounded,
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
                      'onboarding.choose_currency',
                      style: AppTextStyles.displayMedium,
                      textAlign: TextAlign.center,
                    ).tr().animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                    const SizedBox(height: 8),
                    Text(
                      'onboarding.currency_subtitle',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ).tr().animate(delay: 150.ms).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.7,
                  ),
                  itemCount: _currencies.length,
                  itemBuilder: (context, i) {
                    final cur = _currencies[i];
                    final isSelected = _selected == cur.code;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = cur.code),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(14),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(cur.flag,
                                    style: const TextStyle(fontSize: 22)),
                                const Spacer(),
                                if (isSelected)
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: AppColors.background,
                                      size: 12,
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${cur.symbol} ${cur.code}',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                Text(cur.name, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: Duration(milliseconds: 60 * i))
                        .fadeIn()
                        .scale(begin: const Offset(0.9, 0.9));
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: PrimaryButton(
                  label: 'common.continue'.tr(),
                  onPressed: () async {
                    await ref
                        .read(currencyProvider.notifier)
                        .setCurrency(_selected);
                    if (context.mounted) {
                      context.go(AppRoutes.tutorial);
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
