# API Traceability — RARE Mobile Application

> Complete mapping of every screen action to backend endpoints.
> Base URL: `http://localhost:8000/api/v1`

---

## Authentication

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| SplashReturningScreen | App launch — check existing token | `/api/v1/auth/me` | GET | - | `{id, email, name, role, is_anonymous}` | users | IMPLEMENTED |
| SplashReturningScreen | Tap "Unlock with Face ID" | `/api/v1/auth/me` | GET | - | UserResponse | users | IMPLEMENTED |
| SplashReturningScreen | Tap "Create Account" | `/api/v1/auth/signup` | POST | `{email?, name?, password?}` | TokenResponse | users, refresh_tokens, onboarding_progress, credit_balances | IMPLEMENTED |
| WelcomeScreen | Tap "Begin →" | `/api/v1/onboarding/progress` | GET | - | OnboardingProgressResponse | onboarding_progress | IMPLEMENTED |
| AccountSyncScreen | Tap "Connect My Account" | `/api/v1/auth/signup` | POST | `{email, name, password}` | TokenResponse | users, refresh_tokens | IMPLEMENTED |
| AccountSyncScreen | Tap "Skip for now — start anonymously" | `/api/v1/auth/signup` | POST | `{}` | TokenResponse (anonymous) | users, refresh_tokens | IMPLEMENTED |
| SettingsScreen | Logout | `/api/v1/auth/logout` | POST | `{refresh_token}` | 204 No Content | refresh_tokens | IMPLEMENTED |

## Token Management

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| Any (auto) | Token refresh (interceptor) | `/api/v1/auth/refresh` | POST | `{refresh_token}` | TokenResponse | refresh_tokens | IMPLEMENTED |

## Onboarding

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| WelcomeScreen | Load progress | `/api/v1/onboarding/progress` | GET | - | OnboardingProgressResponse | onboarding_progress | IMPLEMENTED |
| WelcomeScreen | Tap "Begin →" (update step) | `/api/v1/onboarding/step` | PUT | `?step=welcome` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| SoftScanScreen | Submit skin scan results | `/api/v1/onboarding/soft-scan` | POST | `{skin_type?, barrier_status?, adaptive_tags?, scan_metadata?, confidence?, is_manual_fallback?}` | SoftScanResponse | soft_scans, user_profiles | IMPLEMENTED |
| SoftScanScreen | Update onboarding step | `/api/v1/onboarding/step` | PUT | `?step=skin_scan` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| AccountSyncScreen | Update onboarding step | `/api/v1/onboarding/step` | PUT | `?step=privacy_consent` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| PrivacyGateScreen | Save privacy consent | `/api/v1/onboarding/privacy-consent` | POST | `{category, consented}` | PrivacyConsentResponse | privacy_consents | IMPLEMENTED |
| PrivacyGateScreen | Update onboarding step | `/api/v1/onboarding/step` | PUT | `?step=privacy_consent` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| CycleBaselineScreen | Save cycle baseline | `/api/v1/onboarding/cycle-baseline` | POST | `{cycle_length, last_period_start}` | UserProfileResponse | user_profiles | IMPLEMENTED |
| CycleBaselineScreen | Update onboarding step | `/api/v1/onboarding/step` | PUT | `?step=cycle_baseline` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| WearableConnectionScreen | Connect wearable | `/api/v1/onboarding/wearable` | POST | `{provider, device_id}` | UserProfileResponse | user_profiles | IMPLEMENTED |
| WearableConnectionScreen | Update onboarding step | `/api/v1/onboarding/step` | PUT | `?step=wearable` | OnboardingProgress | onboarding_progress | IMPLEMENTED |
| AuraAwakeningScreen | Complete onboarding | `/api/v1/onboarding/step` | PUT | `?step=complete` | OnboardingProgress | onboarding_progress | IMPLEMENTED |

