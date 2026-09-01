# Database Documentation — RARE Mobile Application

> Complete reference for all 34 database tables, their columns, relationships, indexes, and business rules.
> Database: PostgreSQL (via SQLAlchemy ORM)

---

## Enums

| Enum Name | Values | Used In |
|---|---|---|
| `UserRole` | `user`, `practitioner`, `admin`, `partner` | users.role |
| `OnboardingStep` | `welcome`, `skin_scan`, `privacy_consent`, `cycle_baseline`, `wearable`, `complete` | onboarding_progress.current_step |
| `CheckinType` | `am`, `pm` | daily_checkins.checkin_type |
| `CycleEventType` | `period_start`, `period_end`, `ovulation`, `spotting` | cycle_events.event_type |
| `ShelfStatus` | `standard`, `armed`, `depleted` | shelf_items.status |
| `RoutineType` | `am`, `pm`, `both` | routines.routine_type |
| `InterventionType` | `algorithm`, `auto_swap`, `practitioner`, `manual_edit` | routine_interventions.intervention_type |
| `InsightType` | `biweekly`, `monthly`, `pulse` | insights.insight_type |
| `PrivacyCategory` | `phone_activity`, `pin_code`, `cycle_tracking`, `skin_photos`, `purchase_history`, `wearable_data` | privacy_consents.category |
| `OrderStatus` | `pending`, `confirmed`, `processing`, `shipped`, `delivered`, `cancelled` | orders.status |
| `PaymentStatus` | `pending`, `captured`, `failed`, `refunded` | payments.status |
| `CreditTransactionType` | `credit`, `debit` | credit_transactions.transaction_type |
| `SupportStatus` | `open`, `in_progress`, `resolved`, `closed` | support_tickets.status |
| `LegalDocType` | `privacy_policy`, `terms` | legal_documents.document_type |

---

## Tables

### 1. users

Primary user table. Supports email/password auth and anonymous users.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| email | String(255) | UNIQUE, INDEX, NULLABLE | User email address |
| phone | String(20) | UNIQUE, INDEX, NULLABLE | Phone number |
| name | String(255) | NULLABLE | Display name |
| password_hash | String(255) | NOT NULL | bcrypt password hash |
| role | Enum(UserRole) | NOT NULL, DEFAULT 'user' | User role |
| is_active | Boolean | NOT NULL, DEFAULT true | Account active flag |
| is_anonymous | Boolean | NOT NULL, DEFAULT false | Anonymous user flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Account creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, email (unique), phone (unique)

---

### 2. user_profiles

Extended user profile with skin, cycle, and wearable data.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, UNIQUE, NOT NULL, INDEX | One-to-one with users |
| skin_type | String(50) | NULLABLE | Skin type classification |
| barrier_status | String(50) | NULLABLE | Skin barrier status |
| hydration_index | Float | NULLABLE | Hydration score (0-100) |
| barrier_function | Float | NULLABLE | Barrier function score (0-100) |
| sebum_balance | Float | NULLABLE | Sebum balance score (0-100) |
| sensitivity_score | Float | NULLABLE | Sensitivity score (0-100) |
| cycle_length | Integer | NULLABLE | Average cycle length in days |
| last_period_start | Date | NULLABLE | Last period start date |
| wearable_provider | String(50) | NULLABLE | Wearable provider name |
| wearable_device_id | String(255) | NULLABLE | Connected device ID |
| last_wearable_sync | DateTime | NULLABLE | Last sync timestamp |
| pincode | String(10) | NULLABLE, INDEX | Location pincode |
| city | String(100) | NULLABLE | City name |
| latitude | Float | NULLABLE | GPS latitude |
| longitude | Float | NULLABLE | GPS longitude |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id (unique), pincode

---

### 3. refresh_tokens

JWT refresh token storage for session management.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| token | String(500) | UNIQUE, NOT NULL, INDEX | Refresh token string |
| expires_at | DateTime | NOT NULL | Token expiration timestamp |
| revoked | Boolean | NOT NULL, DEFAULT false | Revocation flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id, token (unique)

