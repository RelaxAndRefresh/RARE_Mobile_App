from typing import Callable

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core.exceptions import AuthenticationError, AuthorizationError
from app.core.security import decode_token
from app.db.database import get_db
from app.db.models import User

security = HTTPBearer()


async def get_db_session():
    db = get_db()
    try:
        yield db
    finally:
        db.close()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db_session),
) -> User:
    token = credentials.credentials
    payload = decode_token(token)
    if payload is None:
        raise AuthenticationError("Invalid or expired token")
    if payload.get("type") != "access":
        raise AuthenticationError("Invalid token type")
    user_id = payload.get("sub")
    if user_id is None:
        raise AuthenticationError("Invalid token payload")
    user = db.query(User).filter(User.id == int(user_id)).first()
    if user is None:
        raise AuthenticationError("User not found")
    return user


async def get_current_active_user(
    current_user: User = Depends(get_current_user),
) -> User:
    if not current_user.is_active:
        raise AuthorizationError("Account is deactivated")
    return current_user


def require_role(*roles: str) -> Callable:
    async def role_checker(current_user: User = Depends(get_current_active_user)) -> User:
        if current_user.role not in roles:
            raise AuthorizationError(f"Requires one of roles: {', '.join(roles)}")
        return current_user
    return role_checker
