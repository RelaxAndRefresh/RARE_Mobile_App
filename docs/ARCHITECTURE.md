# System Architecture — RARE Mobile Application

> Complete technical architecture documentation covering system design, authentication, authorization, data ownership, error handling, caching, and external integrations.

---

## 1. System Overview

RARE is a personalized wellness and skincare platform built with a Flutter mobile frontend and a FastAPI Python backend. The system follows a layered architecture with clear separation of concerns.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER MOBILE APP                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │  Screens  │  │ Providers│  │Repositories│  │  Network Layer   │ │
│  │  (UI)     │→ │ (State)  │→ │ (Data)    │→ │ (ApiClient/Dio)  │ │
│  └──────────┘  └──────────┘  └──────────┘  └────────┬─────────┘ │
└──────────────────────────────────────────────────────┼───────────┘
                                                       │
                                                       │ HTTP/REST
                                                       │ JWT Bearer
                                                       ▼
┌──────────────────────────────────────────────────────────────────┐
│                      FASTAPI BACKEND (API)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │  Routers  │→ │ Services │→ │  Models   │→ │   Database       │ │
│  │ (Endpoints)│  │ (Logic)  │  │ (ORM)    │  │  (PostgreSQL)    │ │
│  └──────────┘  └──────────┘  └──────────┘  └──────────────────┘ │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                       │
│  │ Schemas  │  │ Security │  │Config    │                       │
│  │ (Validation)│ │ (JWT)   │  │(.env)    │                       │
│  └──────────┘  └──────────┘  └──────────┘                       │
└──────────────────────────────────────────────────────────────────┘
         │              │              │
         ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   Razorpay   │ │  AQI/UV API  │ │  SMTP Email  │
│  (Payments)  │ │(Environmental)│ │  (Export)    │
└──────────────┘ └──────────────┘ └──────────────┘
```

---

## 2. Flutter Mobile App Architecture

### Layered Architecture

```
lib/
├── main.dart                    # Entry point, ProviderScope
├── app.dart                     # MaterialApp, theme, router
├── core/
│   ├── constants/               # App colors, strings, design tokens
│   ├── network/
│   │   ├── api_client.dart      # Dio HTTP client with interceptors
│   │   ├── api_config.dart      # Base URL, timeout, headers
│   │   ├── api_exception.dart   # Custom exception hierarchy
│   │   └── auth_interceptor.dart # Token injection & refresh
│   ├── routes/
│   │   ├── route_names.dart     # Route path constants
│   │   └── app_routes.dart      # GoRouter configuration
│   ├── theme/                   # Typography, colors, design system
│   └── utils/                   # Helpers, formatters
├── data/
│   ├── models/
│   │   └── api_models.dart      # All data models (fromJson/toJson)
│   └── repositories/
│       ├── auth_repository.dart
│       ├── onboarding_repository.dart
│       ├── checkin_repository.dart
│       ├── skin_repository.dart
│       ├── shelf_repository.dart
│       ├── routine_repository.dart
│       ├── insight_repository.dart
│       ├── commerce_repository.dart
│       ├── booking_repository.dart
│       ├── order_repository.dart
│       ├── credits_repository.dart
│       ├── privacy_repository.dart
│       ├── notification_repository.dart
│       ├── support_repository.dart
│       ├── profile_repository.dart
│       ├── environmental_repository.dart
│       ├── legal_repository.dart
│       ├── practitioner_repository.dart
│       └── rituals_repository.dart
├── providers/                   # Riverpod StateNotifierProviders
│   ├── auth_provider.dart
│   ├── onboarding_provider.dart
│   ├── checkin_provider.dart
│   ├── skin_provider.dart
│   ├── shelf_provider.dart
│   ├── routine_provider.dart
│   ├── insight_provider.dart
│   ├── commerce_provider.dart
│   ├── booking_provider.dart
│   ├── credits_provider.dart
│   ├── privacy_provider.dart
│   ├── notification_provider.dart
│   ├── support_provider.dart
│   ├── profile_provider.dart
│   ├── environmental_provider.dart
│   ├── legal_provider.dart
│   ├── practitioner_provider.dart
│   └── rituals_provider.dart
├── screens/                     # 45 screens across 18 categories
│   ├── splash/
│   ├── onboarding/
│   ├── home/
│   ├── checkin/
│   ├── skin/
│   ├── shelf/
│   ├── routine/
│   ├── insights/
│   ├── booking/
│   ├── settings/
│   ├── calendar/
│   ├── profile/
│   ├── orders/
│   ├── support/
│   ├── legal/
│   ├── rituals/
│   ├── b2b/
│   └── error/
└── widgets/                     # Shared reusable widgets
```

### Data Flow

```
User Action → Screen (StatefulWidget)
    → Provider (StateNotifier)
        → Repository (API call via ApiClient)
            → Dio HTTP Client (with AuthInterceptor)
                → FastAPI Backend
                    → Service Layer
                        → SQLAlchemy ORM
                            → PostgreSQL Database
