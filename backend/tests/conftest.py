import asyncio
import pytest
import pytest_asyncio
from datetime import timedelta
from httpx import AsyncClient, ASGITransport
from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker

from app.db.base import Base
from app.db.database import get_db
from app.core.dependencies import get_db_session
from app.main import app
from app.core.security import get_password_hash, create_access_token
from app.db.models import User, UserRole, CreditBalance

TEST_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})

TestSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


async def override_get_db_session():
    db = TestSessionLocal()
    try:
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db_session] = override_get_db_session


@pytest.fixture(scope="session")
def event_loop():
    loop = asyncio.new_event_loop()
    yield loop
    loop.close()


@pytest.fixture(autouse=True)
def setup_database():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)


@pytest.fixture
def db():
    session = TestSessionLocal()
    try:
        yield session
    finally:
        session.close()


@pytest_asyncio.fixture
async def client():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac


@pytest.fixture
def test_user(db):
    user = User(
        email="test@example.com",
        name="Test User",
        password_hash=get_password_hash("TestPass123!"),
        role=UserRole.user,
        is_active=True,
        is_anonymous=False,
    )
    db.add(user)
    db.flush()
    credit = CreditBalance(user_id=user.id, balance=0)
    db.add(credit)
    db.commit()
    db.refresh(user)
    return user


@pytest.fixture
def test_practitioner(db):
    user = User(
        email="practitioner@example.com",
        name="Dr. Test",
        password_hash=get_password_hash("PractPass123!"),
        role=UserRole.practitioner,
        is_active=True,
        is_anonymous=False,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@pytest.fixture
def test_admin(db):
    user = User(
        email="admin@example.com",
        name="Admin User",
        password_hash=get_password_hash("AdminPass123!"),
        role=UserRole.admin,
        is_active=True,
        is_anonymous=False,
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@pytest.fixture
def auth_headers(test_user):
    token = create_access_token(
        data={"sub": str(test_user.id), "role": test_user.role.value},
        expires_delta=timedelta(minutes=30),
    )
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def practitioner_headers(test_practitioner):
    token = create_access_token(
        data={"sub": str(test_practitioner.id), "role": test_practitioner.role.value},
        expires_delta=timedelta(minutes=30),
    )
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def admin_headers(test_admin):
    token = create_access_token(
        data={"sub": str(test_admin.id), "role": test_admin.role.value},
        expires_delta=timedelta(minutes=30),
    )
    return {"Authorization": f"Bearer {token}"}
