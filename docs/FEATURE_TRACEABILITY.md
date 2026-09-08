# Feature Traceability — RARE Mobile Application

> Complete mapping of every feature to screens, services, database tables, endpoints, and Flutter providers.

---

## 1. Authentication & Account Management

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Email/Password Signup | SplashReturningScreen, AccountSyncScreen | auth_service | users, refresh_tokens, onboarding_progress, credit_balances | POST /auth/signup | auth_provider | IMPLEMENTED |
| Email/Password Login | SplashReturningScreen | auth_service | users, refresh_tokens | POST /auth/login | auth_provider | IMPLEMENTED |
| Token Refresh | Any (auto via interceptor) | auth_service | refresh_tokens | POST /auth/refresh | auth_provider | IMPLEMENTED |
| Logout | SettingsScreen | auth_service | refresh_tokens | POST /auth/logout | auth_provider | IMPLEMENTED |
| Get Current User | SplashReturningScreen (auto) | - | users | GET /auth/me | auth_provider | IMPLEMENTED |
| Anonymous Session | AccountSyncScreen | auth_service | users, refresh_tokens | POST /auth/signup (no password) | auth_provider | IMPLEMENTED |
| Practitioner Login | PractitionerLoginScreen | practitioner_service | users | POST /practitioner/login | - | IMPLEMENTED |

## 2. Onboarding Flow

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Load Onboarding Progress | WelcomeScreen, AuraAwakeningScreen | onboarding_service | onboarding_progress | GET /onboarding/progress | onboarding_provider | IMPLEMENTED |
| Update Onboarding Step | All onboarding screens | onboarding_service | onboarding_progress | PUT /onboarding/step | onboarding_provider | IMPLEMENTED |
| Soft Skin Scan | SoftScanScreen | onboarding_service | soft_scans, user_profiles | POST /onboarding/soft-scan | onboarding_provider | IMPLEMENTED |
| Manual Skin Type Selection | SoftScanScreen (fallback) | onboarding_service | soft_scans, user_profiles | POST /onboarding/soft-scan | onboarding_provider | IMPLEMENTED |
| Account Sync / OAuth | AccountSyncScreen | auth_service | users | POST /auth/signup | auth_provider | IMPLEMENTED |
| Privacy Consent Collection | PrivacyGateScreen | onboarding_service | privacy_consents | POST /onboarding/privacy-consent | onboarding_provider | IMPLEMENTED |
| Cycle Baseline Setup | CycleBaselineScreen | onboarding_service | user_profiles | POST /onboarding/cycle-baseline | onboarding_provider | IMPLEMENTED |
| Wearable Connection | WearableConnectionScreen | onboarding_service | user_profiles | POST /onboarding/wearable | onboarding_provider | IMPLEMENTED |
| Complete Onboarding | AuraAwakeningScreen | onboarding_service | onboarding_progress | PUT /onboarding/step?step=complete | onboarding_provider | IMPLEMENTED |

## 3. Daily Check-ins (AM/PM)

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| AM Check-in (sleep, mood, energy, stress, tags) | AMCheckinScreen | - | daily_checkins | POST /checkins/am | checkin_provider | IMPLEMENTED |
| PM Check-in (stress, mood) | PMCheckinScreen | - | daily_checkins | POST /checkins/pm | checkin_provider | IMPLEMENTED |
| Load Today's Check-ins | HomeScreen | - | daily_checkins, hydration_logs | GET /checkins/today | checkin_provider | IMPLEMENTED |
| Edit Past Check-in | DataLogEditHistoryScreen | - | daily_checkins | PUT /checkins/{checkin_id} | checkin_provider | IMPLEMENTED |
| Sleep Inference from Phone Stillness | AMCheckinScreen | - | daily_checkins | POST /checkins/am | checkin_provider | UI_ONLY |
| Hydration Tap Tracking | HomeScreen | - | hydration_logs | GET /checkins/today | checkin_provider | UI_ONLY |

