# Wastely — AI Personal Finance Guard

> **Close money leaks in 30 seconds a day**

Dark-first Flutter app for iOS & Android with emerald green glassmorphism design.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🌍 **7 Languages** | EN, RU, TH, ES, HI, PT, AR — switchable at any time |
| 💱 **10 Currencies** | USD, EUR, THB, RUB, INR, BRL, GBP, JPY, CNY, AED |
| 🔒 **Math CAPTCHA** | Offline security check on registration — no API keys needed |
| ✉️ **Email Verification** | Firebase Auth sends verification link, app polls automatically |
| ⚡ **One-Tap Leak Hunter** | Scan all expenses for hidden waste in 30 seconds |
| 🎯 **Goals** | Savings goals with visual progress tracking |
| 💳 **Subscriptions** | RevenueCat — Monthly $4.99 / Yearly $49.99 / Lifetime $109 |
| 🌙 **Dark-First Design** | Glassmorphism, emerald `#00D4A5`, smooth animations |

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.19+ ([install](https://flutter.dev/docs/get-started/install))
- Dart 3.3+
- Firebase account ([console.firebase.google.com](https://console.firebase.google.com))
- RevenueCat account ([app.revenuecat.com](https://app.revenuecat.com))

### 1. Clone & install

```bash
git clone https://github.com/8dfyvkt6cc-netizen/wastely-app.git
cd wastely-app/flutter_wastely
flutter pub get
```

### 2. Firebase setup (required for auth)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create project **wastely**
3. Enable **Authentication → Email/Password**
4. Add **Android app** (package: `com.wastely.app`) → download `google-services.json` → place at `android/app/google-services.json`
5. Add **iOS app** (bundle: `com.wastely.app`) → download `GoogleService-Info.plist` → place at `ios/Runner/GoogleService-Info.plist`

### 3. RevenueCat setup (for subscriptions)

1. Create app at [RevenueCat](https://app.revenuecat.com)
2. Add your API keys in `lib/core/providers/revenuecat_provider.dart`
3. Create products in App Store Connect / Google Play Console:
   - `wastely_monthly` — $4.99/month
   - `wastely_yearly` — $49.99/year  
   - `wastely_lifetime` — $109 one-time

### 4. Run the app

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Debug on any device
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point, Firebase + localization init
├── app.dart                     # MaterialApp.router, theme, locale
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Brand colors (#00D4A5 primary)
│   │   └── app_text_styles.dart # Inter font, all text styles
│   ├── theme/app_theme.dart     # Dark MaterialTheme
│   ├── router/app_router.dart   # GoRouter with slide/fade transitions
│   └── providers/app_providers.dart  # Riverpod: language, currency, pro
│
├── features/
│   ├── auth/
│   │   ├── splash_screen.dart         # Auto-routes based on auth state
│   │   ├── login_screen.dart          # Email + password + forgot password
│   │   ├── register_screen.dart       # Email + password + MATH CAPTCHA
│   │   └── email_verification_screen.dart  # Auto-polls Firebase, resend
│   │
│   ├── onboarding/
│   │   ├── language_selection_screen.dart  # 7 languages with flags
│   │   ├── currency_selection_screen.dart  # 10 currencies, grid layout
│   │   └── tutorial_screen.dart            # 4-page swipeable tutorial
│   │
│   ├── home/
│   │   ├── main_shell.dart      # Bottom nav shell (4 tabs)
│   │   └── home_screen.dart     # Balance card, stats, Leak Hunter banner
│   ├── expenses/
│   │   └── expenses_screen.dart # List + add expense bottom sheet
│   ├── goals/
│   │   └── goals_screen.dart    # Goals with progress bars
│   ├── settings/
│   │   └── settings_screen.dart # Language picker, currency picker, sign out
│   └── subscriptions/
│       └── paywall_screen.dart  # RevenueCat paywall, 3 plan cards
│
└── shared/widgets/
    ├── glass_card.dart           # Glassmorphism card (BackdropFilter)
    ├── primary_button.dart       # Animated gradient button with haptics
    └── gradient_background.dart  # Dark bg + emerald glow orbs

assets/
└── translations/
    ├── en.json  ru.json  th.json  es.json  hi.json  pt.json  ar.json
```

---

## 🔐 Registration Flow (CAPTCHA + Email Verification)

```
Register Screen
  ↓
[Email] [Password] [Confirm Password]
  ↓
[Math CAPTCHA] — e.g. "7 × 3 = ?" — offline, no API keys
  ↓ (correct answer)
Firebase createUserWithEmailAndPassword()
  ↓
Firebase sendEmailVerification()
  ↓
Email Verification Screen
  ← polls Firebase every 3 seconds
  ← user clicks link in email
  ↓ (emailVerified == true)
Home Screen
```

---

## 🌍 Localization

- Engine: `easy_localization`
- Files: `assets/translations/*.json`
- 7 languages: English, Russian, Thai, Spanish, Hindi, Portuguese, Arabic
- RTL support: Arabic auto-applies RTL layout

To add a new language:
1. Add `assets/translations/XX.json`
2. Add `Locale('XX')` to `supportedLocales` in `main.dart`
3. Add entry to `_languages` list in `language_selection_screen.dart` and `settings_screen.dart`

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Navigation with typed routes |
| `firebase_auth` | Email auth + verification |
| `easy_localization` | i18n (7 languages) |
| `purchases_flutter` | RevenueCat subscriptions |
| `flutter_animate` | Smooth UI animations |
| `shared_preferences` | Persist language/currency selection |

---

## 🏪 App Store Submission

- **Bundle ID**: `com.wastely.app`
- **Min iOS**: 13.0
- **Min Android**: API 21 (Android 5.0)
- **Privacy**: No data sold, local-first storage, Firebase Auth only

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#00D4A5` |
| Background | `#0A0A0F` |
| Surface | `#111118` |
| Glass | `rgba(255,255,255,0.10)` |
| Font | Inter (Regular/Medium/SemiBold/Bold) |
| Border radius | 16–24px |

---

## 📝 License

MIT © 2025 Wastely
