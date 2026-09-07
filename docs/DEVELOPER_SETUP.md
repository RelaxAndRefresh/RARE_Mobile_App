# Developer Setup Guide — RARE Mobile Application

This guide walks you through setting up the RARE project from scratch.

---

## 1. Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | >= 3.12.2 | Mobile app |
| Dart SDK | >= 3.12.2 | Language runtime |
| Python | >= 3.10 | Backend API |
| PostgreSQL | >= 14 | Primary database |
| Redis | >= 7 | Caching (optional for local dev) |
| Android Studio / Xcode | Latest | Platform builds |

---

## 2. Clone & Checkout

```bash
git clone https://github.com/RelaxAndRefresh/RARE_Mobile_App.git
cd RARE_Mobile_App
git checkout Razeen_Backend
```

---

## 3. Flutter App Setup

### 3.1 Install Dependencies

```bash
flutter pub get
```

### 3.2 Configure API URL

Edit the file `lib/core/network/api_config.dart` and set the base URL to point at your running backend:

```dart
static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
// static const String baseUrl = 'http://localhost:8000'; // iOS simulator
```

### 3.3 Run the App

```bash
flutter run
```

### 3.4 Analyze

```bash
flutter analyze
```

---

## 4. Backend Setup

### 4.1 Navigate to Backend

```bash
cd backend
```

### 4.2 Create Virtual Environment

```bash
python -m venv venv
# Windows
venv\Scripts\activate
# macOS / Linux
source venv/bin/activate
```

### 4.3 Install Dependencies

```bash
pip install -r requirements.txt
```

### 4.4 Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and set your database URL, JWT secret, and other values:

```
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/rare_db
JWT_SECRET=your-super-secret-key-change-in-production
JWT_ALGORITHM=HS256
JWT_ACCESS_EXPIRE_MINUTES=30
JWT_REFRESH_EXPIRE_DAYS=7
STORAGE_TYPE=local
LOCAL_STORAGE_PATH=./uploads
SKIN_ANALYSIS_MODE=development
```

### 4.5 Start PostgreSQL

**Option A — Docker Compose (recommended):**

```bash
docker-compose up -d db redis
```

**Option B — Local PostgreSQL:**

Ensure PostgreSQL is running on port 5432 with a database named `rare_db`.

### 4.6 Run Migrations
[Before performing this step, make sure you have rare_db database created in local postgres and update the DATABASE_URL in env example: postgresql://<username>@localhost:5432/rare_db]
```bash
alembic upgrade head
```

Or create tables directly (dev only):

```bash
python setup_db.py
```

### 4.7 Seed the Database

```bash
python seed.py
```

This creates test users, products, routines, check-ins, insights, and more.

**Test accounts:**

| Email | Password | Role |
|-------|----------|------|
| test@rare.com | password123 | User |
| practitioner@rare.com | password123 | Practitioner |
| admin@rare.com | password123 | Admin |

### 4.8 Start the API Server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API docs are available at: `http://localhost:8000/docs`

---

## 5. Run Tests

### 5.1 Backend Tests

```bash
cd backend
pytest -v
```

### 5.2 Flutter Tests

```bash
flutter test
```

---

## 6. Project Structure

```
RARE_Mobile_App/
├── android/                  # Android platform files
├── ios/                      # iOS platform files
├── lib/                      # Flutter application source
│   ├── app.dart              # App widget
│   ├── main.dart             # Entry point
│   ├── core/                 # Constants, routes, theme, network
│   │   ├── constants/        # App-wide constants
│   │   ├── network/          # API client, config, auth interceptor
│   │   ├── routes/           # GoRouter configuration
│   │   └── theme/            # Theme and text styles
│   ├── data/                 # Data layer
│   │   ├── models/           # Data models
│   │   └── repositories/     # Repository pattern implementations
│   ├── providers/            # Riverpod state providers
│   ├── screens/              # UI screens organized by feature
│   └── widgets/              # Reusable widgets
├── backend/                  # FastAPI backend
│   ├── app/
│   │   ├── core/             # Config, security, dependencies
│   │   ├── db/               # Database models, session, base
│   │   ├── routers/          # API route handlers
│   │   ├── schemas/          # Pydantic schemas
│   │   └── services/         # Business logic
│   ├── alembic/              # Database migrations
│   ├── tests/                # Pytest test suite
│   ├── .env.example          # Environment template
│   ├── alembic.ini           # Alembic config
│   ├── docker-compose.yml    # Docker services
│   ├── requirements.txt      # Python dependencies
│   ├── seed.py               # Database seeder
│   └── setup_db.py           # Direct table creation
├── docs/                     # Project documentation
├── linux/                    # Linux platform files
├── macos/                    # macOS platform files
├── web/                      # Web platform files
└── windows/                  # Windows platform files
```

---

## 7. Troubleshooting

**"relation already exists" when running migrations:**
Run `alembic stamp head` to mark the current state, then `alembic upgrade head`.

**Flutter build fails with SDK version errors:**
Run `flutter upgrade` to update to the latest stable channel.

**Backend cannot connect to database:**
Verify PostgreSQL is running and the `DATABASE_URL` in `.env` is correct.

**JWT authentication errors:**
Ensure `JWT_SECRET` is set in `.env` and matches across all environments.