```

### State Management (Riverpod)

- **Provider**: Injectable dependencies (repositories, API client)
- **StateNotifierProvider**: Mutable state with state classes
- **Provider<User?>**: Derived state (current user, auth status)

```
authProvider (StateNotifierProvider<AuthNotifier, AuthState>)
    ├── authRepositoryProvider (Provider<AuthRepository>)
    │   └── apiClient (Provider<ApiClient>)
    └── currentUserProvider (Provider<User?>)
        └── isAuthenticatedProvider (Provider<bool>)
```

---

## 3. Backend Architecture

### FastAPI Application Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py                  # FastAPI app, middleware, router registration
│   ├── core/
│   │   ├── config.py            # Pydantic Settings (.env loading)
│   │   ├── dependencies.py      # FastAPI dependencies (get_db, get_current_user)
│   │   ├── exceptions.py        # Custom exception classes + handlers
│   │   └── security.py          # JWT creation/verification, password hashing
│   ├── db/
│   │   ├── database.py          # SQLAlchemy engine, session, Base
│   │   ├── base.py              # Re-exports Base
│   │   └── models/
│   │       └── __init__.py      # All 34 SQLAlchemy models
│   ├── routers/                 # 22 API routers
│   │   ├── auth.py              # /auth/*
│   │   ├── users.py             # /users/*
│   │   ├── onboarding.py        # /onboarding/*
│   │   ├── checkins.py          # /checkins/*
│   │   ├── skin.py              # /skin/*
│   │   ├── cycle.py             # /cycle/*
│   │   ├── wearable.py          # /wearable/*
│   │   ├── shelf.py             # /shelf/*
│   │   ├── routine.py           # /routine/*
│   │   ├── insights.py          # /insights/*
│   │   ├── environmental.py     # /environmental/*
│   │   ├── inbox.py             # /inbox/*
│   │   ├── rituals.py           # /rituals/*
│   │   ├── products.py          # /products/*
│   │   ├── commerce.py          # /commerce/*
│   │   ├── bookings.py          # /bookings/*
│   │   ├── orders.py            # /orders/*
│   │   ├── credits.py           # /credits/*
│   │   ├── privacy.py           # /privacy/*
│   │   ├── support.py           # /support/*
│   │   ├── practitioner.py      # /practitioner/*
│   │   └── admin.py             # /admin/*
│   ├── schemas/                 # Pydantic request/response models
│   │   ├── auth.py
│   │   ├── user.py
│   │   ├── onboarding.py
│   │   ├── checkin.py
│   │   ├── skin.py
│   │   ├── shelf.py
│   │   ├── routine.py
│   │   ├── insights.py
│   │   ├── commerce.py
│   │   ├── booking.py
│   │   ├── credits.py
│   │   ├── privacy.py
│   │   ├── notifications.py
│   │   ├── support.py
│   │   └── practitioner.py
│   └── services/                # Business logic layer
│       ├── auth_service.py
│       ├── onboarding_service.py
│       ├── skin_service.py
│       ├── shelf_service.py
│       ├── routine_service.py
│       ├── insight_service.py
│       ├── commerce_service.py
│       ├── order_service.py
│       ├── booking_service.py
│       ├── notification_service.py
│       ├── privacy_service.py
│       └── practitioner_service.py
├── alembic/                     # Database migrations
├── alembic.ini
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── seed.py                      # Database seeding
```

### Request Lifecycle

```
1. HTTP Request → FastAPI Router
2. Router validates request body (Pydantic Schema)
3. Router calls Service function
4. Service executes business logic
5. Service calls SQLAlchemy ORM (DB query)
6. Service returns result to Router
7. Router serializes response (Pydantic Schema)
8. HTTP Response → Client
```

---

## 4. Authentication Flow

### JWT Token Authentication

