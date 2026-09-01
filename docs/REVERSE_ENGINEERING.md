# REVERSE ENGINEERING — RARE Mobile Application

> **Document purpose:** Complete technical reverse-engineering of the `rare_mobile_app` Flutter codebase.
> Generated from analysis of every source file in `lib/`, `pubspec.yaml`, and build configuration.

---

## 1. Mobile Framework

| Aspect | Detail |
|---|---|
| **Framework** | Flutter 3.x (Dart SDK `^3.12.2`) |
| **State management** | `flutter_riverpod ^2.5.1` — ProviderScope wraps entire app in `main.dart`; `GoRouter` injected via `Provider<GoRouter>` |
| **Routing** | `go_router ^13.2.0` — flat `GoRoute` list (no nested routes), `initialLocation` set to `/auth/splash` |
| **Typography** | `google_fonts ^6.1.0` — Playfair Display (headings/display), Jost (body/labels), Cormorant Garamond (quotes) |
| **Date formatting** | `intl ^0.19.0` — declared dependency but not yet imported in any screen (available for future use) |
| **Icons** | `cupertino_icons ^1.0.8` — Material Icons used throughout (`Icons.*`), no custom SVGs yet |
| **Build platforms** | android, ios, linux, macos, web, windows directories present |

### Design System Constants

| Token | Value | Usage |
|---|---|---|
| `AppColors.cream` | `#FAF4EE` | Background, scaffold |
| `AppColors.linen` | `#F2DDD5` | Card surfaces, inactive elements |
| `AppColors.rose` | `#C9897A` | Primary actions, active chips |
| `AppColors.gold` | `#D4AF7A` | Accent, eyebrow labels, borders |
| `AppColors.terracotta` | `#A4594A` | Danger, today-highlight, destructive |
| `AppColors.mocha` | `#2E1A1A` | Text primary, button fill |
| `AppColors.mauve` | `#7A4A4A` | Text secondary |
| `AppColors.grey` | `#B09080` | Hints, captions, inactive dots |

### Typography Scale

| Style | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `displayLarge` | Playfair Display | 34px | w300 | Hero headings |
| `displayMedium` | Playfair Display | 26px | w400 | Screen titles |
| `displaySmall` | Playfair Display | 21px | w300 | Section headings |
| `headlineMedium` | Playfair Display | 18px | w400 | Card titles |
| `titleLarge` | Playfair Display | 16px | w600 | Sub-section headings |
| `bodyMedium` | Jost | 13.5px | w300 | Primary body copy |
| `bodySmall` | Jost | 11px | w300 | Captions, helper text |
| `labelSmall` | Jost | 9px | w400, ls:5 | Eyebrow labels |
| `quote` | Cormorant Garamond | 20px | w300 italic | Inspirational quotes |
| `eyebrow` | Jost | 9px | w400, ls:5 | Date/category eyebrows |

---

## 2. Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Core framework |
| `flutter_riverpod` | `^2.5.1` | State management / DI |
| `go_router` | `^13.2.0` | Declarative routing |
| `google_fonts` | `^6.1.0` | Custom typography |
| `intl` | `^0.19.0` | Date/number formatting |
| `cupertino_icons` | `^1.0.8` | iOS-style icons |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Unit/widget testing |
| `flutter_lints` | `^6.0.0` | Lint rules |

### Notable Absences (would be needed for full implementation)

- `http` / `dio` — no HTTP client
- `flutter_riverpod` hooks — no `hooks_riverpod`
- `shared_preferences` / `flutter_secure_storage` — no local persistence
- `image_picker` / `camera` — camera referenced in UI but not wired
- `razorpay_flutter` — payment referenced in plan but not in pubspec
- `sign_in_with_apple` / `google_sign_in` — OAuth referenced in UI but not in pubspec
- `health` / `fit_kit` — wearable integration referenced but not in pubspec
- `firebase_messaging` — push notifications not declared
- `webview_flutter` — booking webview simulated, not wired
- `cached_network_image` — no image caching

---

## 3. Route Structure (45 routes)

All routes defined in `lib/core/routes/route_names.dart`, consumed by `lib/core/routes/app_routes.dart` via `GoRouter`.

| # | Path | Name Constant | Route Name | Screen Class |
|---|---|---|---|---|
| 1 | `/auth/splash` | `splashReturning` | `splash` | `SplashReturningScreen` |
| 2 | `/onboarding/welcome` | `welcome` | `welcome` | `WelcomeScreen` |
| 3 | `/onboarding/soft-scan` | `softScan` | `softScan` | `SoftScanScreen` |
| 4 | `/onboarding/account-sync` | `accountSync` | `accountSync` | `AccountSyncScreen` |
| 5 | `/onboarding/privacy-gate` | `privacyGate` | `privacyGate` | `PrivacyGateScreen` |
| 6 | `/onboarding/cycle-baseline` | `cycleBaseline` | `cycleBaseline` | `CycleBaselineScreen` |
| 7 | `/onboarding/wearable-connection` | `wearableConnection` | `wearableConnection` | `WearableConnectionScreen` |
| 8 | `/onboarding/aura-awakening` | `auraAwakening` | `auraAwakening` | `AuraAwakeningScreen` |
| 9 | `/home` | `home` | `home` | `HomeScreen` |
| 10 | `/checkin/am` | `amCheckin` | `amCheckin` | `AMCheckinScreen` |
| 11 | `/checkin/pm` | `pmCheckin` | `pmCheckin` | `PMCheckinScreen` |
| 12 | `/skin/log` | `skinLog` | `skinLog` | `SkinLogScreen` |
| 13 | `/skin/quick` | `quickLog` | `quickLog` | `QuickLogScreen` |
| 14 | `/shelf` | `shelf` | `shelf` | `ShelfScreen` |
| 15 | `/routine/builder` | `routineBuilder` | `routineBuilder` | `RoutineBuilderScreen` |
| 16 | `/insights/biweekly` | `biweeklyWrapped` | `biweeklyWrapped` | `BiweeklyWrappedScreen` |
| 17 | `/insights/monthly` | `monthlySynthesis` | `monthlySynthesis` | `MonthlySynthesisScreen` |
| 18 | `/insights/pulse` | `pulseFeed` | `pulseFeed` | `PulseFeedScreen` |
| 19 | `/insights/intervention-log` | `routineInterventionLog` | `routineInterventionLog` | `RoutineInterventionLogScreen` |
| 20 | `/insights/environmental` | `environmentalMap` | `environmentalMap` | `EnvironmentalMapScreen` |
| 21 | `/insights/precision-profile` | `precisionProfile` | `precisionProfile` | `PrecisionProfileScreen` |
| 22 | `/commerce/optimize` | `optimizeShelf` | `optimizeShelf` | `OptimizeShelfScreen` |
| 23 | `/commerce/plan-relief` | `planMyRelief` | `planMyRelief` | `PlanMyReliefScreen` |
| 24 | `/commerce/booking` | `bookingWebview` | `bookingWebview` | `BookingWebviewScreen` |
| 25 | `/commerce/depletion` | `depletionConfirmation` | `depletionConfirmation` | `DepletionConfirmationScreen` |
| 26 | `/settings` | `settings` | `settings` | `SettingsScreen` |
| 27 | `/settings/privacy` | `privacyDashboard` | `privacyDashboard` | `PrivacyDashboardScreen` |
| 28 | `/settings/kill-switch` | `killSwitch` | `killSwitch` | `KillSwitchScreen` |
| 29 | `/calendar/cycle` | `cycleCalendar` | `cycleCalendar` | `CycleCalendarScreen` |
| 30 | `/home/dormant` | `dormantState` | `dormantState` | `DormantStateScreen` |
| 31 | `/error-empty` | `errorEmpty` | `errorEmpty` | `ErrorEmptyScreen` |
| 32 | `/orders/history` | `orderHistory` | `orderHistory` | `OrderBookingHistoryScreen` |
| 33 | `/profile/credits` | `creditsLedger` | `creditsLedger` | `CreditsLedgerScreen` |
| 34 | `/profile/hub` | `profileHub` | `profileHub` | `ProfileHubScreen` |
| 35 | `/profile/data-log` | `dataLogEdit` | `dataLogEdit` | `DataLogEditHistoryScreen` |
| 36 | `/profile/skin-timeline` | `skinProgressTimeline` | `skinProgressTimeline` | `SkinProgressTimelineScreen` |
| 37 | `/home/quiet-inbox` | `quietInbox` | `quietInbox` | `QuietInboxScreen` |
| 38 | `/legal/documents` | `legalDocuments` | `legalDocuments` | `LegalDocumentsScreen` |
| 39 | `/checkout/state` | `checkoutState` | `checkoutState` | `CheckoutStateScreen` |
| 40 | `/support/help` | `helpSupport` | `helpSupport` | `HelpSupportScreen` |
| 41 | `/rituals` | `rituals` | `rituals` | `RareRitualsScreen` |
| 42 | `/b2b/practitioner-login` | `practitionerLogin` | `practitionerLogin` | `PractitionerLoginScreen` |
| 43 | `/b2b/pre-treatment` | `preTreatmentSync` | `preTreatmentSync` | `PreTreatmentSyncScreen` |
| 44 | `/b2b/post-treatment` | `postTreatmentProtocol` | `postTreatmentProtocol` | `PostTreatmentProtocolScreen` |
| 45 | `/profile/account-details` | `accountDetails` | `accountDetails` | `AccountDetailsScreen` |

