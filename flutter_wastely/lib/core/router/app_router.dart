import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/email_verification_screen.dart';
import '../../features/onboarding/presentation/language_selection_screen.dart';
import '../../features/onboarding/presentation/currency_selection_screen.dart';
import '../../features/onboarding/presentation/tutorial_screen.dart';
import '../../features/home/presentation/main_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/onboarding/language';
  static const String currencySelection = '/onboarding/currency';
  static const String tutorial = '/onboarding/tutorial';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String emailVerification = '/auth/verify-email';
  static const String home = '/home';
  static const String expenses = '/home/expenses';
  static const String leakHunter = '/home/leak-hunter';
  static const String goals = '/home/goals';
  static const String subscriptions = '/home/subscriptions';
  static const String settings = '/settings';
  static const String paywall = '/paywall';
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelection,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const LanguageSelectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.currencySelection,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const CurrencySelectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.tutorial,
        pageBuilder: (context, state) => _fadeTransition(
          state,
          const TutorialScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _slideTransition(
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _slideTransition(
          state,
          const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return EmailVerificationScreen(email: email);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const _HomeTab(),
          ),
          GoRoute(
            path: AppRoutes.expenses,
            builder: (context, state) => const _ExpensesTab(),
          ),
          GoRoute(
            path: AppRoutes.goals,
            builder: (context, state) => const _GoalsTab(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const _SettingsTab(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Text(
          'Page not found',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  );
});

CustomTransitionPage<void> _fadeTransition(
    GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideTransition(
    GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
    },
  );
}

// Placeholder tab widgets (will be replaced by actual screens in shell)
class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _ExpensesTab extends StatelessWidget {
  const _ExpensesTab();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _GoalsTab extends StatelessWidget {
  const _GoalsTab();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
