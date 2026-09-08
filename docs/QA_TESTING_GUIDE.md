# QA & Testing Guide — RARE Mobile Application

---

## 1. Overview

This document describes how to verify the RARE mobile application and backend functionality, including manual QA checks and automated test execution.

---

## 2. Automated Tests

### 2.1 Backend Tests (pytest)

```bash
cd backend
pytest -v
```

**Test modules:**

| File | Area |
|------|------|
| `test_auth.py` | Registration, login, JWT tokens, password hashing |
| `test_authorization.py` | Role-based access (user, practitioner, admin) |
| `test_checkins.py` | AM/PM daily check-in CRUD |
| `test_commerce.py` | Product listing, cart, checkout, orders |
| `test_credits.py` | Credit balance, earn, redeem, history |
| `test_notifications.py` | Notification CRUD, read/unread |
| `test_onboarding.py` | Onboarding progress tracking |
| `test_privacy.py` | Privacy consent management |
| `test_shelf.py` | Shelf items, depletion, auto-swap |
| `test_skin.py` | Skin log CRUD, rating |
| `conftest.py` | Shared fixtures, test database setup |

### 2.2 Flutter Tests

```bash
flutter test
```

---

## 3. Manual QA Checklist

### 3.1 Onboarding Flow

- [ ] Screen 01 — Welcome screen loads with branding
- [ ] Screen 02 — Skin scan prompt is interactive
- [ ] Screen 03 — Account sync screen renders
- [ ] Screen 04 — Privacy gate shows consent toggles
- [ ] Screen 05 — Cycle baseline input works
- [ ] Screen 06 — Wearable connection screen loads
- [ ] Screen 07 — Aura awakening completion screen

### 3.2 Home & Dashboard

- [ ] Screen 08 — Home screen loads with greeting
- [ ] Screen 29 — Dormant state renders when no data
- [ ] Screen 36 — Quiet inbox renders empty state

### 3.3 Daily Check-in

- [ ] Screen 09 — AM check-in form submits
- [ ] Screen 10 — PM check-in form submits
- [ ] Check-in data persists to backend

### 3.4 Skin Tracking

- [ ] Screen 11 — Skin log entry saves
- [ ] Screen 12 — Quick log form works
- [ ] Screen 35 — Progress timeline renders entries

### 3.5 Shelf & Product Management

- [ ] Screen 13 — Shelf shows products with status
- [ ] Screen 24 — Depletion confirmation displays
- [ ] Screen 21 — Optimize shelf recommendations

### 3.6 Routine

- [ ] Screen 14 — Routine builder loads products
- [ ] Screen 18 — Intervention log records changes

### 3.7 Insights

- [ ] Screen 15 — Biweekly wrapped renders
- [ ] Screen 16 — Monthly synthesis displays
- [ ] Screen 17 — Rare Pulse feed loads
- [ ] Screen 19 — Environmental map shows AQI data
- [ ] Screen 20 — Precision profile renders metrics

### 3.8 Calendar

- [ ] Screen 28 — Cycle calendar shows phases
- [ ] Screen 34 — Data log edit history displays

### 3.9 Settings & Privacy

- [ ] Screen 25 — Settings menu loads
- [ ] Screen 26 — Privacy dashboard shows consents
- [ ] Screen 27 — Kill switch deactivates account
- [ ] Screen 38 — Legal documents render

### 3.10 Commerce & Booking

- [ ] Screen 22 — Plan my relief shows recommendations
- [ ] Screen 23 — Booking webview loads
- [ ] Screen 39 — Checkout state processes order
- [ ] Screen 31 — Order/booking history displays

### 3.11 Profile & Credits

- [ ] Screen 33 — Profile hub shows user info
- [ ] Screen 32 — Credits ledger shows balance and transactions
- [ ] Screen 45 — Account details editable

### 3.12 Support & B2B

- [ ] Screen 40 — Help/support contact form
- [ ] Screen 41 — Rare rituals content loads
- [ ] Screen 42 — Practitioner login works
- [ ] Screen 43 — Pre-treatment sync loads
- [ ] Screen 44 — Post-treatment protocol renders

### 3.13 Error & Edge Cases

- [ ] Screen 30 — Error/empty state displays on network failure
- [ ] Screen 37 — Splash returning user flow
- [ ] Unauthenticated users are redirected to login
- [ ] Expired JWT tokens trigger re-authentication

---

## 4. API Endpoint Verification

Use the Swagger UI at `http://localhost:8000/docs` to test all endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | User registration |
| POST | `/api/auth/login` | User login |
| GET | `/api/users/me` | Current user profile |
| GET | `/api/products` | Product listing |
| POST | `/api/checkins` | Create check-in |
| GET | `/api/shelf` | Get shelf items |
| GET | `/api/insights` | Get insights |
| GET | `/api/credits` | Get credit balance |
| GET | `/api/notifications` | Get notifications |
| POST | `/api/skin-logs` | Create skin log |

---

## 5. Regression Testing

After any code change:

1. Run `pytest -v` in `backend/`
2. Run `flutter analyze`
3. Run `flutter test`
4. Execute the relevant manual QA checklist section

---

## 6. Known Limitations

- Skin analysis AI model requires external API keys (see `.env.example`)
- Razorpay integration requires sandbox credentials for payment testing
- SMTP email export requires valid email service credentials
- Redis caching is optional; tests run without it
- Environmental AQI data uses mock/sandbox mode in development