---

## 4. Screen Inventory (45 screens across 18 categories)

### Splash (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/splash/screen_37_splash_returning.dart` | `SplashReturningScreen` | StatelessWidget | Entry point. Shows dimmed Aura, offers three paths: OAuth (linked accounts), Face ID/Touch ID (anonymous users), or Create Account (new device). Checks for existing session token on launch. |

### Onboarding (7 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/onboarding/screen_01_welcome.dart` | `WelcomeScreen` | StatelessWidget | Hero screen with animated AuraWidget (non-breathing, opacity 0.3), tagline "A new way of being known." and "A note left on a pillow." Begin button navigates to soft scan. |
| `lib/screens/onboarding/screen_02_soft_scan.dart` | `SoftScanScreen` | StatefulWidget | Camera-based skin type detection. State: `scanFailed`, `selectedSkinType`. Falls back to manual skin type selection (Dry/Oily/Combo/Sensitive) if scan fails. Skip option available. |
| `lib/screens/onboarding/screen_03_account_sync.dart` | `AccountSyncScreen` | StatelessWidget | OAuth account linking via RARE account. Primary action: "Connect My Account". Ghost button: "Skip for now — start anonymously". Anonymous path creates local profile with empty shelf and dormant Auto-Swap. |
| `lib/screens/onboarding/screen_04_privacy_gate.dart` | `PrivacyGateScreen` | StatefulWidget | Granular consent toggles: Phone activity, Pin code, Cycle tracking, Skin photo storage, Purchase history, Wearable & health data. Each toggle described as "Used only for the feature it names." |
| `lib/screens/onboarding/screen_05_cycle_baseline.dart` | `CycleBaselineScreen` | StatelessWidget | Calendar grid (28-day) for marking last period start date. Simulated day 12 marked, day 14 highlighted as today. Save Baseline or Skip options. |
| `lib/screens/onboarding/screen_06_wearable_connection.dart` | `WearableConnectionScreen` | StatelessWidget | Apple Health and Google Fit connection cards with Connect buttons. Skip option. Copy: "No wearable? RARE works just as well without one." |
| `lib/screens/onboarding/screen_07_aura_awakening.dart` | `AuraAwakeningScreen` | StatelessWidget | Final onboarding screen. Animated breathing AuraWidget (opacity 0.6). "Meet your Aura. Right now, it's resting. Let's wake it up." Button: "Begin Your First Check-in" → AM Check-in. |

### Home (3 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/home/screen_08_home.dart` | `HomeScreen` | StatelessWidget | Main dashboard. Shows formatted date (eyebrow), breathing AuraWidget (opacity 0.9), daily quote, Hydration Vessel (55% fill, "4 of 8 taps"), nav icons for Shelf/Quick Log/Insights. Top bar: Quiet Inbox (leaf icon), Insights (moon), Shopping Bag icons. |
| `lib/screens/home/screen_29_dormant_state.dart` | `DormantStateScreen` | StatelessWidget | Dormant Aura state after missed check-ins. Dimmed Aura (opacity 0.18, scale 0.6). "Welcome back. The garden missed the sun." Check In button → AM Check-in. |
| `lib/screens/home/screen_36_quiet_inbox.dart` | `QuietInboxScreen` | StatelessWidget | Timeline of missed passive nudges. Hardcoded items: "Your skin log is ready to add today" (2h ago), "Your routine has been prepared" (1d ago), "A new insight is ready to view" (2d ago). Auto-clears on read/expire. No badge counts. |

### Check-in (2 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/checkin/screen_09_am_checkin.dart` | `AMCheckinScreen` | StatefulWidget | Morning check-in. State: `mood` (slider 0.0-1.0, default 0.65), `selectedTags` (list). Sections: Sleep inference from phone stillness ("7h 12m — sound about right?" with Yes/Adjust), Mood slider, Context tags (Sick/Travel/Stress). "Save & Return to Home" button. |
| `lib/screens/checkin/screen_10_pm_checkin.dart` | `PMCheckinScreen` | StatefulWidget | Evening check-in. State: `stress` (slider 0.0-1.0, default 0.35). Shows AuraWidget (non-breathing, opacity 0.6, scale 0.8), Stress slider, "Log & Rest" button. |

### Skin (3 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/skin/screen_11_skin_log.dart` | `SkinLogScreen` | StatefulWidget | Detailed skin logging. State: `selectedTags` (list). Tags: Tight, Dry, Oily, Sensitive, Calm, Dull. Optional photo capture for Progress Timeline. "Save Skin Log" → Home. |
| `lib/screens/skin/screen_12_quick_log.dart` | `QuickLogScreen` | StatelessWidget | One-tap logging for Caffeine, Alcohol, Energy. Each with Log button. Time inferred automatically. |
| `lib/screens/skin/screen_35_skin_progress_timeline.dart` | `SkinProgressTimelineScreen` | StatefulWidget | Horizontal scrollable photo timeline. State: `_photos` (List of `_SkinPhotoEntry` with tags, date, color). 7 hardcoded entries from Jul 8 to Jul 22. Tap for details, long-press/delete to remove. Deleted photos flagged "ignored, never trained on." |

### Shelf (2 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/shelf/screen_13_shelf.dart` | `ShelfScreen` | StatelessWidget | Product shelf with status indicators: "Barrier Repair Serum" (Standard/rose), "Vitamin C Elixir" (Armed/terracotta), "Gentle Exfoliant" (Depleted/grey). Tap for Contextual Reveal. |
| `lib/screens/shelf/screen_24_depletion_confirmation.dart` | `DepletionConfirmationScreen` | StatelessWidget | "Honest Guess" restock flow. "Still have some of your Vitamin C Elixir?" with "Still have some" (pop) and "Need to restock" (→ Optimize Shelf) buttons. |

### Routine (2 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/routine/screen_14_routine_builder.dart` | `RoutineBuilderScreen` | StatelessWidget | 4-step routine: Cleanse, Treat, Moisturize, SPF. Each step has product selector and AM/PM/Both chip. Text input for non-RARE products ("e.g. Cetaphil Cleanser"). "Save My Routine" → Home. |
| `lib/screens/routine/screen_18_routine_intervention_log.dart` | `RoutineInterventionLogScreen` | StatelessWidget | Timeline of routine changes. Hardcoded entries: "Paused Retinol" (ALGORITHM, 2d ago), "Swapped to Barrier Serum" (AUTO_SWAP, 5d ago), "Recommended SPF increase" (PRACTITIONER, 1 week ago), "Corrected Sleep to 6h" (MANUAL_EDIT, 1 week ago). |