---

### 4. onboarding_progress

Tracks user onboarding completion state.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, UNIQUE, NOT NULL, INDEX | One-to-one with users |
| current_step | Enum(OnboardingStep) | NOT NULL, DEFAULT 'welcome' | Current onboarding step |
| completed_steps | JSON | NOT NULL, DEFAULT [] | List of completed step names |
| is_complete | Boolean | NOT NULL, DEFAULT false | Onboarding completion flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id (unique)

---

### 5. privacy_consents

Granular privacy consent per data category.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| category | Enum(PrivacyCategory) | NOT NULL | Consent category |
| consented | Boolean | NOT NULL, DEFAULT false | Consent granted flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id

**Business Rule:** One consent record per user per category. Upserted on update.

---

### 6. soft_scans

Skin scan results from onboarding.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| skin_type | String(50) | NULLABLE | Detected skin type |
| barrier_status | String(50) | NULLABLE | Detected barrier status |
| adaptive_tags | JSON | DEFAULT [] | AI-generated tags |
| scan_metadata | JSON | DEFAULT {} | Scan metadata (lighting, etc.) |
| confidence | Float | NULLABLE | Detection confidence (0-1) |
| is_manual_fallback | Boolean | DEFAULT false | Manual selection flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

---

### 7. daily_checkins

AM and PM daily check-in records.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| checkin_type | Enum(CheckinType) | NOT NULL | AM or PM |
| date | Date | NOT NULL, INDEX | Check-in date |
| sleep_hours | Float | NULLABLE | Sleep duration (hours) |
| mood | Integer | NULLABLE | Mood rating (0-10) |
| energy | Integer | NULLABLE | Energy level (0-10) |
| stress | Integer | NULLABLE | Stress level (0-10) |
| skin_feel | String(50) | NULLABLE | Skin feel description |
| tags | JSON | DEFAULT [] | Context tags (Sick, Travel, Stress) |
| notes | Text | NULLABLE | Free-form notes |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id, date

---

### 8. hydration_logs

Daily hydration tracking.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| date | Date | NOT NULL, INDEX | Log date |
| volume_ml | Integer | NOT NULL, DEFAULT 0 | Volume in milliliters |
| tap_count | Integer | NOT NULL, DEFAULT 0 | Number of taps logged |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id, date

---

### 9. skin_logs

Detailed skin condition log entries.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| tags | JSON | DEFAULT [] | Skin condition tags |
| notes | Text | NULLABLE | Free-form notes |
| rating | Integer | NULLABLE | Self-rating (1-5) |
| photo_url | String(500) | NULLABLE | Photo URL |
| photo_key | String(500) | NULLABLE | Storage key |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

---

### 10. skin_photos

Skin photo storage with soft delete.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| skin_log_id | Integer | FK(skin_logs.id) SET NULL, NULLABLE | Associated skin log |
| file_key | String(500) | NOT NULL | Storage file key |
| file_url | String(500) | NULLABLE | File URL |
| tags | JSON | DEFAULT [] | Photo tags |
| is_deleted | Boolean | DEFAULT false | Soft delete flag |
| deleted_at | DateTime | NULLABLE | Deletion timestamp |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

**Business Rule:** Deleted photos are flagged "ignored, never trained on."

---

### 11. cycle_events

Menstrual cycle event records.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| event_type | Enum(CycleEventType) | NOT NULL | Event type |
| date | Date | NOT NULL, INDEX | Event date |
| notes | Text | NULLABLE | Free-form notes |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id, date

**Business Rule:** `period_start` events auto-update `user_profiles.last_period_start`.

---

### 12. wearable_syncs

