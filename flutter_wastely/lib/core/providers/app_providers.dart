import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── SharedPreferences ───────────────────────────────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize before runApp()');
});

// ─── Language ────────────────────────────────────────────────────────────────
const _langKey = 'app_language_code';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier(this._prefs) : super(_prefs.getString(_langKey) ?? 'en');

  final SharedPreferences _prefs;

  Future<void> setLanguage(String code) async {
    state = code;
    await _prefs.setString(_langKey, code);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LanguageNotifier(prefs);
});

// ─── Currency ─────────────────────────────────────────────────────────────────
const _currencyKey = 'app_currency_code';

class CurrencyNotifier extends StateNotifier<String> {
  CurrencyNotifier(this._prefs) : super(_prefs.getString(_currencyKey) ?? 'USD');

  final SharedPreferences _prefs;

  Future<void> setCurrency(String code) async {
    state = code;
    await _prefs.setString(_currencyKey, code);
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CurrencyNotifier(prefs);
});

// ─── Onboarding ───────────────────────────────────────────────────────────────
const _onboardingKey = 'onboarding_complete';

final onboardingCompleteProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingNotifier(prefs);
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._prefs)
      : super(_prefs.getBool(_onboardingKey) ?? false);

  final SharedPreferences _prefs;

  Future<void> complete() async {
    state = true;
    await _prefs.setBool(_onboardingKey, true);
  }
}

// ─── Pro subscription state (local cache) ────────────────────────────────────
final isProProvider = StateNotifierProvider<ProNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProNotifier(prefs);
});

class ProNotifier extends StateNotifier<bool> {
  ProNotifier(this._prefs) : super(_prefs.getBool('is_pro') ?? false);

  final SharedPreferences _prefs;

  Future<void> setPro(bool value) async {
    state = value;
    await _prefs.setBool('is_pro', value);
  }
}