## User Profile

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| ProfileHubScreen | Load profile | `/api/v1/users/profile` | GET | - | UserProfileResponse | user_profiles | IMPLEMENTED |
| PrecisionProfileScreen | View precision scores | `/api/v1/users/profile` | GET | - | UserProfileResponse (hydration_index, barrier_function, etc.) | user_profiles | IMPLEMENTED |
| AccountDetailsScreen | Save name/email/phone | `/api/v1/users/account-details` | PUT | `{name?, email?, phone?}` | `{status: "updated"}` | users | IMPLEMENTED |
| Any (profile update) | Update profile fields | `/api/v1/users/profile` | PUT | `{skin_type?, barrier_status?, hydration_index?, ...}` | UserProfileResponse | user_profiles | IMPLEMENTED |

## Daily Check-ins

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| AMCheckinScreen | Save AM check-in | `/api/v1/checkins/am` | POST | `{checkin_type: "am", sleep_hours?, mood?, energy?, stress?, skin_feel?, tags?, notes?}` | DailyCheckinResponse | daily_checkins | IMPLEMENTED |
| PMCheckinScreen | Save PM check-in | `/api/v1/checkins/pm` | POST | `{checkin_type: "pm", sleep_hours?, mood?, energy?, stress?, skin_feel?, tags?, notes?}` | DailyCheckinResponse | daily_checkins | IMPLEMENTED |
| HomeScreen | Load today's check-ins | `/api/v1/checkins/today` | GET | - | `{checkins: [...], hydration: {...}}` | daily_checkins, hydration_logs | IMPLEMENTED |
| DataLogEditHistoryScreen | Edit past check-in | `/api/v1/checkins/{checkin_id}` | PUT | `{sleep_hours?, mood?, energy?, stress?, skin_feel?, tags?, notes?}` | DailyCheckinResponse | daily_checkins | IMPLEMENTED |

## Hydration Tracking

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| HomeScreen | Tap hydration vessel | `/api/v1/checkins/today` | GET | - | hydration data included | hydration_logs | IMPLEMENTED |

## Skin Tracking

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| SkinLogScreen | Save skin log | `/api/v1/skin/log` | POST | `{tags?, notes?, rating?}` | SkinLogResponse | skin_logs | IMPLEMENTED |
| QuickLogScreen | Log caffeine/alcohol/energy | `/api/v1/skin/log` | POST | `{tags: ["caffeine"], notes?}` | SkinLogResponse | skin_logs | IMPLEMENTED |
| SkinProgressTimelineScreen | Load skin timeline | `/api/v1/skin/timeline` | GET | `?page=1&page_size=20&start_date=&end_date=` | SkinTimelineResponse | skin_logs, skin_photos | IMPLEMENTED |
| SkinProgressTimelineScreen | Delete skin photo | `/api/v1/skin/{log_id}` | DELETE | - | `{status: "deleted"}` | skin_logs | IMPLEMENTED |
| SkinLogScreen | Upload skin photo | `/api/v1/skin/photo` | POST | `multipart/form-data` | `{status: "upload_endpoint"}` | skin_photos | IMPLEMENTED |

## Cycle Tracking

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| CycleCalendarScreen | Load calendar | `/api/v1/cycle/calendar` | GET | - | `{events: [...], cycle_length, last_period_start}` | cycle_events, user_profiles | IMPLEMENTED |
| CycleCalendarScreen | Log period start | `/api/v1/cycle/event` | POST | `?event_type=period_start&event_date=&notes=` | `{status: "created", event_id}` | cycle_events, user_profiles | IMPLEMENTED |
| CycleCalendarScreen | Log period end | `/api/v1/cycle/event` | POST | `?event_type=period_end&event_date=&notes=` | `{status: "created", event_id}` | cycle_events | IMPLEMENTED |
| CycleCalendarScreen | Log ovulation | `/api/v1/cycle/event` | POST | `?event_type=ovulation&event_date=&notes=` | `{status: "created", event_id}` | cycle_events | IMPLEMENTED |
| CycleCalendarScreen | Log spotting | `/api/v1/cycle/event` | POST | `?event_type=spotting&event_date=&notes=` | `{status: "created", event_id}` | cycle_events | IMPLEMENTED |
| CycleCalendarScreen | Pause tracking | `/api/v1/cycle/pause` | PUT | - | `{status: "paused"}` | - | IMPLEMENTED |