Wearable device data sync records.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| provider | String(50) | NOT NULL | Provider name (apple_health, google_fit) |
| device_id | String(255) | NOT NULL | Device identifier |
| metric_type | String(50) | NOT NULL | Metric type (sleep, heart_rate, steps) |
| value | Float | NOT NULL | Metric value |
| unit | String(20) | NOT NULL | Unit of measurement |
| recorded_at | DateTime | NOT NULL | When metric was recorded |
| synced_at | DateTime | NOT NULL, DEFAULT utcnow | When data was synced |

**Indexes:** PK, user_id

---

### 13. shelf_items

Product shelf tracking with depletion and auto-swap.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| product_id | Integer | FK(products.id) SET NULL, NULLABLE | Associated product |
| status | Enum(ShelfStatus) | NOT NULL, DEFAULT 'standard' | Shelf status |
| depletion_estimate_days | Integer | NULLABLE | Estimated days until depletion |
| last_restocked | DateTime | NULLABLE | Last restock timestamp |
| auto_swap_enabled | Boolean | DEFAULT false | Auto-swap enabled flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id

---

### 14. products

Product catalog.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| name | String(255) | NOT NULL | Product name |
| brand | String(255) | NULLABLE | Brand name |
| description | Text | NULLABLE | Product description |
| category | String(100) | NULLABLE, INDEX | Product category |
| price_inr | Numeric(10,2) | NOT NULL | Price in INR |
| image_url | String(500) | NULLABLE | Product image URL |
| stock_quantity | Integer | NOT NULL, DEFAULT 0 | Stock count |
| is_active | Boolean | NOT NULL, DEFAULT true | Active flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, category

---

### 15. routines

User skincare routines.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| name | String(255) | NOT NULL | Routine name |
| routine_type | Enum(RoutineType) | NOT NULL, DEFAULT 'both' | AM/PM/Both |
| is_active | Boolean | DEFAULT true | Active flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id

---

### 16. routine_steps

Individual steps within a routine.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| routine_id | Integer | FK(routines.id) CASCADE, NOT NULL, INDEX | Parent routine |
| product_id | Integer | FK(products.id) SET NULL, NULLABLE | Associated product |
| step_order | Integer | NOT NULL | Step order (1-based) |
| step_name | String(255) | NOT NULL | Step name (Cleanse, Treat, etc.) |
| instruction | Text | NULLABLE | Step instructions |
| is_active | Boolean | DEFAULT true | Active flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, routine_id

**Business Rule:** Steps are ordered by `step_order`. Cascade delete with parent routine.

---

### 17. routine_interventions

Log of all routine changes (algorithm, auto-swap, practitioner, manual).

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| routine_id | Integer | FK(routines.id) SET NULL, NULLABLE | Associated routine |
| intervention_type | Enum(InterventionType) | NOT NULL | Source of intervention |
| description | Text | NOT NULL | Intervention description |
| reason | Text | NULLABLE | Reason for intervention |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

**Business Rule:** All routine changes are logged for audit trail. Never silently overwritten.

---

### 18. insights

Generated insights (biweekly, monthly, pulse).

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| insight_type | Enum(InsightType) | NOT NULL, INDEX | Insight type |
| title | String(255) | NOT NULL | Insight title |
| body | Text | NOT NULL | Insight body text |
| variable_a | String(100) | NULLABLE | First correlated variable |
| variable_b | String(100) | NULLABLE | Second correlated variable |
| observation_count | Integer | NOT NULL, DEFAULT 0 | Number of observations |
| confidence | Float | NULLABLE | Confidence score (0-1) |
| tier | String(50) | NULLABLE | Confidence tier |
| claim | Text | NULLABLE | Insight claim |
| confound | Text | NULLABLE | Confounding factors |
| is_active | Boolean | NOT NULL, DEFAULT true | Active flag |
| period_start | Date | NULLABLE | Insight period start |
| period_end | Date | NULLABLE | Insight period end |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id, insight_type

**Business Rule:** RARE Pulse insights are suppressed below 100-user segment threshold.

---

### 19. environmental_data