```
┌─────────┐                    ┌─────────┐                    ┌─────────┐
│  Client  │                    │  API    │                    │   DB    │
└────┬────┘                    └────┬────┘                    └────┬────┘
     │  POST /auth/signup           │                             │
     │  {email, name, password}     │                             │
     │─────────────────────────────>│                             │
     │                              │  Hash password (bcrypt)     │
     │                              │────────────────────────────>│
     │                              │  INSERT INTO users          │
     │                              │  INSERT INTO onboarding     │
     │                              │  INSERT INTO credit_balance │
     │                              │<────────────────────────────│
     │                              │                             │
     │                              │  Create access_token (JWT)  │
     │                              │  Create refresh_token (JWT) │
     │                              │  Store refresh_token in DB  │
     │                              │────────────────────────────>│
     │  {access_token, refresh_     │                             │
     │   token, user}               │                             │
     │<─────────────────────────────│                             │
     │                              │                             │
     │  GET /api/v1/resource        │                             │
     │  Authorization: Bearer <at>  │                             │
     │─────────────────────────────>│                             │
     │                              │  Decode JWT, verify expiry  │
     │                              │  Extract user_id from sub   │
     │                              │  Query user from DB         │
     │                              │────────────────────────────>│
     │                              │  Return user                │
     │                              │<────────────────────────────│
     │  200 OK + data               │                             │
     │<─────────────────────────────│                             │
```

### Token Details

| Token | Algorithm | Expiry | Purpose |
|---|---|---|---|
| Access Token | HS256 | 30 minutes | API authorization |
| Refresh Token | HS256 | 7 days | Token renewal |

### Token Refresh Flow

```
1. Client sends request with expired access token
2. Backend returns 401 Unauthorized
3. Client sends POST /auth/refresh with refresh_token
4. Backend validates refresh_token:
   a. Decode JWT and verify type = "refresh"
   b. Check token exists in DB and not revoked
   c. Check token not expired
5. Revoke old refresh_token
6. Create new access_token + refresh_token
7. Store new refresh_token in DB
8. Return new tokens to client
9. Client retries original request with new access_token
```

### Anonymous User Flow

```
1. User taps "Skip for now — start anonymously"
2. Client sends POST /auth/signup with {email: null, password: null}
3. Backend creates user with:
   - is_anonymous = true
   - password_hash = bcrypt("anonymous临时密码")
4. Tokens returned same as authenticated flow
5. User can upgrade to OAuth account later via Profile Hub
```

### AuthInterceptor (Flutter)

```dart
class AuthInterceptor extends Interceptor {
  // 1. Inject access token from secure storage into every request
  // 2. On 401 response:
  //    a. Read refresh_token from secure storage
  //    b. POST /auth/refresh
  //    c. Store new tokens
  //    d. Retry original request with new access_token
  // 3. On refresh failure: clear tokens, redirect to login
}
```

---

## 5. Authorization Flow

### Role-Based Access Control

| Role | Permissions | Access Level |
|---|---|---|
| `user` | Own data only, all user features | Standard user |
| `practitioner` | Client summaries, treatment sessions | B2B portal |
| `admin` | Admin dashboard, user management | Full access |
| `partner` | (Reserved) | TBD |

### Authorization Middleware

```python
# dependencies.py

async def get_current_user(credentials) -> User:
    # 1. Extract token from Authorization header
    # 2. Decode JWT, verify type = "access"
    # 3. Extract user_id from payload["sub"]
    # 4. Query user from DB
    # 5. Return user or raise AuthenticationError

async def get_current_active_user(current_user) -> User:
    # 1. Check user.is_active == True
    # 2. Return user or raise AuthorizationError

def require_role(*roles):
    # Factory function returning role checker dependency
    # Checks current_user.role in allowed roles
```

### Endpoint Authorization Matrix

| Endpoint | Auth Required | Roles Allowed |
|---|---|---|
| POST /auth/signup | No | - |
| POST /auth/login | No | - |
| POST /auth/refresh | No | - |
| GET /auth/me | Yes | user, practitioner, admin |
| GET /users/profile | Yes | user |
| PUT /users/profile | Yes | user |
| PUT /users/account-details | Yes | user |
| GET /admin/dashboard | Yes | admin |
| GET /admin/users | Yes | admin |
| GET /practitioner/clients/* | Yes | practitioner |
| POST /practitioner/sessions | Yes | practitioner |
| GET /practitioner/sessions/*/protocol | Yes | practitioner |
| All other endpoints | Yes | user |