### Insights (6 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/insights/screen_15_biweekly_wrapped.dart` | `BiweeklyWrappedScreen` | StatelessWidget | 14-day pattern report. Correlation card: "late coffees and restless mornings" with ConfidenceMeter (2/3 filled). RARE Pulse card (mocha bg): "4,200 women with your Precision Profile restocked this serum this month." |
| `lib/screens/insights/screen_16_monthly_synthesis.dart` | `MonthlySynthesisScreen` | StatelessWidget | Monthly deep-pattern analysis. High-confidence card: "coffee past 2pm → lower sleep 70% of time" with ConfidenceMeter (3/3). Cycle correlation note. Empty-state: "No deep patterns surfaced this month." |
| `lib/screens/insights/screen_17_rare_pulse_feed.dart` | `PulseFeedScreen` | StatelessWidget | Aggregated member insights. "4,200 women restocked this serum." "Trending — barrier-repair rituals." Suppression note: below 100-user segment threshold, profile-specific cards suppressed. |
| `lib/screens/insights/screen_19_environmental_map.dart` | `EnvironmentalMapScreen` | StatelessWidget | AQI/PM2.5 map (simulated). Map placeholder. "AQI history for your pin code, plotted against logged skin states." Fallback: "Air quality data isn't available for your specific area." |
| `lib/screens/insights/screen_20_precision_profile.dart` | `PrecisionProfileScreen` | StatelessWidget | Composite scores: Hydration Index (72), Barrier Function (78), Sebum Balance (65), Sensitivity Score (55). Each with LinearProgressIndicator and ChipTag score. |

### Commerce / Booking (4 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/booking/screen_21_optimize_shelf.dart` | `OptimizeShelfScreen` | StatelessWidget | Contextual Reveal for product recommendations. "Would you like to optimize your shelf with a Barrier Repair Serum?" Anonymous-user intercept and offline intercept notes in code. Simulated webview chrome (relaxedandrefresh.com). |
| `lib/screens/booking/screen_22_plan_my_relief.dart` | `PlanMyReliefScreen` | StatelessWidget | Booking prompt for facial. "Would a guided facial help with what you've been feeling?" Based on skin logs. "See Available Slots" → Booking Webview. |
| `lib/screens/booking/screen_23_booking_webview.dart` | `BookingWebviewScreen` | StatelessWidget | Simulated webview with booking details. "THURSDAY · 3:30 PM / Restorative Facial — 60 min". Confirm & Pay button (triggers payment flow stub). Cancel button. |
| `lib/screens/booking/screen_39_checkout_state.dart` | `CheckoutStateScreen` | StatelessWidget | Success/failure state screen. Takes `isSuccess` bool. Success: checkmark icon, "Your ritual is booked for Thursday." Failure: "Something went wrong with that payment. The slot wasn't held." Retry and Back to Wellness buttons. |

### Settings (4 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/settings/screen_25_settings.dart` | `SettingsScreen` | StatefulWidget | Notification cadence toggles: AM Check-in reminder, PM Check-in reminder, Insight-ready nudges. Push permission fallback card with "Enable Push Notifications" button → OS settings deep-link. |
| `lib/screens/settings/screen_26_privacy_dashboard.dart` | `PrivacyDashboardScreen` | StatefulWidget | Granular consent management: Phone activity, Pin code, Cycle tracking, Skin photos, Purchase history, Wearable data. Pin code editor ("411001 — Pune"). Download My Data (email export). Privacy Policy link. |
| `lib/screens/settings/screen_27_kill_switch.dart` | `KillSwitchScreen` | StatefulWidget | Two-step deletion flow. First: "Delete all app data?" with warnings about bookings and Apple Health/Google Fit. Second: "Are you absolutely sure?" with active booking notice. Final: confirmation dialog, navigates to splash. |
| `lib/screens/settings/screen_32_credits_ledger.dart` | `CreditsLedgerScreen` | StatelessWidget | Credits balance (₹340, 1 Credit = ₹1) and transaction history: +10 AM Check-in, +15 14-Day Resonance, +50 Refund Reflexology, -120 Ritual Spend, +8 Ritual Completed. "Credits apply automatically at checkout on the web." |

### Calendar (2 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/calendar/screen_28_cycle_calendar.dart` | `CycleCalendarScreen` | StatefulWidget | Full 28-day cycle calendar. State: `_isPaused`, marked days (10-14), today (15). Pause toggle: "For pregnancy, postpartum, PCOS, or any reason a regular cycle isn't active." Resume button when paused. Legend: Predicted/Logged (rose), Today (terracotta), Regular (linen). |
| `lib/screens/calendar/screen_34_data_log_edit_history.dart` | `DataLogEditHistoryScreen` | StatefulWidget | Calendar view for reviewing/editing past logs. State: `_selectedDay`, `_sleep`, `_mood`, `_skin`, `_hydration`. Tap any day to load logs (simulated data by day % 3). Edit dialog with text fields. "Corrections are never silent — logged as an Edited event." |

### Error / Empty (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/error/screen_30_error_empty.dart` | `ErrorEmptyScreen` | StatelessWidget | Collection of brand-voiced empty/error states: Network error ("Something feels off"), Environmental data failure, Early days ("We are listening"), Empty shelf, Quiet inbox empty, No interventions, Early credits. |

### Splash (1 screen — counted in section above)

### Profile (3 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/profile/screen_33_profile_hub.dart` | `ProfileHubScreen` | StatelessWidget | Central account directory. Links: Settings, Privacy Dashboard, Cycle Calendar, Order & Booking History, Credits Ledger, Account Details, The Kill Switch. Bottom card: "Connected as anon_profile" with Connect RARE Account button → Account Sync. |
| `lib/screens/profile/screen_45_account_details.dart` | `AccountDetailsScreen` | StatefulWidget | Editable name/email/phone fields. Pre-filled: "Priya Sharma", "priya@example.com", "+91 98765 43210". Email changes require OAuth re-authorization. Phone changes trigger OTP verification (6-digit). Save Changes button. |

### Support (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/support/screen_40_help_support.dart` | `HelpSupportScreen` | StatelessWidget | Support directory: Manage Bookings, Report a Data Issue (firewalled — staff see only flagged insight + note), Contact Concierge. Firewall note: "staff see only the flagged insight and her note, never raw biometric logs." |

### Legal (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/legal/screen_38_legal_documents.dart` | `LegalDocumentsScreen` | StatelessWidget | Native-rendered Privacy Policy. Sections: Introduction (DPDP reference), What We Collect, How We Use It, Your Rights (DPDP), Data Security, Contact. Last updated: July 2026. |

### Orders (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/orders/screen_31_order_booking_history.dart` | `OrderBookingHistoryScreen` | StatelessWidget | Split view: UPCOMING (Restorative Facial — Thu 3:30 PM, RARE Studio Bengaluru, check-in QR placeholder, Manage Booking button) and PAST (Barrier Repair Serum 12 Jul, Guided Reflexology 2 Jul, Restorative Facial 22 Jun). |

### Rituals (1 screen)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/rituals/screen_41_rare_rituals.dart` | `RareRitualsScreen` | StatelessWidget | Featured: "Morning Calm" guided breathwork with pulsing AuraWidget, progress bar (40%), playback controls (replay 10s, play/pause, forward 10s), time display "4:12 / 10:30". Library: "Ingredient Science: Niacinamide" (Education), "Barrier Recovery Reflection" (Reflection), "Morning Gratitude Practice" (Morning Calm), "Evening Wind-Down" (Evening). |

### B2B / Practitioner (3 screens)

| File | Class | Type | Description |
|---|---|---|---|
| `lib/screens/b2b/screen_42_practitioner_login.dart` | `PractitionerLoginScreen` | StatelessWidget | Credentialed esthetician view. Client summary: "Priya S." with skin type, recent tags, visit/insight/log counts. Start Appointment and View Full Profile buttons. Security notice: "Wiped from tablet storage the moment the appointment is marked complete." |
| `lib/screens/b2b/screen_43_pre_treatment_sync.dart` | `PreTreatmentSyncScreen` | StatefulWidget | Pre-appointment data sharing. State: `shareSkinLogs`, `shareInsights`, `shareRoutine` (all default true). "Heads-up, not prerequisite" framing. Practitioner name: "Anjali". Privacy assurance: "Shared data is read-only, session-limited, and wiped after your appointment." Share Selected or Skip buttons. |
| `lib/screens/b2b/screen_44_post_treatment_protocol.dart` | `PostTreatmentProtocolScreen` | StatefulWidget | Post-treatment recommendations. Defensive (auto-applied): "Pause your current exfoliant for 5 days" with APPLIED badge. Offensive (suggestions queue): "SPF 50 Recommended", "Barrier Recovery Mask" — each with "Review on My Shelf" → Shelf. Audit trail note: "Practitioner judgment is logged in the unified audit trail." |

---

## 5. Actions and Interactions

### Onboarding Flow