AQI, UV, and environmental data by pincode.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) SET NULL, NULLABLE | Associated user (nullable) |
| pincode | String(10) | NULLABLE, INDEX | Location pincode |
| city | String(100) | NULLABLE | City name |
| latitude | Float | NULLABLE | GPS latitude |
| longitude | Float | NULLABLE | GPS longitude |
| aqi | Integer | NULLABLE | Air Quality Index |
| pm25 | Float | NULLABLE | PM2.5 level |
| pm10 | Float | NULLABLE | PM10 level |
| humidity | Float | NULLABLE | Humidity percentage |
| uv_index | Float | NULLABLE | UV index |
| monitoring_coverage | String(50) | NULLABLE | Monitoring station coverage |
| recorded_at | DateTime | NOT NULL, INDEX | When data was recorded |
| cached_until | DateTime | NULLABLE | Cache expiration |

**Indexes:** PK, pincode, recorded_at

---

### 20. carts

User shopping carts (one per user).

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, UNIQUE, NOT NULL, INDEX | One-to-one with users |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id (unique)

---

### 21. cart_items

Items within a shopping cart.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| cart_id | Integer | FK(carts.id) CASCADE, NOT NULL, INDEX | Parent cart |
| product_id | Integer | FK(products.id) CASCADE, NOT NULL | Associated product |
| quantity | Integer | NOT NULL, DEFAULT 1 | Quantity |
| added_at | DateTime | NOT NULL, DEFAULT utcnow | When item was added |

**Indexes:** PK, cart_id

---

### 22. orders

Customer orders.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| order_number | String(50) | UNIQUE, NOT NULL, INDEX | Human-readable order number |
| status | Enum(OrderStatus) | NOT NULL, DEFAULT 'pending', INDEX | Order status |
| subtotal_inr | Numeric(10,2) | NOT NULL | Subtotal in INR |
| shipping_inr | Numeric(10,2) | NOT NULL, DEFAULT 0 | Shipping cost in INR |
| tax_inr | Numeric(10,2) | NOT NULL, DEFAULT 0 | Tax in INR (18% GST) |
| total_inr | Numeric(10,2) | NOT NULL | Total in INR |
| shipping_address | JSON | NULLABLE | Shipping address |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id, order_number (unique), status

**Business Rule:** Order number format: `RARE-{hex}-{timestamp}`. Shipping free above ₹500.

---

### 23. order_items

Line items within an order.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| order_id | Integer | FK(orders.id) CASCADE, NOT NULL, INDEX | Parent order |
| product_id | Integer | FK(products.id) CASCADE, NOT NULL | Associated product |
| quantity | Integer | NOT NULL | Quantity ordered |
| unit_price_inr | Numeric(10,2) | NOT NULL | Unit price at time of order |
| total_price_inr | Numeric(10,2) | NOT NULL | Total price for this line |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, order_id

**Business Rule:** Unit price snapshot preserved at order time (price history).

---

### 24. payments

Payment records linked to orders.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| order_id | Integer | FK(orders.id) CASCADE, NOT NULL, INDEX | Associated order |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Payer user |
| provider | String(50) | NOT NULL | Payment provider (razorpay) |
| payment_order_id | String(255) | NULLABLE | Provider order ID |
| payment_id | String(255) | NULLABLE | Provider payment ID |
| signature | String(500) | NULLABLE | Payment signature |
| amount_inr | Numeric(10,2) | NOT NULL | Amount in INR |
| currency | String(10) | NOT NULL, DEFAULT 'INR' | Currency code |
| status | Enum(PaymentStatus) | NOT NULL, DEFAULT 'pending', INDEX | Payment status |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| verified_at | DateTime | NULLABLE | Verification timestamp |

**Indexes:** PK, order_id, user_id, status

**Business Rule:** Razorpay signature verification via HMAC-SHA256.

---

### 25. credit_balances

User credit balance (one per user).

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, UNIQUE, NOT NULL, INDEX | One-to-one with users |
| balance | Integer | NOT NULL, DEFAULT 0 | Current balance (1 Credit = ₹1) |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id (unique)