### Data Ownership Enforcement

Every user-scoped endpoint enforces data ownership:

```python
# Example from checkins router
@router.post("/am")
def create_am_checkin(data, db, current_user):
    checkin = DailyCheckin(user_id=current_user.id, ...)
    # user_id always set from authenticated user, never from request body

@router.get("/today")
def get_today_checkins(db, current_user):
    checkins = db.query(DailyCheckin).filter(
        DailyCheckin.user_id == current_user.id  # Always filter by owner
    ).all()
```

---

## 6. Data Ownership Model

### Principle

Every piece of user data is owned by a single user. No cross-user data access is permitted except by practitioners with explicit client relationships.

### Ownership Chain

```
User (users.id)
├── user_profiles (user_id → users.id)
├── onboarding_progress (user_id → users.id)
├── privacy_consents (user_id → users.id)
├── soft_scans (user_id → users.id)
├── daily_checkins (user_id → users.id)
├── hydration_logs (user_id → users.id)
├── skin_logs (user_id → users.id)
├── skin_photos (user_id → users.id)
├── cycle_events (user_id → users.id)
├── wearable_syncs (user_id → users.id)
├── shelf_items (user_id → users.id)
├── routines (user_id → users.id)
├── routine_interventions (user_id → users.id)
├── insights (user_id → users.id)
├── environmental_data (user_id → users.id) [nullable]
├── carts (user_id → users.id) [1:1]
├── orders (user_id → users.id)
├── payments (user_id → users.id)
├── credit_balances (user_id → users.id) [1:1]
├── credit_transactions (user_id → users.id)
├── notifications (user_id → users.id)
├── support_tickets (user_id → users.id)
├── privacy_audit_logs (user_id → users.id)
├── practitioner_clients (practitioner_id/client_id → users.id)
└── treatment_sessions (practitioner_id/client_id → users.id)
```

### Cascade Deletion

When a user is deleted, all associated data is cascade-deleted:

```sql
-- ON DELETE CASCADE for user-scoped tables
ALTER TABLE user_profiles DROP CONSTRAINT ... CASCADE;
ALTER TABLE refresh_tokens DROP CONSTRAINT ... CASCADE;
-- ... (all user-scoped tables)
```

### Practitioner Access Model

Practitioners can only access clients with explicit relationships:

```
1. Client books appointment → PractitionerClient record created
2. Practitioner views client summary → Verified via PractitionerClient link
3. Practitioner creates treatment session → Linked to client
4. Session completes → Practitioner data wiped from tablet
```

---

## 7. Error Handling Strategy

### Backend Exception Hierarchy

```python
class RAREException(Exception):
    # Base exception with message and status_code
    pass

class AuthenticationError(RAREException):  # 401
class AuthorizationError(RAREException):   # 403
class NotFoundError(RAREException):        # 404
class ValidationError(RAREException):      # 422
class ConflictError(RAREException):        # 409
```

### Error Response Format

```json
{
    "detail": "Error message describing the problem"
}
```

### Global Exception Handler

```python
# All RAREException subclasses are caught by a single handler
exception_handlers = {
    RAREException: rare_exception_handler,
}

async def rare_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message},
    )
```

### Frontend Error Handling (ApiClient)

```dart
class ApiException {
    int? statusCode;
    String message;
    dynamic errors;
}

class NetworkException extends ApiException { ... }
class AuthException extends ApiException { ... }
class ForbiddenException extends ApiException { ... }
class NotFoundException extends ApiException { ... }
class ValidationException extends ApiException {
    Map<String, dynamic>? fieldErrors;
}
class ServerException extends ApiException { ... }
```

### Error Mapping

| HTTP Status | Exception | Frontend Handling |
|---|---|---|
| 400 | BadRequestError | Show validation errors |
| 401 | AuthException | Redirect to login |
| 403 | ForbiddenException | Show permission error |
| 404 | NotFoundException | Show not found message |
| 422 | ValidationException | Show field-level errors |
| 500-503 | ServerException | Show retry option |
| Timeout | NetworkException | Show network error |

### UI Error States

The `ErrorEmptyScreen` provides branded error states:

- **Network Error:** "Something feels off"
- **Environmental Data Failure:** Graceful fallback
- **Empty States:** "We are listening" / "Early days"
- **No Data:** "Early credits" / "No interventions"

---

## 8. Caching Strategy

### Client-Side Caching