| Screen | Action | Target |
|---|---|---|
| Welcome | `PrimaryButton("Begin →")` | → Soft Scan |
| Soft Scan | `PrimaryButton("Allow Camera")` | → Account Sync (simulated) |
| Soft Scan | `GhostButton("Skip Scan")` | Sets `scanFailed = true`, shows manual skin type selector |
| Soft Scan | `ChipTag("Dry"/"Oily"/"Combo"/"Sensitive")` | Selects `selectedSkinType` |
| Soft Scan | `PrimaryButton("Continue")` | → Account Sync |
| Account Sync | `PrimaryButton("Connect My Account")` | → Privacy Gate |
| Account Sync | `GhostButton("Skip for now — start anonymously")` | → Privacy Gate |
| Privacy Gate | `ToggleRow` × 6 | Toggles consent categories |
| Privacy Gate | `PrimaryButton("Continue")` | → Cycle Baseline |
| Cycle Baseline | `GridView` day selection | Selects period start date |
| Cycle Baseline | `PrimaryButton("Save Baseline")` | → Wearable Connection |
| Cycle Baseline | `GhostButton("Skip — I'll set this up later")` | → Wearable Connection |
| Wearable Connection | `GhostButton("Connect")` × 2 | Apple Health / Google Fit (stubs) |
| Wearable Connection | `GhostButton("Skip for now")` | → Aura Awakening |
| Aura Awakening | `PrimaryButton("Begin Your First Check-in")` | → AM Check-in |

### Home Screen

| Screen | Action | Target |
|---|---|---|
| Home | `IconButton(Icons.circle_outlined)` | → Quiet Inbox |
| Home | `IconButton(Icons.nights_stay)` | → Biweekly Wrapped |
| Home | `IconButton(Icons.shopping_bag)` | → Optimize Shelf |
| Home | `_navIcon(Icons.shopping_basket, 'Shelf')` | → Shelf |
| Home | `_navIcon(Icons.eco, 'Quick Log')` | → Quick Log |
| Home | `_navIcon(Icons.nights_stay, 'Insights')` | → Biweekly Wrapped |
| Home | `HydrationVessel` tap | Logs hydration tap |
| Dormant State | `PrimaryButton("Check In")` | → AM Check-in |

### Check-in Flow

| Screen | Action | Target |
|---|---|---|
| AM Check-in | `Slider` (mood) | Adjusts mood value (0.0-1.0) |
| AM Check-in | `GhostButton("Yes")` / `GhostButton("Adjust")` | Confirms/adjusts sleep inference |
| AM Check-in | `ChipTag("Sick"/"Travel"/"Stress")` | Toggles context tags |
| AM Check-in | `PrimaryButton("Save & Return to Home")` | → Home |
| PM Check-in | `Slider` (stress) | Adjusts stress value (0.0-1.0) |
| PM Check-in | `PrimaryButton("Log & Rest")` | → Home |

### Skin Logging

| Screen | Action | Target |
|---|---|---|
| Skin Log | `ChipTag` × 6 (Tight/Dry/Oily/Sensitive/Calm/Dull) | Toggles skin tags |
| Skin Log | `GhostButton("Add Photo")` | Camera picker (stub) |
| Skin Log | `PrimaryButton("Save Skin Log")` | → Home |
| Quick Log | `GhostButton("Log")` × 3 (Caffeine/Alcohol/Energy) | Logs quick entry |
| Skin Progress Timeline | `GestureDetector` on photo | Shows details |
| Skin Progress Timeline | `GestureDetector` on delete icon | Delete confirmation dialog |
| Skin Progress Timeline | `TextButton("Delete")` in dialog | Removes photo, flags as ignored |

### Shelf & Commerce

| Screen | Action | Target |
|---|---|---|
| Shelf | `ListTileWidget` tap | Contextual Reveal (stub) |
| Depletion Confirmation | `GhostButton("Still have some")` | Pops screen |
| Depletion Confirmation | `PrimaryButton("Need to restock")` | → Optimize Shelf |
| Optimize Shelf | `PrimaryButton("Yes, show me")` | → Booking Webview |
| Plan My Relief | `PrimaryButton("See Available Slots")` | → Booking Webview |
| Booking Webview | `PrimaryButton("Confirm & Pay")` | Payment flow (stub) |
| Booking Webview | `GhostButton("Cancel")` | Pop screen |
| Checkout State | `GhostButton("Return to Wellness")` (success) | → Home |
| Checkout State | `PrimaryButton("Retry")` / `GhostButton("Back to Wellness")` (failure) | Pop / → Home |

### Insights

| Screen | Action | Target |
|---|---|---|
| Biweekly Wrapped | Static display | No actions |
| Monthly Synthesis | Static display | No actions |
| Pulse Feed | Static display | No actions |
| Environmental Map | Static display | No actions |
| Precision Profile | Static display | No actions |

### Settings & Privacy

| Screen | Action | Target |
|---|---|---|
| Settings | `ToggleRow` × 3 | AM/PM reminders, Insight nudges |
| Settings | `PrimaryButton("Enable Push Notifications")` | OS settings deep-link (stub) |
| Privacy Dashboard | `ToggleRow` × 6 | Toggles consent categories |
| Privacy Dashboard | `GhostButton("Update")` → Pin code dialog | Updates pin code |
| Privacy Dashboard | `ListTileWidget("Download My Data")` → Dialog | Email data export request |
| Privacy Dashboard | `ListTileWidget("Privacy Policy")` | → Legal Documents |
| Kill Switch | `PrimaryButton("Yes, Delete Everything")` | Shows confirmation |
| Kill Switch | `PrimaryButton("Confirm Deletion")` | Performs deletion, → Splash |
| Kill Switch | `GhostButton("Cancel")` / `GhostButton("Go Back")` | Pop / resets confirmation |

### Profile & Account

| Screen | Action | Target |
|---|---|---|
| Profile Hub | `ListTileWidget` × 7 | → Settings/Privacy/Calendar/Orders/Credits/Account/Kill Switch |
| Profile Hub | `GhostButton("Connect RARE Account")` | → Account Sync |
| Account Details | `TextField` × 3 (name/email/phone) | Edits profile fields |
| Account Details | `PrimaryButton("Save Changes")` | Validates → OAuth re-auth (email) / OTP (phone) / direct save |
| Account Details | OTP dialog `PrimaryButton("Verify & Save")` | Verifies OTP, saves |
| Account Details | OAuth dialog `PrimaryButton("Continue with OAuth")` | Simulates OAuth flow |

### Support & Legal

| Screen | Action | Target |
|---|---|---|
| Help Support | `ListTileWidget("Manage Bookings")` | Opens booking management (stub) |
| Help Support | `ListTileWidget("Report a Data Issue")` → Dialog | Submits report (firewalled) |
| Help Support | `ListTileWidget("Contact Concierge")` | Opens email/WhatsApp (stub) |
| Legal Documents | Scrollable content | No actions |

### Rituals

| Screen | Action | Target |
|---|---|---|
| Rituals | `IconButton(replay_10)` | Rewind 10s (stub) |
| Rituals | `GestureDetector` play button | Toggle play/pause (stub) |
| Rituals | `IconButton(forward_10)` | Forward 10s (stub) |
| Rituals | `ListTileWidget` × 4 (library) | Load ritual (stub) |

### B2B Practitioner

| Screen | Action | Target |
|---|---|---|
| Practitioner Login | `PrimaryButton("Start Appointment")` | Starts session timer (stub) |
| Practitioner Login | `GhostButton("View Full Profile")` | Opens read-only profile (stub) |
| Pre-Treatment Sync | `ToggleRow` × 3 (skin/insights/routine) | Toggles data sharing |
| Pre-Treatment Sync | `PrimaryButton("Share Selected")` | → Post-Treatment Protocol |
| Pre-Treatment Sync | `GhostButton("Skip This Step")` | → Post-Treatment Protocol |
| Post-Treatment | `PrimaryButton("Review on My Shelf")` × 2 | → Shelf, marks suggestion viewed |

### Calendar

| Screen | Action | Target |
|---|---|---|
| Cycle Calendar | `ToggleRow("Pause Cycle Tracking")` | Pauses/resumes cycle tracking |
| Cycle Calendar | `GhostButton("Resume")` (when paused) | Resumes tracking |
| Data Log Edit | `GestureDetector` on calendar day | Loads logs for selected day |
| Data Log Edit | `GhostButton("Edit")` → Dialog | Edit logs for day |
| Data Log Edit | `TextButton("Save")` in dialog | Saves edits, records Edited event |