## Wearable Integration

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| WearableConnectionScreen | Check wearable status | `/api/v1/wearable/status` | GET | - | `{connected, provider, device_id, last_sync}` | user_profiles | IMPLEMENTED |
| WearableConnectionScreen | Sync wearable data | `/api/v1/wearable/sync` | POST | - | `{status: "synced"}` | wearable_syncs | IMPLEMENTED |
| WearableConnectionScreen | Disconnect wearable | `/api/v1/wearable/disconnect` | DELETE | - | `{status: "disconnected"}` | user_profiles | IMPLEMENTED |

## Product Shelf

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| ShelfScreen | Load shelf items | `/api/v1/shelf/items` | GET | - | `{items: [...]}` | shelf_items, products | IMPLEMENTED |
| DepletionConfirmationScreen | Confirm depletion | `/api/v1/shelf/depletion-confirm` | POST | `{item_id, is_depleted}` | `{status, item_id, status}` | shelf_items | IMPLEMENTED |
| OptimizeShelfScreen | Toggle auto-swap | `/api/v1/shelf/auto-swap` | PUT | `?item_id=&enabled=` | `{status, item_id, auto_swap_enabled}` | shelf_items | IMPLEMENTED |

## Routine Management

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| RoutineBuilderScreen | Load routines | `/api/v1/routine/` | GET | - | `{routines: [...]}` | routines, routine_steps | IMPLEMENTED |
| RoutineBuilderScreen | Create routine | `/api/v1/routine/` | POST | `{name, routine_type, steps: [{product_id?, step_order, step_name, instruction?}]}` | RoutineResponse | routines, routine_steps | IMPLEMENTED |
| RoutineBuilderScreen | Update routine | `/api/v1/routine/{routine_id}` | PUT | `{name?, routine_type?, is_active?}` | RoutineResponse | routines | IMPLEMENTED |
| RoutineInterventionLogScreen | View interventions | `/api/v1/routine/interventions` | GET | - | `{interventions: [...]}` | routine_interventions | IMPLEMENTED |

## Insights

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| BiweeklyWrappedScreen | Load biweekly insights | `/api/v1/insights/biweekly` | GET | - | `{insights: [...], period_start, period_end}` | insights | IMPLEMENTED |
| MonthlySynthesisScreen | Load monthly insights | `/api/v1/insights/monthly` | GET | - | `{insights: [...], month}` | insights | IMPLEMENTED |
| PulseFeedScreen | Load pulse feed | `/api/v1/insights/pulse` | GET | - | `{insights: [...], total}` | insights | IMPLEMENTED |

## Environmental Data

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| EnvironmentalMapScreen | Load environmental data | `/api/v1/environmental/current` | GET | - | `{pincode, city, aqi, pm25, pm10, humidity, uv_index, recorded_at}` | environmental_data | IMPLEMENTED |
| EnvironmentalMapScreen | Load by pincode | `/api/v1/environmental/by-pincode` | GET | `?pincode=` | Environmental data | environmental_data | IMPLEMENTED |