---

### 26. credit_transactions

Credit earn/spend history.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| amount | Integer | NOT NULL | Transaction amount (positive) |
| transaction_type | Enum(CreditTransactionType) | NOT NULL | credit or debit |
| reason | String(255) | NULLABLE | Transaction reason |
| reference_type | String(50) | NULLABLE | Reference entity type |
| reference_id | Integer | NULLABLE | Reference entity ID |
| balance_after | Integer | NOT NULL | Balance after transaction |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

**Business Rule:** Credits earn: AM Check-in (+10), 14-Day Resonance (+15), Ritual Completed (+8). Spend: Rituals (-120). Applied automatically at checkout.

---

### 27. notifications

User notifications and inbox items.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| notification_type | String(50) | NOT NULL | Notification type |
| title | String(255) | NOT NULL | Notification title |
| body | Text | NOT NULL | Notification body |
| target_screen | String(100) | NULLABLE | Deep link target screen |
| payload | JSON | NULLABLE | Additional payload data |
| is_read | Boolean | DEFAULT false | Read flag |
| expires_at | DateTime | NULLABLE | Expiration timestamp |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

**Business Rule:** Auto-clears on read/expire. No badge counts (Quiet Inbox philosophy).

---

### 28. support_tickets

Customer support tickets.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| subject | String(255) | NOT NULL | Ticket subject |
| description | Text | NOT NULL | Ticket description |
| status | Enum(SupportStatus) | NOT NULL, DEFAULT 'open', INDEX | Ticket status |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |
| updated_at | DateTime | NOT NULL, DEFAULT utcnow, ON UPDATE utcnow | Last update timestamp |

**Indexes:** PK, user_id, status

---

### 29. support_messages

Messages within a support ticket.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| ticket_id | Integer | FK(support_tickets.id) CASCADE, NOT NULL, INDEX | Parent ticket |
| sender_id | Integer | FK(users.id) CASCADE, NOT NULL | Message sender |
| message | Text | NOT NULL | Message content |
| attachment_url | String(500) | NULLABLE | Attachment URL |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, ticket_id

**Business Rule:** First user message transitions ticket from `open` to `in_progress`.

---

### 30. practitioner_clients

Practitioner-client relationship links.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| practitioner_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Practitioner user |
| client_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Client user |
| is_active | Boolean | DEFAULT true | Active relationship flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, practitioner_id, client_id

---

### 31. treatment_sessions

Practitioner treatment session records.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| practitioner_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Practitioner user |
| client_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Client user |
| session_type | String(100) | NOT NULL | Session type (consultation, treatment, etc.) |
| pre_treatment_notes | Text | NULLABLE | Pre-treatment notes |
| post_treatment_notes | Text | NULLABLE | Post-treatment notes |
| protocol | JSON | NULLABLE | Treatment protocol data |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, practitioner_id, client_id

**Business Rule:** Practitioner data wiped from tablet storage on session completion.

---

### 32. legal_documents

Privacy policy and terms of service content.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| document_type | Enum(LegalDocType) | NOT NULL | Document type |
| version | String(20) | NOT NULL | Document version |
| content | Text | NOT NULL | Full document content |
| is_active | Boolean | DEFAULT true | Active version flag |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK

---

### 33. privacy_audit_logs

Audit trail for all privacy-related actions.

| Column | Type | Constraints | Description |
|---|---|---|---|
| id | Integer | PK, INDEX | Auto-increment primary key |
| user_id | Integer | FK(users.id) CASCADE, NOT NULL, INDEX | Owner user |
| action | String(100) | NOT NULL | Action type (consent_update, data_export_request, account_deletion_request) |
| details | JSON | NULLABLE | Action details |
| ip_address | String(50) | NULLABLE | Client IP address |
| created_at | DateTime | NOT NULL, DEFAULT utcnow | Creation timestamp |

**Indexes:** PK, user_id

**Business Rule:** Immutable audit log. Records all consent changes, export requests, and deletion requests.