---

## 6. Data Entities

All data entities identified from hardcoded values, widget parameters, and internal state:

### User Profile
- **name** (String) — "Priya Sharma"
- **email** (String) — "priya@example.com"
- **phone** (String) — "+91 98765 43210"
- **pinCode** (String) — "411001 — Pune"
- **skinType** (enum) — Dry / Oily / Combo / Sensitive
- **isAnonymous** (bool) — anonymous-first profile support
- **isOAuthLinked** (bool) — whether account is linked to web

### Skin & Wellness Logs
- **SkinLog** — `{tags: List<String>, date: String, photoUrl: String?}`
  - Tags: Tight, Dry, Oily, Sensitive, Calm, Dull, Reactive, Bright
- **QuickLog** — `{type: enum(Caffeine/Alcohol/Energy), timestamp: DateTime}`
- **AMCheckin** — `{sleepHours: double, sleepSource: enum(inferred/adjusted), mood: double(0-1), contextTags: List<String>}`
  - Context tags: Sick, Travel, Stress
- **PMCheckin** — `{stress: double(0-1)}`
- **HydrationLog** — `{tapsToday: int, goalTaps: int}`

### Cycle & Calendar
- **CycleBaseline** — `{lastPeriodStartDate: DateTime, cycleLength: int}`
- **CycleDay** — `{day: int, isMarked: bool, isToday: bool}`
- **CycleTrackingState** — `{isPaused: bool, pauseReason: String?}`

### Products & Shelf
- **Product** — `{name: String, status: enum(Standard/Armed/Depleted)}`
- **RoutineStep** — `{step: enum(Cleanse/Treat/Moisturize/SPF), productId: String?, timing: enum(AM/PM/Both)}`
- **RoutineIntervention** — `{type: enum(Algorithm/AutoSwap/Practitioner/ManualEdit), description: String, timestamp: DateTime}`

### Insights
- **Correlation** — `{insight: String, confidenceLevel: int(0-3), factors: List<String>}`
- **PrecisionProfile** — `{hydrationIndex: int, barrierFunction: int, sebumBalance: int, sensitivityScore: int}`
- **PulseStat** — `{count: int, description: String, segmentThreshold: int(100)}`
- **EnvironmentalData** — `{pinCode: String, aqiHistory: List<AQIReading>, skinCorrelations: List<SkinCorrelation>}`

### Commerce & Bookings
- **Booking** — `{service: String, dateTime: DateTime, location: String, status: enum(upcoming/past)}`
- **Order** — `{productName: String, date: DateTime}`
- **CheckoutState** — `{isSuccess: bool}`
- **CreditsTransaction** — `{amount: int, description: String, type: enum(credit/debit), timestamp: DateTime}`

### Practitioner (B2B)
- **PractitionerSession** — `{clientName: String, appointmentTime: DateTime, isStarted: bool}`
- **ClientSummary** — `{name: String, skinType: String, recentTags: List<String>, visitCount: int, insightCount: int, logCount: int}`
- **PreTreatmentConsent** — `{shareSkinLogs: bool, shareInsights: bool, shareRoutine: bool}`
- **PostTreatmentSuggestion** — `{title: String, description: String, type: enum(Defensive/Offensive), isApplied: bool}`

### Consent & Privacy
- **ConsentCategory** — `{category: String, isGranted: bool, description: String}`
  - Categories: Phone activity, Pin code, Cycle tracking, Skin photos, Purchase history, Wearable data

### Notifications
- **NotificationPreference** — `{amReminder: bool, pmReminder: bool, insightNudges: bool}`
- **Nudge** — `{message: String, timestamp: DateTime, icon: IconData, isRead: bool}`

### Skin Photo Timeline
- **SkinPhotoEntry** — `{tags: List<String>, date: String, color: Color}`

### Rituals
- **Ritual** — `{title: String, duration: String, tag: String, audioUrl: String?}`
- **RitualPlaybackState** — `{isPlaying: bool, currentPosition: Duration, totalDuration: Duration}`

---

## 7. Mock/Hardcoded Data Inventory

### Hardcoded Strings

| Location | String | Purpose |
|---|---|---|
| `app_strings.dart` | `'A new way of being known.'` | Welcome title |
| `app_strings.dart` | `'A note left on a pillow.'` | Welcome subtitle |
| `app_strings.dart` | `'Begin →'` | Welcome CTA |
| `screen_02_soft_scan.dart` | `'Let's see you.'` | Soft scan heading |
| `screen_02_soft_scan.dart` | `'This is the last time you'll need to tell us everything.'` | Soft scan subtext |
| `screen_02_soft_scan.dart` | `'We couldn't quite get a clear read in this light...'` | Scan failure message |
| `screen_02_soft_scan.dart` | `['Dry', 'Oily', 'Combo', 'Sensitive']` | Skin type options |
| `screen_03_account_sync.dart` | `'Connect your shelf.'` | Account sync heading |
| `screen_03_account_sync.dart` | `'Securely bridges to your existing RARE account via OAuth.'` | OAuth description |
| `screen_03_account_sync.dart` | `'Skip for now — start anonymously'` | Anonymous skip option |
| `screen_04_privacy_gate.dart` | `'Your data, your terms.'` | Privacy heading |
| `screen_04_privacy_gate.dart` | `'Used only for the feature it names.'` | Consent subtitle |
| `screen_09_am_checkin.dart` | `'7h 12m — sound about right?'` | Sleep inference |
| `screen_09_am_checkin.dart` | `['Sick', 'Travel', 'Stress']` | Context tags |
| `screen_11_skin_log.dart` | `['Tight', 'Dry', 'Oily', 'Sensitive', 'Calm', 'Dull']` | Skin condition tags |
| `screen_13_shelf.dart` | `'Barrier Repair Serum'` / `'Vitamin C Elixir'` / `'Gentle Exfoliant'` | Product names |
| `screen_13_shelf.dart` | `'Standard'` / `'Armed'` / `'Depleted'` | Product statuses |
| `screen_14_routine_builder.dart` | `['Cleanse', 'Treat', 'Moisturize', 'SPF']` | Routine steps |
| `screen_14_routine_builder.dart` | `'e.g. "Cetaphil Cleanser"'` | Non-RARE product placeholder |
| `screen_15_biweekly_wrapped.dart` | `'4,200 women with your Precision Profile restocked this serum this month.'` | Pulse stat |
| `screen_18_routine_intervention_log.dart` | `'Paused Retinol'` / `'Swapped to Barrier Serum'` / etc. | Intervention entries |
| `screen_18_routine_intervention_log.dart` | `['ALGORITHM', 'AUTO_SWAP', 'PRACTITIONER', 'MANUAL_EDIT']` | Intervention sources |
| `screen_20_precision_profile.dart` | `'Hydration Index'` / `'Barrier Function'` / `'Sebum Balance'` / `'Sensitivity Score'` | Profile metric names |
| `screen_20_precision_profile.dart` | `72 / 78 / 65 / 55` | Profile metric values |
| `screen_23_booking_webview.dart` | `'THURSDAY · 3:30 PM'` / `'Restorative Facial — 60 min'` | Booking details |
| `screen_23_booking_webview.dart` | `'relaxedandrefresh.com/book'` | Booking domain |
| `screen_26_privacy_dashboard.dart` | `'411001 — Pune'` | Default pin code |
| `screen_31_order_booking_history.dart` | `'Restorative Facial — 60 min'` / `'RARE Studio, Bengaluru'` | Upcoming booking |
| `screen_31_order_booking_history.dart` | `'Barrier Repair Serum'` / `'Guided Reflexology'` / `'Restorative Facial'` | Past orders |
| `screen_31_order_booking_history.dart` | `'12 Jul 2026'` / `'2 Jul 2026'` / `'22 Jun 2026'` | Order dates |
| `screen_32_credits_ledger.dart` | `'₹340'` / `'1 Credit = ₹1'` | Credits balance |
| `screen_32_credits_ledger.dart` | `'+10 · AM Check-in'` / `'+15 · 14-Day Resonance'` / etc. | Transaction descriptions |
| `screen_34_data_log_edit_history.dart` | `'Priya Sharma'` / `'priya@example.com'` / `'+91 98765 43210'` | Account details |
| `screen_35_skin_progress_timeline.dart` | 7 `_SkinPhotoEntry` entries | Timeline mock data |
| `screen_36_quiet_inbox.dart` | 3 nudge items | Inbox mock data |
| `screen_38_legal_documents.dart` | Full Privacy Policy text | Legal content |
| `screen_40_help_support.dart` | `'Report a Data Issue is firewalled...'` | Security note |
| `screen_41_rare_rituals.dart` | `'Morning Calm'` / `'4:12 / 10:30'` | Featured ritual |
| `screen_41_rare_rituals.dart` | 4 library items with titles/tags | Ritual library |
| `screen_42_practitioner_login.dart` | `'Priya S.'` / `'Combination'` / `['Tight', 'Reactive']` | Client summary |
| `screen_42_practitioner_login.dart` | `'Anjali'` | Practitioner name |
| `screen_43_pre_treatment_sync.dart` | `'Anjali'` | Practitioner name |

