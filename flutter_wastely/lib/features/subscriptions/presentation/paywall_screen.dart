import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  int _selectedPlan = 1; // 0=monthly, 1=yearly, 2=lifetime
  bool _isLoading = false;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offerings = offerings);
    } catch (_) {}
  }

  String _getPrice(int planIndex) {
    if (_offerings?.current == null) {
      return ['paywall.price_monthly'.tr(), 'paywall.price_yearly'.tr(),
          'paywall.price_lifetime'.tr()][planIndex];
    }
    final pkgs = _offerings!.current!.availablePackages;
    if (planIndex < pkgs.length) {
      return pkgs[planIndex].storeProduct.priceString;
    }
    return '';
  }

  Future<void> _purchase() async {
    setState(() => _isLoading = true);
    try {
      final pkgs = _offerings?.current?.availablePackages ?? [];
      if (_selectedPlan < pkgs.length) {
        final info = await Purchases.purchasePackage(pkgs[_selectedPlan]);
        if (info.entitlements.active.containsKey('pro')) {
          await ref.read(isProProvider.notifier).setPro(true);
          if (mounted) Navigator.pop(context);
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showGlow: false,
        child: Stack(
          children: [
            // Background glow
            Positioned(
              top: -40,
              left: 0, right: 0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.primary.withOpacity(0.2), Colors.transparent],
                    radius: 0.8,
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Close
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceGlass,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.surfaceGlassBorder),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: AppColors.textMuted, size: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Shield icon
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.shield_rounded,
                          color: AppColors.background, size: 40),
                    )
                        .animate()
                        .scale(begin: const Offset(0.7, 0.7),
                            duration: 500.ms, curve: Curves.elasticOut)
                        .fadeIn(),

                    const SizedBox(height: 20),

                    Text('paywall.title'.tr(), style: AppTextStyles.displayMedium,
                        textAlign: TextAlign.center)
                        .animate(delay: 100.ms).fadeIn().slideY(begin: 0.1),

                    const SizedBox(height: 8),
                    Text('paywall.subtitle'.tr(), style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center)
                        .animate(delay: 150.ms).fadeIn(),

                    const SizedBox(height: 28),

                    // Features
                    GlassCard(
                      child: Column(
                        children: [
                          _Feature('paywall.feature_1'.tr()),
                          _Feature('paywall.feature_2'.tr()),
                          _Feature('paywall.feature_3'.tr()),
                          _Feature('paywall.feature_4'.tr()),
                          _Feature('paywall.feature_5'.tr()),
                        ],
                      ),
                    ).animate(delay: 200.ms).fadeIn(),

                    const SizedBox(height: 24),

                    // Plans
                    Row(
                      children: [
                        _PlanCard(
                          label: 'paywall.monthly'.tr(),
                          price: _getPrice(0),
                          period: '/mo',
                          isSelected: _selectedPlan == 0,
                          onTap: () => setState(() => _selectedPlan = 0),
                        ),
                        const SizedBox(width: 10),
                        _PlanCard(
                          label: 'paywall.yearly'.tr(),
                          price: _getPrice(1),
                          period: '/yr',
                          badge: 'paywall.best_value'.tr(),
                          isSelected: _selectedPlan == 1,
                          onTap: () => setState(() => _selectedPlan = 1),
                        ),
                        const SizedBox(width: 10),
                        _PlanCard(
                          label: 'paywall.lifetime'.tr(),
                          price: _getPrice(2),
                          period: '',
                          isSelected: _selectedPlan == 2,
                          onTap: () => setState(() => _selectedPlan = 2),
                        ),
                      ],
                    ).animate(delay: 300.ms).fadeIn(),

                    const SizedBox(height: 24),

                    PrimaryButton(
                      label: 'paywall.start_pro'.tr(),
                      onPressed: _purchase,
                      isLoading: _isLoading,
                    ).animate(delay: 400.ms).fadeIn(),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: () async {
                        await Purchases.restorePurchases();
                      },
                      child: Text('paywall.restore'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textMuted)),
                    ),

                    const SizedBox(height: 8),
                    Text('paywall.terms'.tr(), style: AppTextStyles.caption,
                        textAlign: TextAlign.center),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final String text;
  const _Feature(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Container(
          width: 22, height: 22,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded,
              color: AppColors.background, size: 13),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium
            .copyWith(color: AppColors.textPrimary))),
      ],
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String period;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.period,
    this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
                  ? AppColors.primary.withOpacity(0.7)
                  : AppColors.surfaceGlassBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              if (badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(badge!,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.background, fontSize: 9)),
                ),
                const SizedBox(height: 6),
              ],
              Text(label,
                  style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(price,
                  style: AppTextStyles.titleLarge.copyWith(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary),
                  textAlign: TextAlign.center),
              if (period.isNotEmpty)
                Text(period, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}