---

## Entity Relationship Diagram (Text)

```
users (1) ──── (1) user_profiles
users (1) ──── (N) refresh_tokens
users (1) ──── (1) onboarding_progress
users (1) ──── (N) privacy_consents
users (1) ──── (N) soft_scans
users (1) ──── (N) daily_checkins
users (1) ──── (N) hydration_logs
users (1) ──── (N) skin_logs
users (1) ──── (N) skin_photos
users (1) ──── (N) cycle_events
users (1) ──── (N) wearable_syncs
users (1) ──── (N) shelf_items
users (1) ──── (N) routines
users (1) ──── (N) routine_interventions
users (1) ──── (N) insights
users (1) ──── (N) environmental_data
users (1) ──── (1) carts
users (1) ──── (N) orders
users (1) ──── (N) payments
users (1) ──── (1) credit_balances
users (1) ──── (N) credit_transactions
users (1) ──── (N) notifications
users (1) ──── (N) support_tickets
users (1) ──── (N) privacy_audit_logs

products (1) ──── (N) shelf_items
products (1) ──── (N) routine_steps
products (1) ──── (N) cart_items
products (1) ──── (N) order_items

routines (1) ──── (N) routine_steps
routines (1) ──── (N) routine_interventions

skin_logs (1) ──── (N) skin_photos

carts (1) ──── (N) cart_items

orders (1) ──── (N) order_items
orders (1) ──── (1) payments

support_tickets (1) ──── (N) support_messages

practitioner_clients: users (practitioner) ──── users (client)
treatment_sessions: users (practitioner) ──── users (client)
```

---

## Ownership Model

Every user-scoped table uses `user_id` as a foreign key with `CASCADE` delete. This ensures:

1. **Data isolation:** Users can only access their own data via `WHERE user_id = current_user.id`
2. **Cascade deletion:** Deleting a user removes all their data
3. **No cross-user queries:** Services always filter by `user_id`
4. **Practitioner exception:** `practitioner_clients` and `treatment_sessions` reference two users (practitioner + client) with access controlled by role

---

## Index Strategy

| Table | Indexes | Purpose |
|---|---|---|
| users | email (unique), phone (unique) | Auth lookups |
| user_profiles | user_id (unique), pincode | Profile lookups, environmental queries |
| refresh_tokens | token (unique), user_id | Token validation, user session lookup |
| daily_checkins | user_id, date | Daily check-in queries |
| hydration_logs | user_id, date | Daily hydration queries |
| cycle_events | user_id, date | Calendar queries |
| insights | user_id, insight_type | Insight type filtering |
| orders | order_number (unique), status | Order lookup, status filtering |
| payments | status | Payment status queries |
| notifications | user_id | Inbox queries |
| support_tickets | status | Ticket status filtering |
| environmental_data | pincode, recorded_at | Location-based queries |

---

## Business Rules Summary

1. **One cart per user** — carts.user_id is UNIQUE
2. **One profile per user** — user_profiles.user_id is UNIQUE
3. **One onboarding record per user** — onboarding_progress.user_id is UNIQUE
4. **One credit balance per user** — credit_balances.user_id is UNIQUE
5. **Consent upsert** — privacy_consents are upserted (one per user per category)
6. **Soft delete for photos** — skin_photos.is_deleted flags deleted photos without removing data
7. **Price snapshot** — order_items.unit_price_inr preserves price at order time
8. **Free shipping above ₹500** — checkout logic in commerce_service
9. **18% GST** — applied during checkout
10. **Order number format** — `RARE-{hex}-{unix_timestamp}`
11. **Credits = ₹1** — 1 Credit equals 1 Indian Rupee
12. **Practitioner data wipe** — treatment session data cleared on completion
13. **Audit trail** — all privacy actions logged to privacy_audit_logs (immutable)
14. **Quiet Inbox** — notifications auto-clear, no badge counts
15. **Segment suppression** — RARE Pulse insights suppressed below 100-user threshold