### Hardcoded Numeric Values

| Location | Value | Purpose |
|---|---|---|
| `screen_08_home.dart` | `fillPercentage: 0.55` | Hydration vessel fill |
| `screen_08_home.dart` | `'4 of 8 taps today'` | Hydration progress |
| `screen_09_am_checkin.dart` | `mood = 0.65` | Default mood slider |
| `screen_10_pm_checkin.dart` | `stress = 0.35` | Default stress slider |
| `screen_15_biweekly_wrapped.dart` | `filledSegments: 2` | Confidence meter |
| `screen_16_monthly_synthesis.dart` | `filledSegments: 3` | Confidence meter |
| `screen_20_precision_profile.dart` | `72, 78, 65, 55` | Profile scores |
| `screen_28_cycle_calendar.dart` | `_currentMonth = 7` / `_currentYear = 2026` | Calendar date |
| `screen_28_cycle_calendar.dart` | `_markedDays = [10, 11, 12, 13, 14]` | Cycle period days |
| `screen_28_cycle_calendar.dart` | `_today = 15` | Today indicator |
| `screen_32_credits_ledger.dart` | `'₹340'` | Credits balance |
| `screen_34_data_log_edit_history.dart` | `_selectedDay = 22` / `_selectedMonth = 7` / `_selectedYear = 2026` | Default selected date |
| `screen_35_skin_progress_timeline.dart` | 7 photo entries | Timeline entries |
| `screen_41_rare_rituals.dart` | `0.4` (widthFactor) | Progress bar fill |

### Hardcoded UI States

| Location | State | Purpose |
|---|---|---|
| `screen_27_kill_switch.dart` | `_hasActiveBooking = true` | Simulates active booking warning |
| `screen_29_dormant_state.dart` | `isDormant: true, opacity: 0.18, scale: 0.6` | Dormant Aura state |
| `screen_37_splash_returning.dart` | `isBreathing: false, opacity: 0.5, scale: 0.8` | Splash Aura state |
| `screen_44_post_treatment_protocol.dart` | `_offensiveViewed = {'SPF 50 Recommended': false, 'Barrier Recovery Mask': false}` | Suggestion viewed state |

---

## 8. Backend Requirements (Inferred from UI)

### Authentication & Account

| Requirement | Evidence |
|---|---|
| OAuth 2.0 flow (Google, Apple) | Screen 3: "Securely bridges to your existing RARE account via OAuth" |
| Anonymous session creation | Screen 3: "Skip for now — start anonymously" creates local profile |
| Biometric auth (Face ID / Touch ID) | Screen 37: "Unlock with Face ID" for anonymous users |
| Session token management | Screen 37: "Checks for an existing session token on launch" |
| Token refresh mechanism | Implied by session-based auth |
| Account linking (anon → linked) | Screen 33: "Connect RARE Account" from Profile Hub |
| Email change OAuth re-auth | Screen 45: "Email changes require OAuth re-authorization" |
| Phone OTP verification | Screen 45: 6-digit OTP flow for phone changes |
| Account deletion (DPDP compliance) | Screen 27: Kill Switch deletes all app data |

### Data Persistence

| Requirement | Evidence |
|---|---|
| User profile CRUD | Screen 45: editable name/email/phone |
| Consent preferences storage | Screen 4, 26: granular toggle states |
| Skin log entries | Screen 11, 35: skin photos with tags, timeline |
| Quick log entries | Screen 12: caffeine/alcohol/energy logs |
| AM/PM check-in data | Screen 9, 10: sleep, mood, stress, context tags |
| Cycle baseline data | Screen 5, 28: period start dates, cycle calendar |
| Hydration tracking | Screen 8: tap counter, goal tracking |
| Product shelf state | Screen 13: Standard/Armed/Depleted statuses |
| Routine configuration | Screen 14: step-product-timing mappings |
| Intervention history | Screen 18: algorithm/auto-swap/practitioner/manual edits |
| Booking history | Screen 31: upcoming and past bookings |
| Credits ledger | Screen 32: balance and transaction history |
| Pin code (environmental) | Screen 26: "411001 — Pune" |
| Notification preferences | Screen 25: AM/PM/nudge toggles |
| Cycle tracking pause state | Screen 28: isPaused flag |
| Practitioner session data | Screen 42-44: B2B temporary session |

### API Endpoints (Inferred)

| Endpoint | Method | Purpose |
|---|---|---|
| `POST /auth/oauth` | POST | OAuth login (Google/Apple) |
| `POST /auth/anonymous` | POST | Create anonymous session |
| `POST /auth/biometric` | POST | Biometric auth for anonymous users |
| `POST /auth/refresh` | POST | Token refresh |
| `DELETE /auth/account` | DELETE | Kill Switch — delete all data |
| `GET /profile` | GET | Fetch user profile |
| `PUT /profile` | PUT | Update name/email/phone |
| `POST /profile/link` | POST | Link anonymous → OAuth account |
| `GET /consent` | GET | Fetch consent preferences |
| `PUT /consent` | PUT | Update consent toggles |
| `POST /logs/skin` | POST | Create skin log entry |
| `POST /logs/quick` | POST | Create quick log entry |
| `POST /logs/checkin/am` | POST | Submit AM check-in |
| `POST /logs/checkin/pm` | POST | Submit PM check-in |
| `POST /logs/hydration` | POST | Log hydration tap |
| `GET /logs/skin/timeline` | GET | Fetch skin photo timeline |
| `DELETE /logs/skin/{id}` | DELETE | Delete skin photo (flag ignored) |
| `PUT /logs/{id}` | PUT | Edit past log entry |
| `GET /cycle/baseline` | GET | Fetch cycle baseline |
| `PUT /cycle/baseline` | PUT | Update cycle baseline |
| `PUT /cycle/pause` | PUT | Pause/resume cycle tracking |
| `GET /cycle/calendar` | GET | Fetch cycle calendar data |
| `GET /shelf` | GET | Fetch product shelf |
| `PUT /shelf/{productId}/status` | PUT | Update product status |
| `POST /shelf/restock` | POST | Trigger restock flow |
| `GET /routine` | GET | Fetch current routine |
| `PUT /routine` | PUT | Save routine configuration |
| `GET /insights/biweekly` | GET | Fetch 14-day wrapped |
| `GET /insights/monthly` | GET | Fetch monthly synthesis |
| `GET /insights/pulse` | GET | Fetch RARE Pulse feed |
| `GET /insights/interventions` | GET | Fetch intervention log |
| `GET /insights/environmental` | GET | Fetch AQI data for pin code |
| `GET /insights/precision-profile` | GET | Fetch precision profile scores |
| `GET /bookings` | GET | Fetch booking history |
| `POST /bookings` | POST | Create booking |
| `PUT /bookings/{id}` | PUT | Manage booking (reschedule/cancel) |
| `POST /checkout` | POST | Process payment |
| `GET /credits` | GET | Fetch credits balance and history |
| `POST /credits/apply` | POST | Apply credits at checkout |
| `GET /notifications` | GET | Fetch quiet inbox nudges |
| `PUT /notifications/{id}/read` | PUT | Mark nudge as read |
| `POST /support/report` | POST | Submit data issue report |
| `POST /data/export` | POST | Request data export via email |
| `GET /rituals` | GET | Fetch ritual library |
| `GET /rituals/{id}` | GET | Fetch ritual audio/metadata |
| `POST /b2b/session` | POST | Start practitioner session |
| `GET /b2b/client/{id}` | GET | Fetch client summary for practitioner |
| `POST /b2b/pre-treatment` | POST | Save pre-treatment consent |
| `POST /b2b/post-treatment` | POST | Save post-treatment recommendations |
| `DELETE /b2b/session` | DELETE | Wipe practitioner session data |

