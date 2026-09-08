# QA Test Results — RARE Mobile Application V1

**Project:** RARE Mobile Application  
**QA Version:** V1  
**QA Type:** Manual + Backend API + Automated Testing  
**Test Environment:** Development  
**Branch Tested:** `sara_qa`  
**Tester:** Sara  
**Test Date:** 7th September 2026  
**Status:** 🟡 In Progress

---

## 1. Overview

This document records the QA testing performed on the RARE Mobile Application based on the test scenarios defined in `QA_TESTING_GUIDE.md`.

The purpose of this testing cycle is to verify:

- Mobile application functionality
- Backend API integration
- Authentication and authorization
- Data persistence
- Navigation and user flows
- UI/UX behaviour
- Error and edge-case handling
- Backend API responses
- Regression issues introduced by recent changes

---

## 2. Automated Tests

### 2.1 Backend Tests (pytest)

**Command:**

```bash
cd backend
pytest -v
```


**Test Result:**

| Result | Count |
|---|---:|
| Total Tests | 90 |
| Passed | 14 |
| Failed | 2 |
| Skipped | TBD |
| Errors | 74 |

**Status:** 🟡 In Progress

### Test Modules

| Test Module | Area | Result | Status |
|---|---|---|---|
| `test_auth.py` | Registration, login, JWT tokens, password hashing | 2 failed, 4 passed, 7 errors |  Tested |
| `test_authorization.py` | User, practitioner, admin roles | 2 passed, 8 errors | Tested |
| `test_checkins.py` | AM/PM daily check-in CRUD | 1 passed, 8 errors | Tested |
| `test_commerce.py` | Product listing, cart, checkout, orders | 1 passed, 12 errors |  Tested |
| `test_credits.py` | Credit balance, earn, redeem, history | 1 passed, 4 errors | Tested |
| `test_notifications.py` | Notification CRUD, read/unread | 1 passed, 5 errors | Tested |
| `test_onboarding.py` | Onboarding progress tracking | 1 passed, 10 errors | Tested |
| `test_privacy.py` | Privacy consent management | 1 passed, 7 errors |Tested |
| `test_shelf.py` | Shelf items, depletion, auto-swap | 1 passed, 6 errors |  Tested |
| `test_skin.py` | Skin log CRUD, rating | 1 passed, 7 errors |  Tested |

---

### 2.2 Flutter Tests

**Command:**

```bash
flutter test
```

**Test Result:**

| Result | Count |
|---|---:|
| Total Tests | TBD |
| Passed | TBD |
| Failed | TBD |
| Skipped | TBD |

**Status:** 🟡 In Progress

---

## 3. Manual QA Checklist

### 3.1 Onboarding Flow

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| ONB-001 | Screen 01 | Welcome screen loads with branding | Welcome screen and branding display correctly | Branding missing |  Tested | B001 |
| ONB-002 | Screen 02 | Skin scan prompt is interactive | User can interact with skin scan prompt | User can click picture |  Tested | B002 |
| ONB-003 | Screen 03 | Account sync screen renders | Account sync screen loads correctly | Sync screen redirected to auth/splash | Tested | B003 |
| ONB-004 | Screen 04 | Privacy gate shows consent toggles | Consent toggles display and function correctly | Toggle frontend fine but not able to continue |  Tested | B004 |
| ONB-005 | Screen 05 | Cycle baseline input works | User can enter and save cycle baseline information | TBD | ⬜ Not Tested | B005 |
| ONB-006 | Screen 06 | Wearable connection screen loads | Wearable connection screen loads correctly | TBD | ⬜ Not Tested | B006 |
| ONB-007 | Screen 07 | Aura awakening completion screen | Completion screen displays correctly | TBD | ⬜ Not Tested | B007 |

---

### 3.2 Home & Dashboard

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| HOME-001 | Screen 08 | Home screen loads with greeting | Home screen loads and displays greeting | TBD | ⬜ Not Tested | B008 |
| HOME-002 | Screen 29 | Dormant state | Dormant state renders when no data is available | TBD | ⬜ Not Tested | B009 |
| HOME-003 | Screen 36 | Quiet inbox | Empty quiet inbox state renders correctly | TBD | ⬜ Not Tested | B010 |