## 4. Skin Tracking

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Detailed Skin Log (tags, notes, rating) | SkinLogScreen | skin_service | skin_logs | POST /skin/log | skin_provider | IMPLEMENTED |
| Quick Log (caffeine, alcohol, energy) | QuickLogScreen | skin_service | skin_logs | POST /skin/log | skin_provider | IMPLEMENTED |
| Skin Photo Timeline | SkinProgressTimelineScreen | skin_service | skin_logs, skin_photos | GET /skin/timeline | skin_provider | IMPLEMENTED |
| Delete Skin Photo | SkinProgressTimelineScreen | skin_service | skin_logs | DELETE /skin/{log_id} | skin_provider | IMPLEMENTED |
| Upload Skin Photo | SkinLogScreen | skin_service | skin_photos | POST /skin/photo | skin_provider | IMPLEMENTED |

## 5. Cycle Tracking

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Cycle Calendar View | CycleCalendarScreen | - | cycle_events, user_profiles | GET /cycle/calendar | - | IMPLEMENTED |
| Log Cycle Event (period_start/end, ovulation, spotting) | CycleCalendarScreen | - | cycle_events, user_profiles | POST /cycle/event | - | IMPLEMENTED |
| Pause Cycle Tracking | CycleCalendarScreen | - | - | PUT /cycle/pause | - | IMPLEMENTED |
| Resume Cycle Tracking | CycleCalendarScreen | - | - | (resume implied) | - | UI_ONLY |

## 6. Product Shelf Management

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Product Shelf | ShelfScreen | shelf_service | shelf_items, products | GET /shelf/items | shelf_provider | IMPLEMENTED |
| Confirm Product Depletion | DepletionConfirmationScreen | shelf_service | shelf_items | POST /shelf/depletion-confirm | shelf_provider | IMPLEMENTED |
| Toggle Auto-Swap | OptimizeShelfScreen | shelf_service | shelf_items | PUT /shelf/auto-swap | shelf_provider | IMPLEMENTED |
| Contextual Reveal (product reasoning) | ShelfScreen | - | - | - | shelf_provider | UI_ONLY |

## 7. Routine Management

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Routines | RoutineBuilderScreen | routine_service | routines, routine_steps | GET /routine/ | routine_provider | IMPLEMENTED |
| Create Routine | RoutineBuilderScreen | routine_service | routines, routine_steps | POST /routine/ | routine_provider | IMPLEMENTED |
| Update Routine | RoutineBuilderScreen | routine_service | routines | PUT /routine/{routine_id} | routine_provider | IMPLEMENTED |
| View Routine Interventions | RoutineInterventionLogScreen | routine_service | routine_interventions | GET /routine/interventions | routine_provider | IMPLEMENTED |

## 8. Insights & Analytics

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Biweekly Wrapped (14-day patterns) | BiweeklyWrappedScreen | insight_service | insights | GET /insights/biweekly | insight_provider | IMPLEMENTED |
| Monthly Synthesis (deep patterns) | MonthlySynthesisScreen | insight_service | insights | GET /insights/monthly | insight_provider | IMPLEMENTED |
| RARE Pulse Feed (aggregated member insights) | PulseFeedScreen | insight_service | insights | GET /insights/pulse | insight_provider | IMPLEMENTED |
| Environmental Map (AQI/PM2.5) | EnvironmentalMapScreen | - | environmental_data | GET /environmental/current | environmental_provider | IMPLEMENTED |
| Precision Profile (hydration, barrier, sebum, sensitivity) | PrecisionProfileScreen | - | user_profiles | GET /users/profile | profile_provider | IMPLEMENTED |

## 9. Commerce & Payments

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Browse Products | OptimizeShelfScreen | commerce_service | products | GET /products/ | commerce_provider | IMPLEMENTED |
| View Product Detail | OptimizeShelfScreen | commerce_service | products | GET /products/{product_id} | commerce_provider | IMPLEMENTED |
| Add to Cart | OptimizeShelfScreen | commerce_service | carts, cart_items | POST /commerce/cart/items | commerce_provider | IMPLEMENTED |
| View Cart | CheckoutStateScreen | commerce_service | carts, cart_items | GET /commerce/cart | commerce_provider | IMPLEMENTED |
| Remove from Cart | CheckoutStateScreen | commerce_service | carts, cart_items | DELETE /commerce/cart/items/{item_id} | commerce_provider | IMPLEMENTED |
| Checkout | CheckoutStateScreen | commerce_service | orders, order_items, products | POST /commerce/checkout | commerce_provider | IMPLEMENTED |
| Razorpay Payment Verification | CheckoutStateScreen | commerce_service | payments, orders | POST /commerce/verify-payment | commerce_provider | IMPLEMENTED |