### Business Logic (Inferred)

| Logic | Evidence |
|---|---|
| Sleep inference from phone stillness | Screen 9: "SLEEP — INFERRED FROM PHONE STILLNESS" |
| Auto-Swap detection | Screen 18: "Swapped to Barrier Serum" |
| Depletion detection | Screen 13: "Depleted" status, Screen 24: depletion confirmation |
| Confidence scoring for correlations | Screen 15, 16: ConfidenceMeter (0-3 segments) |
| Segment suppression (100-user threshold) | Screen 17: "Below the 100-user segment threshold" |
| Cycle-based pattern matching | Screen 16: "your cycle also starts tomorrow" |
| Defensive/Offensive product split | Screen 44: auto-applied vs suggestion queue |
| Anonymous-first with upgrade path | Screen 3, 33, 37: anonymous → OAuth linking |
| Contextual Reveal | Screen 13, 21: tap product for reasoning |
| Adaptive tag system | Screen 9, 11: context/skin tags |
| Quiet inbox (no badges) | Screen 36: "no badge counts, no pressure" |
| Practitioner data wipe on completion | Screen 42: "Wiped from tablet storage the moment appointment is marked complete" |
| Firewalled data issue reporting | Screen 40: "staff see only the flagged insight and her note, never raw biometric logs" |
| Credits economy (1 Credit = ₹1) | Screen 32: balance and transaction types |
| Intervention audit trail | Screen 18, 44: algorithm/auto-swap/practitioner/manual labeled by source |

---

## 9. External Integrations Required

### OAuth (Google, Apple)
- **Status:** UI references in Screen 3, 37, 45 but no packages in pubspec
- **Packages needed:** `google_sign_in`, `sign_in_with_apple`
- **Flow:** OAuth webview bridge to relaxedandrefresh.com
- **Token handling:** JWT tokens, refresh mechanism needed

### Payment (Razorpay)
- **Status:** "Confirm & Pay" button in Screen 23, payment flow stub
- **Packages needed:** `razorpay_flutter`
- **Flow:** Booking → Checkout → Payment → Success/Failure state (Screen 39)
- **Credits integration:** Credits apply automatically at checkout

### Wearable (Apple Health, Google Fit)
- **Status:** Connect buttons in Screen 6 but no packages
- **Packages needed:** `health` (Apple Health), `fit_kit` (Google Fit)
- **Data types:** Sleep, heart rate, activity, steps
- **Privacy:** User-controlled toggle in Privacy Dashboard

### Environmental (AQI/PM2.5 API)
- **Status:** Environmental Map screen (Screen 19) with placeholder
- **API needed:** AQI/PM2.5 data provider (e.g., WAQI, IQAir)
- **Data:** Historical AQI for pin code, plotted against skin states
- **Fallback:** "Air quality data isn't available for your specific area"

### Email Service
- **Status:** "Download My Data" dialog (Screen 26) sends export to email
- **Service needed:** Transactional email (SendGrid, AWS SES, etc.)
- **Flows:** Data export, booking confirmations, password resets

### File Storage (Photos)
- **Status:** Camera icon in Screen 11, photo upload UI in Screen 35
- **Packages needed:** `image_picker`, `camera`
- **Storage:** Cloud storage (AWS S3, Firebase Storage) for skin photos
- **Privacy:** Deleted photos flagged "ignored, never trained on"

### Push Notifications
- **Status:** Settings toggles in Screen 25, push permission fallback
- **Packages needed:** `firebase_messaging`, `flutter_local_notifications`
- **Flows:** AM/PM check-in reminders, insight nudges, booking reminders
- **Quiet approach:** Auto-clearing inbox, no badge counts

### Webview
- **Status:** Simulated webview chrome in Screen 21, 23 (relaxedandrefresh.com)
- **Packages needed:** `webview_flutter`
- **Flows:** Booking management, OAuth bridge, external content

### Local Storage
- **Status:** No local persistence packages
- **Packages needed:** `shared_preferences` (settings), `flutter_secure_storage` (tokens), `hive`/`sqflite` (offline data)
- **Needs:** Consent state, notification preferences, cached profile, offline-first capability

---

## 10. Authentication Requirements

### OAuth Login
- Google Sign-In and Apple Sign-In for linked accounts
- OAuth webview bridge to relaxedandrefresh.com
- JWT token exchange and storage
- Account linking: anonymous → OAuth

### Biometric Auth (Anonymous Users)
- Face ID / Touch ID for local device authentication
- Local-only, no server-side biometric data
- Fallback to device passcode

### Token Refresh
- Automatic token refresh before expiry
- Grace period for network failures
- Re-authentication prompt on persistent failure

### Session Management
- Session token checked on app launch (Screen 37)
- Session expiry handling
- Multi-device session management (implied by "New device" path)

### Account Linking
- Anonymous → OAuth upgrade path
- Data migration from local to cloud
- Preserves existing logs and settings during linking

---

## 11. Privacy Requirements

### Granular Consent per Data Category
Six independently toggleable categories (Screen 4, 26):
1. Phone activity (sleep inference)
2. Pin code (environmental data)
3. Cycle tracking
4. Skin photo storage
5. Purchase history (Shelf / Auto-Swap)
6. Wearable & health data (Apple Health / Google Fit)

### DPDP Compliance (India)
- **Right to Access:** Download My Data (Screen 26)
- **Right to Correction:** Edit logs (Screen 34), Edit profile (Screen 45)
- **Right to Erasure:** Kill Switch (Screen 27)
- **Right to Withdraw Consent:** Toggle permissions off anytime (Screen 26)
- **Consent history audit:** Intervention Log (Screen 18) tracks all changes

### Data Export
- "Download My Data" triggers email with complete wellness data
- "This takes a few minutes" — async export process
- Format not specified (JSON/CSV expected)