---

### 3.3 Daily Check-in

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| CHK-001 | Screen 09 | AM check-in form submits | AM check-in is submitted successfully | TBD | ⬜ Not Tested | B011 |
| CHK-002 | Screen 10 | PM check-in form submits | PM check-in is submitted successfully | TBD | ⬜ Not Tested | B012 |
| CHK-003 | Backend | Check-in data persists | Submitted check-in data is saved and retrieved from backend | TBD | ⬜ Not Tested | B013 |

---

### 3.4 Skin Tracking

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| SKIN-001 | Screen 11 | Skin log entry saves | Skin log is successfully created and saved | TBD | ⬜ Not Tested | B014 |
| SKIN-002 | Screen 12 | Quick log form works | Quick log can be completed successfully | TBD | ⬜ Not Tested | B015 |
| SKIN-003 | Screen 35 | Progress timeline renders entries | Previous skin log entries are displayed correctly | TBD | ⬜ Not Tested | B016 |

---

### 3.5 Shelf & Product Management

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| SHELF-001 | Screen 13 | Shelf shows products with status | Products and their current status display correctly | TBD | ⬜ Not Tested | B017 |
| SHELF-002 | Screen 24 | Depletion confirmation displays | Depletion confirmation is displayed correctly | TBD | ⬜ Not Tested | B018 |
| SHELF-003 | Screen 21 | Optimize shelf recommendations | Shelf optimization recommendations are displayed | TBD | ⬜ Not Tested | B019 |

---

### 3.6 Routine

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| ROUT-001 | Screen 14 | Routine builder loads products | Routine builder loads available products correctly | TBD | ⬜ Not Tested | B020 |
| ROUT-002 | Screen 18 | Intervention log records changes | Routine/intervention changes are recorded correctly | TBD | ⬜ Not Tested | B021 |

---

### 3.7 Insights

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| INS-001 | Screen 15 | Biweekly wrapped renders | Biweekly wrapped screen displays correctly | TBD | ⬜ Not Tested | B022 |
| INS-002 | Screen 16 | Monthly synthesis displays | Monthly synthesis data displays correctly | TBD | ⬜ Not Tested | B023 |
| INS-003 | Screen 17 | Rare Pulse feed loads | Rare Pulse feed loads correctly | TBD | ⬜ Not Tested | B024 |
| INS-004 | Screen 19 | Environmental map shows AQI data | Environmental map and AQI data display correctly | TBD | ⬜ Not Tested | B025 |
| INS-005 | Screen 20 | Precision profile renders metrics | Precision profile metrics display correctly | TBD | ⬜ Not Tested | B026 |

---

### 3.8 Calendar

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| CAL-001 | Screen 28 | Cycle calendar shows phases | Cycle phases are displayed correctly | TBD | ⬜ Not Tested | B027 |
| CAL-001 | Screen 28 | Cycle calendar shows phases | Cycle phases are displayed correctly | TBD | ⬜ Not Tested | B028 |
| CAL-002 | Screen 34 | Data log edit history displays | Previous data log changes are displayed correctly | TBD | ⬜ Not Tested | B029 |

---

### 3.9 Settings & Privacy

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| SET-001 | Screen 25 | Settings menu loads | Settings menu loads correctly | TBD | ⬜ Not Tested | B030 |
| SET-002 | Screen 26 | Privacy dashboard shows consents | Privacy consents and settings display correctly | TBD | ⬜ Not Tested | B031 |
| SET-003 | Screen 27 | Kill switch deactivates account | Account can be deactivated successfully | TBD | ⬜ Not Tested | B032 |
| SET-004 | Screen 38 | Legal documents render | Legal documents load and render correctly | TBD | ⬜ Not Tested | B033 |

---

### 3.10 Commerce & Booking

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| COM-001 | Screen 22 | Plan my relief shows recommendations | Relevant recommendations are displayed | TBD | ⬜ Not Tested | B034 |
| COM-002 | Screen 23 | Booking webview loads | Booking webview loads successfully | TBD | ⬜ Not Tested | B035 |
| COM-003 | Screen 39 | Checkout state processes order | Checkout/order processing works correctly | TBD | ⬜ Not Tested | B036 |
| COM-004 | Screen 31 | Order/booking history displays | Previous orders and bookings are displayed | TBD | ⬜ Not Tested | B037 |

