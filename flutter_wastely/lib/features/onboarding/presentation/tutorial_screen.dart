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

class _TutorialPage {
  final IconData icon;
  final String titleKey;
  final String bodyKey;
  final Color color;

  const _TutorialPage(this.icon, this.titleKey, this.bodyKey, this.color);
}

const _pages = [
  _TutorialPage(
    Icons.bolt_rounded,
    'tutorial.page1_title',
    'tutorial.page1_body',
    AppColors.primary,
  ),
  _TutorialPage(
    Icons.search_rounded,
    'tutorial.page2_title',
    'tutorial.page2_body',
    AppColors.warning,
  ),
  _TutorialPage(
    Icons.flag_rounded,
    'tutorial.page3_title',
    'tutorial.page3_body',
    AppColors.info,
  ),
  _TutorialPage(
    Icons.lock_rounded,
    'tutorial.page4_title',
    'tutorial.page4_body',
    AppColors.primary,
  ),
];

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(onboardingCompleteProvider.notifier).complete();
    if (mounted) context.go(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _finish,
                    child: Text('common.skip'.tr(),
                        style: AppTextStyles.bodyMedium),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) {
                    final page = _pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: page.color.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: page.color.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: page.color.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(page.icon, color: page.color, size: 56),
                          )
                              .animate(key: ValueKey(i))
                              .scale(
                                begin: const Offset(0.7, 0.7),
                                duration: 500.ms,
                                curve: Curves.elasticOut,
                              )
                              .fadeIn(),

                          const SizedBox(height: 40),

                          Text(
                            page.titleKey.tr(),
                            style: AppTextStyles.displayMedium,
                            textAlign: TextAlign.center,
                          )
                              .animate(key: ValueKey('t$i'), delay: 150.ms)
                              .fadeIn()
                              .slideY(begin: 0.1),

                          const SizedBox(height: 16),

                          Text(
                            page.bodyKey.tr(),
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center,
                          )
                              .animate(key: ValueKey('b$i'), delay: 250.ms)
                              .fadeIn(),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.primary
                          : AppColors.textMuted,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: PrimaryButton(
                  label: _currentPage < _pages.length - 1
                      ? 'common.next'.tr()
                      : 'tutorial.get_started'.tr(),
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