| Data | Storage | TTL | Strategy |
|---|---|---|---|
| Access Token | FlutterSecureStorage | 30 min | Auto-refresh via interceptor |
| Refresh Token | FlutterSecureStorage | 7 days | Rotate on use |
| User Profile | Memory (Provider) | Session | Re-fetch on app launch |
| Onboarding Progress | Memory (Provider) | Session | Re-fetch on app launch |
| Consents | Memory (Provider) | Session | Re-fetch on app launch |
| Skin Logs | API (no local cache) | - | Fetch on demand |
| Insights | API (no local cache) | - | Fetch on demand |
| Products | API (no local cache) | - | Fetch on demand |

### Server-Side Caching

| Data | Strategy | TTL |
|---|---|---|
| Environmental Data | DB cache with `cached_until` | Configurable per record |
| Product Catalog | Direct DB query | No cache (real-time stock) |
| Insights | Direct DB query | Pre-computed, stored in DB |
| Bookings | Direct DB query | No cache |

### Cache Invalidation

- **Token rotation:** Old refresh_token revoked on use
- **Consent updates:** Immediately persisted to DB
- **Profile updates:** Immediately persisted to DB
- **Order status:** Real-time from DB

### Future Caching Considerations

1. **Skin logs:** Could benefit from local SQLite cache for offline-first
2. **Insights:** Could pre-compute and cache aggressively
3. **Products:** Could use Redis for high-traffic catalog
4. **Environmental data:** Already has `cached_until` field for API response caching

---

## 9. External Integrations Overview

### Razorpay (Payment Gateway)

| Aspect | Detail |
|---|---|
| **Purpose** | Payment processing for orders and bookings |
| **Integration** | HMAC-SHA256 signature verification |
| **Config** | RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET |
| **Flow** | Checkout → Create Razorpay order → Client payment → Verify signature |
| **Status** | Implemented in commerce_service.py |

### AQI/UV Environmental API

| Aspect | Detail |
|---|---|
| **Purpose** | Air quality, UV index, humidity data by pincode |
| **Integration** | External API (WAQI, IQAir, or similar) |
| **Config** | AQI_API_KEY |
| **Flow** | Fetch by pincode → Store in environmental_data → Cache with cached_until |
| **Status** | Partially implemented (DB model exists, API integration stubbed) |

### SMTP Email Service

| Aspect | Detail |
|---|---|
| **Purpose** | Data export, booking confirmations, password resets |
| **Integration** | SMTP (SendGrid, AWS SES, or similar) |
| **Config** | SMTP_HOST, SMTP_PORT, SMTP_USER, SMTP_PASSWORD |
| **Flow** | Request export → Generate data → Send email |
| **Status** | Configured but not fully implemented |

### Apple Health / Google Fit (Wearable)

| Aspect | Detail |
|---|---|
| **Purpose** | Sleep, heart rate, activity data import |
| **Integration** | health package (Apple Health), fit_kit (Google Fit) |
| **Config** | User-controlled via Privacy Dashboard |
| **Flow** | Connect → Sync data → Store in wearable_syncs |
| **Status** | Backend endpoints implemented, Flutter packages not yet added |

### Camera / Image Picker

| Aspect | Detail |
|---|---|
| **Purpose** | Skin photo capture for progress timeline |
| **Integration** | image_picker / camera packages |
| **Config** | Camera permission required |
| **Flow** | Capture → Upload to storage → Store key in skin_photos |
| **Status** | Backend endpoint exists, Flutter packages not yet added |

### Push Notifications (Firebase)

| Aspect | Detail |
|---|---|
| **Purpose** | AM/PM check-in reminders, insight nudges |
| **Integration** | firebase_messaging, flutter_local_notifications |
| **Config** | Firebase project setup |
| **Flow** | Token registration → Send via Firebase → Display in Quiet Inbox |
| **Status** | Settings toggles exist, Firebase not yet configured |

---

## 10. Security Considerations

### Password Security

- **Hashing:** bcrypt via passlib
- **No plaintext storage:** Only hashes stored in users.password_hash
- **Anonymous fallback:** Temporary password for anonymous users

### JWT Security

- **Algorithm:** HS256 (HMAC-SHA256)
- **Secret:** Configurable via JWT_SECRET env var
- **Expiry:** Access (30 min), Refresh (7 days)
- **Rotation:** Refresh tokens rotated on use
- **Revocation:** Old tokens marked as revoked in DB

