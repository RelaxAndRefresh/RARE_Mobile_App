from datetime import datetime, timedelta, timezone
from sqlalchemy.orm import Session

from app.core.exceptions import AuthenticationError, ConflictError, NotFoundError
from app.core.security import (
    get_password_hash,
    verify_password,
    create_access_token,
    create_refresh_token,
    decode_token,
)
from app.db.models import User, RefreshToken, OnboardingProgress, CreditBalance


def signup(db: Session, email: str = None, name: str = None, password: str = None) -> dict:
    if email:
        existing = db.query(User).filter(User.email == email).first()
        if existing:
            raise ConflictError("Email already registered")

    user = User(
        email=email,
        name=name,
        password_hash=get_password_hash(password) if password else get_password_hash("anonymous-dev-password"),
        is_anonymous=not password,
    )
    db.add(user)
    db.flush()

    onboarding = OnboardingProgress(user_id=user.id)
    db.add(onboarding)

    credit = CreditBalance(user_id=user.id, balance=0)
    db.add(credit)

    db.commit()
    db.refresh(user)

    return _create_tokens(db, user)


def login(db: Session, email: str, password: str) -> dict:
    user = db.query(User).filter(User.email == email).first()
    if not user or not verify_password(password, user.password_hash):
        raise AuthenticationError("Invalid email or password")
    if not user.is_active:
        raise AuthenticationError("Account is deactivated")
    return _create_tokens(db, user)


def refresh_token(db: Session, refresh_token_str: str) -> dict:
    payload = decode_token(refresh_token_str)
    if not payload or payload.get("type") != "refresh":
        raise AuthenticationError("Invalid refresh token")

    token_record = db.query(RefreshToken).filter(
        RefreshToken.token == refresh_token_str,
        RefreshToken.revoked == False,
    ).first()
    if not token_record:
        raise AuthenticationError("Refresh token not found or revoked")
    expires_at = token_record.expires_at
    if expires_at.tzinfo is None:
        expires_at = expires_at.replace(tzinfo=timezone.utc)
    if expires_at < datetime.now(timezone.utc):
        raise AuthenticationError("Refresh token expired")

    user = db.query(User).filter(User.id == int(payload["sub"])).first()
    if not user:
        raise NotFoundError("User not found")

    token_record.revoked = True
    db.commit()

    return _create_tokens(db, user)


def logout(db: Session, refresh_token_str: str) -> None:
    token_record = db.query(RefreshToken).filter(
        RefreshToken.token == refresh_token_str,
    ).first()
    if token_record:
        token_record.revoked = True
        db.commit()


def get_current_user_info(db: Session, user_id: int) -> User:
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise NotFoundError("User not found")
    return user


def _create_tokens(db: Session, user: User) -> dict:
    access_token = create_access_token(data={"sub": str(user.id), "role": user.role})
    refresh_token_str = create_refresh_token(data={"sub": str(user.id), "role": user.role})

    db_refresh = RefreshToken(
        user_id=user.id,
        token=refresh_token_str,
        expires_at=datetime.now(timezone.utc) + timedelta(days=7),
    )
    db.add(db_refresh)
    db.commit()

    return {
        "access_token": access_token,
        "refresh_token": refresh_token_str,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "role": user.role.value if hasattr(user.role, "value") else user.role,
            "is_anonymous": user.is_anonymous,
        },
    }