## Commerce / Cart

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| OptimizeShelfScreen | View products | `/api/v1/products/` | GET | `?category=&page=` | `{products: [...], total}` | products | IMPLEMENTED |
| OptimizeShelfScreen | View product detail | `/api/v1/products/{product_id}` | GET | - | ProductResponse | products | IMPLEMENTED |
| OptimizeShelfScreen | Add to cart | `/api/v1/commerce/cart/items` | POST | `{product_id, quantity}` | `{cart: {...}}` | carts, cart_items | IMPLEMENTED |
| CheckoutStateScreen | View cart | `/api/v1/commerce/cart` | GET | - | `{cart: {...}}` | carts, cart_items | IMPLEMENTED |
| CheckoutStateScreen | Remove from cart | `/api/v1/commerce/cart/items/{item_id}` | DELETE | - | `{cart: {...}}` | carts, cart_items | IMPLEMENTED |
| CheckoutStateScreen | Checkout | `/api/v1/commerce/checkout` | POST | `{shipping_address, payment_method?}` | `{order, payment_order_id}` | orders, order_items, products | IMPLEMENTED |
| CheckoutStateScreen | Verify payment | `/api/v1/commerce/verify-payment` | POST | `{order_id, payment_id, signature}` | `{status: "verified", payment_id}` | payments, orders | IMPLEMENTED |

## Orders

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| OrderBookingHistoryScreen | Load orders | `/api/v1/orders/` | GET | `?page=` | `{orders: [...], total}` | orders | IMPLEMENTED |
| OrderBookingHistoryScreen | View order detail | `/api/v1/orders/{order_id}` | GET | - | OrderResponse | orders, order_items | IMPLEMENTED |

## Bookings

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| PlanMyReliefScreen | Load services | `/api/v1/bookings/services` | GET | - | `[{id, name, description, duration_minutes, price_inr}]` | - | IMPLEMENTED |
| PlanMyReliefScreen | Check availability | `/api/v1/bookings/availability` | GET | `?practitioner_id=&date=` | `[{time, available}]` | - | IMPLEMENTED |
| BookingWebviewScreen | Create booking | `/api/v1/bookings/` | POST | `{service_id, practitioner_id, scheduled_at, notes?}` | BookingResponse | treatment_sessions, practitioner_clients | IMPLEMENTED |
| OrderBookingHistoryScreen | Load bookings | `/api/v1/bookings/` | GET | - | `{bookings: [...]}` | treatment_sessions | IMPLEMENTED |
| OrderBookingHistoryScreen | Cancel booking | `/api/v1/bookings/{booking_id}/cancel` | PUT | - | `{id, status: "cancelled"}` | treatment_sessions | IMPLEMENTED |

## Credits

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| CreditsLedgerScreen | Load balance | `/api/v1/credits/balance` | GET | - | `{balance, updated_at}` | credit_balances | IMPLEMENTED |
| CreditsLedgerScreen | Load transactions | `/api/v1/credits/transactions` | GET | - | `{transactions: [...]}` | credit_transactions | IMPLEMENTED |

## Privacy

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| PrivacyDashboardScreen | Load consents | `/api/v1/privacy/consents` | GET | - | `{consents: [...]}` | privacy_consents | IMPLEMENTED |
| PrivacyDashboardScreen | Update consent | `/api/v1/privacy/consents` | PUT | `{category, consented}` | `{status: "updated", consent_id}` | privacy_consents, privacy_audit_logs | IMPLEMENTED |
| PrivacyDashboardScreen | Request data export | `/api/v1/privacy/export` | POST | `{export_type, email?}` | `{status: "export_requested"}` | privacy_audit_logs | IMPLEMENTED |
| KillSwitchScreen | Request account deletion | `/api/v1/privacy/delete` | POST | `{confirmation: "DELETE_MY_ACCOUNT", reason?}` | `{status: "deletion_requested"}` | privacy_audit_logs | IMPLEMENTED |

## Notifications / Inbox

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| QuietInboxScreen | Load notifications | `/api/v1/inbox/` | GET | `?unread_only=` | `{notifications: [...]}` | notifications | IMPLEMENTED |
| QuietInboxScreen | Mark notification read | `/api/v1/inbox/{notification_id}/read` | PUT | - | `{status: "read", updated: count}` | notifications | IMPLEMENTED |