---

### 3.11 Profile & Credits

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| PROF-001 | Screen 33 | Profile hub shows user info | User profile information displays correctly | TBD | ⬜ Not Tested | - |
| PROF-002 | Screen 32 | Credits ledger shows balance and transactions | Credit balance and transaction history display correctly | TBD | ⬜ Not Tested | - |
| PROF-003 | Screen 45 | Account details editable | User can edit and save account details | TBD | ⬜ Not Tested | - |

---

### 3.12 Support & B2B

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| SUP-001 | Screen 40 | Help/support contact form | User can submit support/contact request | TBD | ⬜ Not Tested | - |
| SUP-002 | Screen 41 | Rare rituals content loads | Rare rituals content loads correctly | TBD | ⬜ Not Tested | - |
| SUP-003 | Screen 42 | Practitioner login works | Practitioner can log in successfully | TBD | ⬜ Not Tested | - |
| SUP-004 | Screen 43 | Pre-treatment sync loads | Pre-treatment sync data loads correctly | TBD | ⬜ Not Tested | - |
| SUP-005 | Screen 44 | Post-treatment protocol renders | Post-treatment protocol displays correctly | TBD | ⬜ Not Tested | - |

---

### 3.13 Error & Edge Cases

| Test ID | Screen | Test Scenario | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|
| ERR-001 | Screen 30 | Network failure | Appropriate error/empty state is displayed | TBD | ⬜ Not Tested | - |
| ERR-002 | Screen 37 | Returning user flow | Returning user is taken through the correct splash flow | TBD | ⬜ Not Tested | - |
| ERR-003 | Authentication | Unauthenticated user | Unauthenticated user is redirected to login | TBD | ⬜ Not Tested | - |
| ERR-004 | Authentication | Expired JWT token | Expired token triggers re-authentication | TBD | ⬜ Not Tested | - |

---

## 4. API Endpoint Verification

Swagger UI:

`http://localhost:8000/docs`

| Test ID | Method | Endpoint | Description | Expected Result | Actual Result | Status | Bug ID |
|---|---|---|---|---|---|---|---|
| API-001 | POST | `/api/auth/register` | User registration | User is registered successfully | Error |  Tested | - |
| API-002 | POST | `/api/auth/login` | User login | Login succeeds and JWT is returned | Error | Tested | - |
| API-003 | GET | `/api/users/me` | Current user profile | Current authenticated user is returned | Error | Tested | - |
| API-004 | GET | `/api/products` | Product listing | Available products are returned | Error |  Tested | - |
| API-005 | POST | `/api/checkins` | Create check-in | Check-in is created successfully | Error | Tested | - |
| API-006 | GET | `/api/shelf` | Get shelf items | User shelf items are returned | Error | Tested | - |
| API-007 | GET | `/api/insights` | Get insights | User insights are returned | Error | Tested | - |
| API-008 | GET | `/api/credits` | Get credit balance | Current credit balance is returned | Error | Tested | - |
| API-009 | GET | `/api/notifications` | Get notifications | User notifications are returned | TBD | Tested | - |
| API-010 | POST | `/api/skin-logs` | Create skin log | Skin log is created successfully | Error | Tested | - |

---

## 5. Regression Testing

After any code change or bug fix, the following regression tests will be performed.

### 5.1 Automated Regression