### Kill Switch (Account Deletion)
- Two-step confirmation flow
- Warns about active bookings (won't cancel)
- Warns about Apple Health / Google Fit permissions (revoked separately)
- Deletes: wellness logs, insights, Aura state
- Does NOT delete: website orders, external bookings
- Post-deletion: navigates to splash/onboarding

### Consent History Audit
- All routine changes logged in Intervention Log (Screen 18)
- Sources labeled: ALGORITHM, AUTO_SWAP, PRACTITIONER, MANUAL_EDIT
- Original values preserved on edits (Screen 34)
- "Corrections are never silent — logged as an Edited event"

### Data Minimization
- Anonymous-first onboarding (no email required initially)
- "Used only for the feature it names" per consent category
- Practitioner data: read-only, session-limited, wiped after appointment
- Data issue reports: firewalled, staff see only flagged insight + note

---

## 12. Architecture Interpretation

### Core Platform Identity
RARE is a **wellness/skin/lifestyle/commerce platform** unified under a single "Atmosphere" metaphor. It is NOT a simple skincare tracker — it is an adaptive wellness system that correlates environmental, behavioral, and physiological data to deliver personalized insights.

### Anonymous-First Onboarding
The app supports **immediate use without account creation**. Users can skip OAuth, create a local anonymous profile, and begin logging immediately. The anonymous path creates a local profile with empty shelf and dormant Auto-Swap. Account linking happens later from Profile Hub.

### Precision Profile System
The **Precision Profile** (Screen 20) is a composite scoring system with four dimensions:
- Hydration Index (0-100)
- Barrier Function (0-100)
- Sebum Balance (0-100)
- Sensitivity Score (0-100)

These scores drive the correlation engine, product recommendations, and RARE Pulse segment matching.

### Adaptive Tag System
Tags flow through multiple contexts:
- **Skin tags:** Tight, Dry, Oily, Sensitive, Calm, Dull, Reactive, Bright
- **Context tags:** Sick, Travel, Stress
- **Intervention sources:** ALGORITHM, AUTO_SWAP, PRACTITIONER, MANUAL_EDIT

Tags are used for pattern matching, timeline overlay, and practitioner handoff.

### Correlation Engine (Epistemic Ladder)
The insights system operates on a **confidence hierarchy**:
- **Low confidence (1/3):** Emerging patterns
- **Medium confidence (2/3):** "There's a pattern forming between late coffees and restless mornings"
- **High confidence (3/3):** "On mornings after coffee past 2pm, you've rated your sleep lower about 70% of time"

The engine correlates: sleep, mood, stress, skin state, hydration, caffeine/alcohol/energy, cycle phase, environmental AQI, product usage, and routine interventions.

### Auto-Swap / Depletion Detection
The **Shelf** system tracks product lifecycle:
- **Standard:** Active product in routine
- **Armed:** Product queued for auto-swap (contextual)
- **Depleted:** Product needs restock

**Depletion detection** uses "Honest Guess" flow (Screen 24) — gentle, never a countdown. Restock triggers contextual recommendations.

### B2B Practitioner Workflow
The practitioner system (Screens 42-44) operates on a **sovereign data model**:
1. **Pre-treatment:** Granular consent for data sharing (skin logs, insights, routine)
2. **During treatment:** Read-only client summary on practitioner tablet
3. **Post-treatment:** Defensive suggestions (auto-applied) vs Offensive suggestions (queue)
4. **Completion:** All practitioner data wiped from tablet storage

Practitioner judgment logged in unified audit trail, clearly labeled by source.

### Credits/Ledger Economy
The app has a **credits system** (Screen 32):
- 1 Credit = ₹1
- Earned via: AM Check-in (+10), 14-Day Resonance (+15), Ritual Completed (+8)
- Refunds credited: Reflexology refund (+50)
- Spent on: Rituals (-120)
- Applied automatically at checkout on the web

### Quiet Inbox (No Badges)
The **Quiet Inbox** (Screen 36) is an anti-anxiety notification system:
- Items auto-clear as read or expired
- No badge counts, no pressure
- Missed nudges displayed as timeline
- "We'll let you know when something needs your attention"

### Resilience Loop (Dormant State)
The **Aura** is the visual expression of the Resilience Loop:
- **Active:** Breathing animation, high opacity, large scale
- **Dormant:** Non-breathing, opacity 0.18, scale 0.6 — after missed check-ins
- **Recovery:** "Welcome back. The garden missed the sun." → Check In CTA

### Contextual Reveal
Products on the Shelf have **hidden reasoning** revealed on tap:
- Status dot color indicates state (Standard/Armed/Depleted)
- Tap shows "why" in plain language
- Commerce intercepts for anonymous users and offline states

### Defensive/Offensive Product Split
Routine changes follow a **two-tier system**:
- **Defensive:** Auto-applied by algorithm or practitioner (e.g., "Pause exfoliant for 5 days")
- **Offensive:** Queued suggestions for user review (e.g., "SPF 50 Recommended")

This prevents overwhelm while maintaining practitioner authority.

---

## 13. Ambiguities

1. **No external architecture diagrams found.** All architecture interpretation is derived solely from code structure, naming conventions, and UI copy.

2. **Backend specification absent.** The codebase is a frontend-only Flutter prototype with no API layer, data models, or state management beyond UI state. All backend requirements are inferred from UI interactions.

3. **State management scope unclear.** Riverpod is declared but only used for GoRouter injection. No providers for user state, logs, or business logic exist. It's unclear whether the intent is to use Riverpod for all state or if a different pattern was planned.

4. **Offline-first strategy undefined.** The app references offline intercepts (Screen 21) but has no local persistence packages. It's unclear whether the app is intended to work fully offline or gracefully degrade.

5. **Data model boundaries ambiguous.** Entities like `SkinPhotoEntry` are defined as private classes within screen files rather than shared models. It's unclear whether a centralized data layer was planned.

6. **Rituals audio playback** is simulated with UI controls but no audio package is declared. The actual audio format, streaming vs local, and DRM requirements are unknown.

7. **Razorpay integration** is referenced in the payment flow but the exact checkout flow (SDK vs webview vs redirect) is unspecified.

8. **Practitioner authentication** (Screen 42) mentions "credentialed esthetician access" but no auth flow is shown. The credential verification mechanism is unclear.

9. **RARE Pulse suppression threshold** (100 users) is hardcoded in UI copy. Whether this is configurable or fixed business logic is unknown.

10. **Credits economy rules** (earning rates, spending categories, expiry) are only partially visible from Screen 32. Full ruleset not documented in code.

---

## 14. Implementation Plan

### Phase 1: Foundation (Weeks 1-4)
**Goal:** Core infrastructure and authentication

- [ ] Set up backend (Node.js/Flutter Serverpod/Django — choose stack)
- [ ] Implement OAuth 2.0 (Google, Apple) with JWT tokens
- [ ] Implement anonymous session creation and biometric auth
- [ ] Set up local storage (shared_preferences, flutter_secure_storage)
- [ ] Create data models (User, Consent, SkinLog, CheckIn, Cycle, Product, etc.)
- [ ] Implement Riverpod state providers for all entities
- [ ] Build API client layer (http/dio with interceptors)
- [ ] Implement token refresh and session management
- [ ] Set up push notification infrastructure (Firebase)

### Phase 2: Onboarding & Privacy (Weeks 5-8)
**Goal:** Complete onboarding flow with real data persistence

- [ ] Wire Soft Scan to camera/image_picker
- [ ] Implement OAuth webview bridge
- [ ] Persist consent toggles to backend
- [ ] Implement cycle baseline save/load
- [ ] Wire wearable connection (health package)
- [ ] Persist Aura state across sessions
- [ ] Implement account linking (anon → OAuth)

### Phase 3: Core Logging (Weeks 9-14)
**Goal:** All logging flows functional with persistence

- [ ] Implement AM/PM check-in with real sleep inference
- [ ] Build skin log with photo capture and upload
- [ ] Implement quick log (caffeine/alcohol/energy)
- [ ] Build hydration tracking (tap counter)
- [ ] Implement cycle calendar with pause/resume
- [ ] Build data log edit history with audit trail
- [ ] Implement skin progress timeline with photo storage

### Phase 4: Insights Engine (Weeks 15-20)
**Goal:** Correlation engine and insights generation

- [ ] Build precision profile scoring algorithm
- [ ] Implement biweekly wrapped generation
- [ ] Build monthly synthesis with confidence scoring
- [ ] Implement RARE Pulse aggregation (100-user threshold)
- [ ] Integrate AQI/PM2.5 API for environmental map
- [ ] Build correlation engine (sleep × caffeine × cycle × skin)
- [ ] Implement dormant state detection (missed check-ins)

### Phase 5: Commerce & Bookings (Weeks 21-26)
**Goal:** Full commerce flow with Razorpay

- [ ] Implement product shelf with status management
- [ ] Build depletion detection and "Honest Guess" flow
- [ ] Implement auto-swap detection
- [ ] Integrate Razorpay payment SDK
- [ ] Build booking webview with payment flow
- [ ] Implement checkout success/failure states
- [ ] Build order/booking history
- [ ] Implement credits ledger and economy

### Phase 6: B2B Practitioner (Weeks 27-30)
**Goal:** Sovereign B2B workflow

- [ ] Build practitioner authentication (credential verification)
- [ ] Implement pre-treatment data sync with granular consent
- [ ] Build read-only client summary view
- [ ] Implement post-treatment protocol (defensive/offensive split)
- [ ] Build practitioner data wipe on session completion
- [ ] Implement unified audit trail

### Phase 7: Polish & Compliance (Weeks 31-34)
**Goal:** Privacy compliance and UX polish

- [ ] Implement Kill Switch (full data deletion)
- [ ] Build data export (email with JSON/CSV)
- [ ] Implement privacy dashboard with real consent management
- [ ] Build legal documents viewer (dynamic content)
- [ ] Implement quiet inbox with auto-clear
- [ ] Build error/empty states across all screens
- [ ] Implement settings with real notification scheduling
- [ ] Add Haptic feedback and accessibility

### Phase 8: Testing & Launch (Weeks 35-38)
**Goal:** Production readiness

- [ ] Unit tests for all data models and providers
- [ ] Widget tests for all screens
- [ ] Integration tests for critical flows (onboarding, check-in, payment)
- [ ] Performance profiling (animation, memory)
- [ ] Security audit (token storage, data encryption, DPDP compliance)
- [ ] App Store / Play Store submission
- [ ] Monitoring and analytics setup
- [ ] Documentation and API specs