## 10. Orders & Bookings

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Order History | OrderBookingHistoryScreen | order_service | orders | GET /orders/ | commerce_provider | IMPLEMENTED |
| View Order Detail | OrderBookingHistoryScreen | order_service | orders, order_items | GET /orders/{order_id} | commerce_provider | IMPLEMENTED |
| View Available Services | PlanMyReliefScreen | booking_service | - | GET /bookings/services | booking_provider | IMPLEMENTED |
| Check Practitioner Availability | PlanMyReliefScreen | booking_service | - | GET /bookings/availability | booking_provider | IMPLEMENTED |
| Create Booking | BookingWebviewScreen | booking_service | treatment_sessions, practitioner_clients | POST /bookings/ | booking_provider | IMPLEMENTED |
| View Bookings | OrderBookingHistoryScreen | booking_service | treatment_sessions | GET /bookings/ | booking_provider | IMPLEMENTED |
| Cancel Booking | OrderBookingHistoryScreen | booking_service | treatment_sessions | PUT /bookings/{booking_id}/cancel | booking_provider | IMPLEMENTED |

## 11. Credits Economy

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Credit Balance | CreditsLedgerScreen | - | credit_balances | GET /credits/balance | credits_provider | IMPLEMENTED |
| View Credit Transactions | CreditsLedgerScreen | - | credit_transactions | GET /credits/transactions | credits_provider | IMPLEMENTED |
| Earn Credits (AM Check-in) | AMCheckinScreen | - | credit_balances, credit_transactions | (auto on checkin) | credits_provider | UI_ONLY |
| Spend Credits (Rituals) | RareRitualsScreen | - | credit_balances, credit_transactions | (auto on spend) | credits_provider | UI_ONLY |

## 12. Privacy & Consent Management

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Privacy Consents | PrivacyDashboardScreen | privacy_service | privacy_consents | GET /privacy/consents | privacy_provider | IMPLEMENTED |
| Update Consent Toggle | PrivacyDashboardScreen | privacy_service | privacy_consents, privacy_audit_logs | PUT /privacy/consents | privacy_provider | IMPLEMENTED |
| Request Data Export | PrivacyDashboardScreen | privacy_service | privacy_audit_logs | POST /privacy/export | privacy_provider | IMPLEMENTED |
| Request Account Deletion (Kill Switch) | KillSwitchScreen | privacy_service | privacy_audit_logs | POST /privacy/delete | privacy_provider | IMPLEMENTED |

## 13. Notifications / Quiet Inbox

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Notifications | QuietInboxScreen | notification_service | notifications | GET /inbox/ | notification_provider | IMPLEMENTED |
| Mark Notification Read | QuietInboxScreen | notification_service | notifications | PUT /inbox/{notification_id}/read | notification_provider | IMPLEMENTED |
| Auto-Clear Expired Notifications | QuietInboxScreen | - | notifications | (auto) | notification_provider | UI_ONLY |

## 14. Support & Help

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Create Support Ticket | HelpSupportScreen | - | support_tickets | POST /support/tickets | support_provider | IMPLEMENTED |
| View Support Tickets | HelpSupportScreen | - | support_tickets | GET /support/tickets | support_provider | IMPLEMENTED |
| Add Message to Ticket | HelpSupportScreen | - | support_messages | POST /support/tickets/{ticket_id}/messages | support_provider | IMPLEMENTED |

## 15. B2B Practitioner Portal

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Practitioner Login | PractitionerLoginScreen | practitioner_service | users | POST /practitioner/login | - | IMPLEMENTED |
| View Client Summary | PreTreatmentSyncScreen | practitioner_service | users, user_profiles, daily_checkins, skin_logs | GET /practitioner/clients/{client_id} | practitioner_provider | IMPLEMENTED |
| Create Treatment Session | PreTreatmentSyncScreen | practitioner_service | treatment_sessions | POST /practitioner/sessions | practitioner_provider | IMPLEMENTED |
| View Treatment Protocol | PostTreatmentProtocolScreen | practitioner_service | treatment_sessions | GET /practitioner/sessions/{session_id}/protocol | practitioner_provider | IMPLEMENTED |
| Pre-Treatment Data Sharing Consent | PreTreatmentSyncScreen | - | - | - | practitioner_provider | UI_ONLY |
| Post-Treatment Defensive/Offensive Split | PostTreatmentProtocolScreen | - | - | - | practitioner_provider | UI_ONLY |
| Practitioner Data Wipe on Session Complete | PractitionerLoginScreen | - | - | - | - | UI_ONLY |