### API Security

- **CORS:** Configurable origins (currently allow all for development)
- **Rate limiting:** Not implemented (recommended for production)
- **Input validation:** Pydantic schemas validate all inputs
- **SQL injection:** SQLAlchemy ORM prevents SQL injection
- **XSS:** Not applicable (API-only, no HTML rendering)

### Data Security

- **Transport:** HTTPS required in production
- **Storage:** Sensitive data encrypted at rest (PostgreSQL)
- **Photos:** Soft-delete with "never trained on" guarantee
- **Practitioner data:** Wiped from tablet on session completion
- **Audit trail:** All privacy actions logged immutably

### Payment Security

- **Razorpay:** PCI-compliant payment processing
- **Signature verification:** HMAC-SHA256 on server side
- **No card storage:** Card details never touch our servers

---

## 11. Deployment Architecture

### Docker Setup

```yaml
# docker-compose.yml
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/rare_db
      - JWT_SECRET=...
    depends_on:
      - db

  db:
    image: postgres:16
    environment:
      - POSTGRES_DB=rare_db
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

### Environment Variables

| Variable | Purpose | Default |
|---|---|---|
| DATABASE_URL | PostgreSQL connection string | postgresql://postgres:postgres@localhost:5432/rare_db |
| JWT_SECRET | JWT signing secret | your-super-secret-key-change-in-production |
| JWT_ALGORITHM | JWT algorithm | HS256 |
| JWT_ACCESS_EXPIRE_MINUTES | Access token expiry | 30 |
| JWT_REFRESH_EXPIRE_DAYS | Refresh token expiry | 7 |
| STORAGE_TYPE | File storage type | local |
| LOCAL_STORAGE_PATH | Local upload path | ./uploads |
| RAZORPAY_KEY_ID | Razorpay API key | None |
| RAZORPAY_KEY_SECRET | Razorpay secret | None |
| SMTP_HOST | SMTP server | None |
| SMTP_PORT | SMTP port | 587 |
| SMTP_USER | SMTP username | None |
| SMTP_PASSWORD | SMTP password | None |
| AQI_API_KEY | Environmental data API key | None |
| SKIN_ANALYSIS_MODE | Skin analysis mode | development |

### API Configuration (Flutter)

```dart
class ApiConfig {
    static const String baseUrl = 'http://localhost:8000/api/v1';
    static const Duration timeout = Duration(seconds: 30);
    static const int maxRetries = 3;
    static const Map<String, String> defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
    };
}
```

---

## 12. Database Migrations

### Alembic Setup

```
backend/
├── alembic.ini          # Alembic configuration
├── alembic/
│   ├── env.py           # Migration environment
│   └── versions/        # Migration files
└── app/db/models/       # SQLAlchemy models (source of truth)
```

### Migration Workflow

```bash
# Generate migration from model changes
alembic revision --autogenerate -m "description"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1
```

### Startup Migration

```python
# main.py
@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)  # Auto-create tables
```

---

## 13. Testing Strategy

### Backend Testing

- **Unit tests:** Service functions, utility functions
- **Integration tests:** API endpoints with test DB
- **Load tests:** Concurrent user scenarios

### Frontend Testing

- **Unit tests:** Providers, repositories, models
- **Widget tests:** Individual screen components
- **Integration tests:** Critical user flows (onboarding, check-in, payment)

### Test Commands

```bash
# Backend
pytest tests/
pytest tests/ --cov=app

# Frontend
flutter test
flutter test --coverage
```

---

## 14. Monitoring & Observability

### Health Check

```python
@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "RARE API", "version": "1.0.0"}
```

### Logging

- **Backend:** FastAPI request logging, SQLAlchemy query logging
- **Frontend:** Dio LogInterceptor for API calls

### Metrics (Recommended)

- Request latency
- Error rates
- Active users
- Database connection pool
- Payment success rates

---

## 15. Future Architecture Considerations

### Offline-First

- Add SQLite/Hive for local data persistence
- Implement sync queue for offline actions
- Conflict resolution strategy for concurrent edits

### Microservices

- Extract payment service (Razorpay)
- Extract notification service (Firebase)
- Extract image processing service (skin analysis)

### Real-Time Features

- WebSocket for live notifications
- Real-time booking updates
- Live practitioner session sync

### Scalability

- Redis for session caching
- CDN for static assets (product images)
- Read replicas for reporting queries
- Background job queue for insight generation