## Support

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| HelpSupportScreen | Create support ticket | `/api/v1/support/tickets` | POST | `{subject, description}` | SupportTicketResponse | support_tickets | IMPLEMENTED |
| HelpSupportScreen | Load tickets | `/api/v1/support/tickets` | GET | - | `{tickets: [...]}` | support_tickets | IMPLEMENTED |
| HelpSupportScreen | Add message to ticket | `/api/v1/support/tickets/{ticket_id}/messages` | POST | `{message, attachment_url?}` | SupportMessageResponse | support_messages | IMPLEMENTED |

## Legal Documents

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| LegalDocumentsScreen | View legal documents | - | - | - | - | legal_documents | UI_ONLY |

## Rituals

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| RareRitualsScreen | Load featured rituals | `/api/v1/rituals/featured` | GET | - | `{featured: [...]}` | - | IMPLEMENTED |
| RareRitualsScreen | Load ritual library | `/api/v1/rituals/library` | GET | `?page=` | `{rituals: [...], total, page}` | - | IMPLEMENTED |

## B2B / Practitioner

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| PractitionerLoginScreen | Practitioner login | `/api/v1/practitioner/login` | POST | `{email, password}` | `{access_token, token_type, user}` | users | IMPLEMENTED |
| PreTreatmentSyncScreen | Load client summary | `/api/v1/practitioner/clients/{client_id}` | GET | - | ClientSummaryResponse | users, user_profiles, daily_checkins, skin_logs | IMPLEMENTED |
| PreTreatmentSyncScreen | Share data (create session) | `/api/v1/practitioner/sessions` | POST | `{client_id, session_type, pre_treatment_notes?, post_treatment_notes?, protocol?}` | TreatmentSessionResponse | treatment_sessions | IMPLEMENTED |
| PostTreatmentProtocolScreen | Load protocol | `/api/v1/practitioner/sessions/{session_id}/protocol` | GET | - | TreatmentSessionResponse | treatment_sessions | IMPLEMENTED |

## Admin

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| - | Admin dashboard | `/api/v1/admin/dashboard` | GET | - | `{status, message}` | - | STUB |
| - | List users | `/api/v1/admin/users` | GET | - | `{users: [], message}` | - | STUB |

## Health Check

| Screen | User Action | Backend Endpoint | Method | Request Body | Response | DB Entity | Status |
|---|---|---|---|---|---|---|---|
| - | Health check | `/health` | GET | - | `{status: "healthy", service, version}` | - | IMPLEMENTED |

---

## Summary Statistics

| Category | Endpoints | Implemented | Stub/UI Only |
|---|---|---|---|
| Authentication | 5 | 5 | 0 |
| Onboarding | 6 | 6 | 0 |
| User Profile | 3 | 3 | 0 |
| Daily Check-ins | 4 | 4 | 0 |
| Skin Tracking | 5 | 5 | 0 |
| Cycle Tracking | 6 | 6 | 0 |
| Wearable | 3 | 3 | 0 |
| Product Shelf | 3 | 3 | 0 |
| Routine | 4 | 4 | 0 |
| Insights | 3 | 3 | 0 |
| Environmental | 2 | 2 | 0 |
| Commerce | 6 | 6 | 0 |
| Orders | 2 | 2 | 0 |
| Bookings | 5 | 5 | 0 |
| Credits | 2 | 2 | 0 |
| Privacy | 4 | 4 | 0 |
| Notifications | 2 | 2 | 0 |
| Support | 3 | 3 | 0 |
| Legal | 0 | 0 | 1 (UI only) |
| Rituals | 2 | 2 | 0 |
| B2B Practitioner | 4 | 4 | 0 |
| Admin | 2 | 0 | 2 (stubs) |
| Health | 1 | 1 | 0 |
| **Total** | **77** | **75** | **2** |
