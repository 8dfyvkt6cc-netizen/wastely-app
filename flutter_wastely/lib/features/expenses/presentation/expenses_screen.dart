import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/app_providers.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';

class _Expense {
  final String title;
  final double amount;
  final String category;
  final Color color;
  final IconData icon;
  final String date;

  const _Expense(this.title, this.amount, this.category, this.color, this.icon, this.date);
}

final _sampleExpenses = [
  _Expense('Netflix', 15.99, 'Entertainment', AppColors.categoryEntertainment, Icons.play_circle_filled_rounded, 'May 28'),
  _Expense('Uber', 24.50, 'Transport', AppColors.categoryTransport, Icons.directions_car_rounded, 'May 27'),
  _Expense('Spotify', 9.99, 'Entertainment', AppColors.categoryEntertainment, Icons.music_note_rounded, 'May 27'),
  _Expense('Lunch', 18.00, 'Food', AppColors.categoryFood, Icons.restaurant_rounded, 'May 26'),
  _Expense('Gym', 49.00, 'Health', AppColors.categoryHealth, Icons.fitness_center_rounded, 'May 25'),
  _Expense('Amazon Prime', 14.99, 'Subscriptions', AppColors.categorySub, Icons.shopping_bag_rounded, 'May 24'),
];

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Text('nav.expenses'.tr(), style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showAddExpenseSheet(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                        ),
                        child: const Icon(Icons.add_rounded, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _sampleExpenses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final e = _sampleExpenses[i];
                    return GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: e.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(e.icon, color: e.color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title, style: AppTextStyles.titleLarge),
                                Text(e.category, style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '-\$${e.amount.toStringAsFixed(2)}',
                                style: AppTextStyles.titleLarge.copyWith(color: AppColors.error),
                              ),
                              Text(e.date, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ).animate(delay: Duration(milliseconds: 60 * i)).fadeIn().slideX(begin: 0.05);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddExpenseSheet(BuildContext context) {
    final amountCtrl = TextEditingController();
    final titleCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('expenses.add_expense'.tr(), style: AppTextStyles.headlineMedium),
            const SizedBox(height: 20),
            TextFormField(
              controller: titleCtrl,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(hintText: 'expenses.title_hint'.tr()),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(hintText: 'expenses.amount_hint'.tr()),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'expenses.save'.tr(),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
