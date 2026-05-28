import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/primary_button.dart';

class _Goal {
  final String title;
  final double target;
  final double current;
  final IconData icon;
  final Color color;

  const _Goal(this.title, this.target, this.current, this.icon, this.color);

  double get progress => (current / target).clamp(0.0, 1.0);
}

final _sampleGoals = [
  _Goal('New iPhone', 1200, 480, Icons.phone_iphone_rounded, AppColors.info),
  _Goal('Vacation', 3000, 1200, Icons.beach_access_rounded, AppColors.warning),
  _Goal('Emergency Fund', 5000, 2800, Icons.shield_rounded, AppColors.primary),
];

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Text('nav.goals'.tr(), style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => _showAddGoalSheet(context),
                      child: Container(
                        width: 40, height: 40,
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
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _sampleGoals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (ctx, i) {
                    final g = _sampleGoals[i];
                    return GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: g.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(g.icon, color: g.color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(g.title, style: AppTextStyles.titleLarge),
                              ),
                              Text(
                                '${(g.progress * 100).toInt()}%',
                                style: AppTextStyles.titleLarge.copyWith(color: g.color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: g.progress,
                              backgroundColor: g.color.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(g.color),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${g.current.toStringAsFixed(0)} saved',
                                style: AppTextStyles.bodySmall,
                              ),
                              Text(
                                'of \$${g.target.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate(delay: Duration(milliseconds: 80 * i)).fadeIn().slideY(begin: 0.1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('goals.add_goal'.tr(), style: AppTextStyles.headlineMedium),
            const SizedBox(height: 20),
            TextFormField(controller: titleCtrl, style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(hintText: 'goals.title_hint'.tr())),
            const SizedBox(height: 12),
            TextFormField(controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(hintText: 'goals.amount_hint'.tr())),
            const SizedBox(height: 20),
            PrimaryButton(label: 'goals.save'.tr(), onPressed: () => Navigator.pop(ctx)),
          ],
        ),
      ),
    );
  }
}