## 16. Wearable Integration

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Check Wearable Status | WearableConnectionScreen | - | user_profiles | GET /wearable/status | - | IMPLEMENTED |
| Sync Wearable Data | WearableConnectionScreen | - | wearable_syncs | POST /wearable/sync | - | IMPLEMENTED |
| Disconnect Wearable | WearableConnectionScreen | - | user_profiles | DELETE /wearable/disconnect | - | IMPLEMENTED |

## 17. Environmental Data

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View AQI/UV/Humidity by Pincode | EnvironmentalMapScreen | - | environmental_data | GET /environmental/by-pincode | environmental_provider | IMPLEMENTED |
| View Current Environmental Data | EnvironmentalMapScreen | - | environmental_data | GET /environmental/current | environmental_provider | IMPLEMENTED |

## 18. Rituals (Guided Wellness)

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Featured Rituals | RareRitualsScreen | - | - | GET /rituals/featured | - | IMPLEMENTED |
| View Ritual Library | RareRitualsScreen | - | - | GET /rituals/library | - | IMPLEMENTED |
| Audio Playback (breathwork/meditation) | RareRitualsScreen | - | - | - | - | UI_ONLY |

## 19. Settings & Preferences

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Notification Cadence Toggles | SettingsScreen | - | - | - | notification_provider | UI_ONLY |
| Push Permission Request | SettingsScreen | - | - | - | - | UI_ONLY |
| Pin Code Editor | PrivacyDashboardScreen | - | user_profiles | PUT /users/profile | privacy_provider | UI_ONLY |

## 20. Profile Management

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| View Profile Hub | ProfileHubScreen | - | - | - | profile_provider | UI_ONLY |
| Edit Account Details (name/email/phone) | AccountDetailsScreen | - | users | PUT /users/account-details | profile_provider | IMPLEMENTED |
| OAuth Re-authorization (email change) | AccountDetailsScreen | - | - | - | - | UI_ONLY |
| OTP Verification (phone change) | AccountDetailsScreen | - | - | - | - | UI_ONLY |
| Connect Anonymous to OAuth Account | ProfileHubScreen | - | - | - | auth_provider | UI_ONLY |

## 21. Error & Empty States

| Feature | Screen(s) | Backend Service | DB Tables | Endpoints | Flutter Provider | Status |
|---|---|---|---|---|---|---|
| Network Error State | ErrorEmptyScreen | - | - | - | - | UI_ONLY |
| Empty Shelf State | ErrorEmptyScreen | - | - | - | - | UI_ONLY |
| Empty Inbox State | ErrorEmptyScreen | - | - | - | - | UI_ONLY |
| Early Days State | ErrorEmptyScreen | - | - | - | - | UI_ONLY |
| No Interventions State | ErrorEmptyScreen | - | - | - | - | UI_ONLY |

---

## Summary Statistics

| Category | Features | Implemented | UI Only |
|---|---|---|---|
| Authentication & Account | 7 | 7 | 0 |
| Onboarding Flow | 9 | 9 | 0 |
| Daily Check-ins | 6 | 4 | 2 |
| Skin Tracking | 5 | 5 | 0 |
| Cycle Tracking | 4 | 3 | 1 |
| Product Shelf | 4 | 3 | 1 |
| Routine Management | 4 | 4 | 0 |
| Insights & Analytics | 5 | 5 | 0 |
| Commerce & Payments | 7 | 7 | 0 |
| Orders & Bookings | 7 | 7 | 0 |
| Credits Economy | 4 | 2 | 2 |
| Privacy & Consent | 4 | 4 | 0 |
| Notifications | 3 | 2 | 1 |
| Support & Help | 3 | 3 | 0 |
| B2B Practitioner | 7 | 4 | 3 |
| Wearable Integration | 3 | 3 | 0 |
| Environmental Data | 2 | 2 | 0 |
| Rituals | 3 | 2 | 1 |
| Settings & Preferences | 3 | 0 | 3 |
| Profile Management | 5 | 1 | 4 |
| Error & Empty States | 5 | 0 | 5 |
| **Total** | **98** | **77** | **21** |