- [ ] Run `pytest -v` in `backend/`
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`

### 5.2 Functional Regression

- [ ] Authentication
- [ ] Onboarding
- [ ] AM/PM Check-ins
- [ ] Skin Logging
- [ ] Skin Timeline
- [ ] Shelf
- [ ] Routine
- [ ] Insights
- [ ] Calendar
- [ ] Settings & Privacy
- [ ] Commerce & Booking
- [ ] Profile & Credits
- [ ] Support & B2B
- [ ] Error Handling

**Regression Status:** 🟡 Pending

---

## 6. Known Limitations

| # | Limitation | Impact | Status |
|---|---|---|---|
| 1 | Skin analysis AI model requires external API keys | Full AI functionality cannot be tested without valid API credentials | Open |
| 2 | Razorpay integration requires sandbox credentials | Payment flow cannot be fully validated without sandbox configuration | Open |
| 3 | SMTP email export requires valid email service credentials | Email-related functionality may not be fully testable | Open |
| 4 | Redis caching is optional | Caching behaviour may differ in the development environment | Informational |
| 5 | Environmental AQI data uses mock/sandbox mode | AQI results may not represent production data | Informational |

---

# 7. Bugs / Issues Found

This section records all issues identified during the V1 QA cycle.

| Bug ID | Section | Screen/Test ID | Description | Severity | Steps to Reproduce | Expected Result | Actual Result | Status |
|---|---|---|---|---|---|---|---|---|
| BUG-001 | TBD | TBD | TBD | Critical/High/Medium/Low | TBD | TBD | TBD | Open |

### Severity Definition

#### Critical

Issues that:

- Cause application crashes
- Cause data loss
- Create security issues
- Completely block a major application flow
- Prevent the application from being used

#### High

Issues where:

- Major functionality does not work
- There is no reasonable workaround
- Important user flows are blocked

#### Medium

Issues where:

- Functionality partially fails
- A workaround exists
- The issue affects normal usage but does not completely block the flow

#### Low

Issues such as:

- Minor UI problems
- Text issues
- Alignment issues
- Spacing issues
- Minor visual inconsistencies
- Non-blocking usability issues

---

## 7.1 Bug Details

### BUG-001

**Section:** TBD

**Screen/Test ID:** TBD

**Description:** TBD

**Severity:** TBD

**Steps to Reproduce:**

1. TBD
2. TBD
3. TBD

**Expected Result:**

TBD

**Actual Result:**

TBD

**Status:** Open

**Screenshot/Evidence:**

TBD

---

# 8. QA Summary

## 8.1 Test Execution Summary

| Metric | Result |
|---|---:|
| Total Test Cases | TBD |
| Passed | TBD |
| Failed | TBD |
| Blocked | TBD |
| Not Tested | TBD |
| Critical Bugs | TBD |
| High Bugs | TBD |
| Medium Bugs | TBD |
| Low Bugs | TBD |

---

## 8.2 Module-wise Summary

| Module | Total | Passed | Failed | Blocked | Not Tested | Status |
|---|---:|---:|---:|---:|---:|---|
| Onboarding | 7 | TBD | TBD | TBD | TBD | 🟡 |
| Home & Dashboard | 3 | TBD | TBD | TBD | TBD | 🟡 |
| Daily Check-in | 3 | TBD | TBD | TBD | TBD | 🟡 |
| Skin Tracking | 3 | TBD | TBD | TBD | TBD | 🟡 |
| Shelf & Product Management | 3 | TBD | TBD | TBD | TBD | 🟡 |
| Routine | 2 | TBD | TBD | TBD | TBD | 🟡 |
| Insights | 5 | TBD | TBD | TBD | TBD | 🟡 |
| Calendar | 2 | TBD | TBD | TBD | TBD | 🟡 |
| Settings & Privacy | 4 | TBD | TBD | TBD | TBD | 🟡 |
| Commerce & Booking | 4 | TBD | TBD | TBD | TBD | 🟡 |
| Profile & Credits | 3 | TBD | TBD | TBD | TBD | 🟡 |
| Support & B2B | 5 | TBD | TBD | TBD | TBD | 🟡 |
| Error & Edge Cases | 4 | TBD | TBD | TBD | TBD | 🟡 |

---

## 8.3 Final QA Status

**Current Status:** 🟡 Testing In Progress

### Release Recommendation

- [ ] ✅ Approved for Release
- [ ] ⚠️ Approved with Known Issues
- [ ] ❌ Not Approved for Release
- [ ] 🟡 Testing In Progress

### QA Notes

TBD

---

# 9. QA History

| Version | Date | Tester | Branch | Summary |
|---|---|---|---|---|
| V1 | September 2026 | Sara | `Razeen_Backend` | Initial QA cycle |
| V1.1 | TBD | TBD | TBD | Regression testing after bug fixes |
| V2 | TBD | TBD | TBD | Next QA cycle |