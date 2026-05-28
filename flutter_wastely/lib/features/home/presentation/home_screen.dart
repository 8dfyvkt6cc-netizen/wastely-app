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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final isPro = ref.watch(isProProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'home.greeting'.tr(args: [_firstName(user?.email)]),
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              'home.title'.tr(),
                              style: AppTextStyles.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                      if (!isPro)
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.paywall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Pro',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.background,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Balance card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _BalanceCard(currency: currency),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // One-Tap Leak Hunter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _LeakHunterBanner(),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // Quick stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('home.quick_stats'.tr(),
                      style: AppTextStyles.headlineMedium),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                  ),
                  delegate: SliverChildListDelegate([
                    _StatCard(
                      icon: Icons.trending_down_rounded,
                      label: 'home.this_month'.tr(),
                      value: '${_currencySymbol(currency)}1,240',
                      color: AppColors.error,
                      delay: 300,
                    ),
                    _StatCard(
                      icon: Icons.subscriptions_rounded,
                      label: 'home.subscriptions'.tr(),
                      value: '${_currencySymbol(currency)}89/mo',
                      color: AppColors.categoryEntertainment,
                      delay: 350,
                    ),
                    _StatCard(
                      icon: Icons.savings_rounded,
                      label: 'home.saved'.tr(),
                      value: '${_currencySymbol(currency)}340',
                      color: AppColors.success,
                      delay: 400,
                    ),
                    _StatCard(
                      icon: Icons.warning_amber_rounded,
                      label: 'home.leaks_found'.tr(),
                      value: '3',
                      color: AppColors.warning,
                      delay: 450,
                    ),
                  ]),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  String _firstName(String? email) {
    if (email == null) return '';
    return email.split('@').first.split('.').first;
  }

  String _currencySymbol(String code) {
    const map = {
      'USD': '\$',
      'EUR': '€',
      'THB': '฿',
      'RUB': '₽',
      'INR': '₹',
      'BRL': 'R\$',
      'GBP': '£',
    };
    return map[code] ?? '\$';
  }
}

class _BalanceCard extends StatelessWidget {
  final String currency;
  const _BalanceCard({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1F1A), Color(0xFF0A1510)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: AppColors.primary.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('home.monthly_waste'.tr(),
                  style: AppTextStyles.bodyMedium),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_downward_rounded,
                        color: AppColors.error, size: 12),
                    const SizedBox(width: 4),
                    Text('12%', style: AppTextStyles.caption.copyWith(
                        color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '\$1,240',
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.textPrimary,
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'home.vs_last_month'.tr(args: ['\$1,410']),
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('home.budget_used'.tr(),
                      style: AppTextStyles.bodySmall),
                  Text('62%', style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.62,
                  backgroundColor: AppColors.surfaceGlass,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.warning),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeakHunterBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.2),
              AppColors.primaryLight.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                ),
              ),
              child: const Icon(Icons.bolt_rounded,
                  color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home.leak_hunter_title'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'home.leak_hunter_subtitle'.tr(),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.primary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int delay;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: color)),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(begin: 0.1);
  }
}
