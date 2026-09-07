from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.auth import UserCreate, UserLogin, TokenResponse, TokenRefreshRequest, AnonymousSignup
from app.services import auth_service

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/signup", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def signup(data: UserCreate, db: Session = Depends(get_db_session)):
    return auth_service.signup(db, email=data.email, name=data.name, password=data.password)


@router.post("/anonymous", response_model=TokenResponse, status_code=status.HTTP_201_CREATED)
def signup_anonymous(data: AnonymousSignup = None, db: Session = Depends(get_db_session)):
    name = data.name if data else "Anonymous User"
    return auth_service.signup(db, name=name)


@router.post("/login", response_model=TokenResponse)
def login(data: UserLogin, db: Session = Depends(get_db_session)):
    return auth_service.login(db, email=data.email, password=data.password)


@router.post("/refresh", response_model=TokenResponse)
def refresh(data: TokenRefreshRequest, db: Session = Depends(get_db_session)):
    return auth_service.refresh_token(db, data.refresh_token)


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
def logout(data: TokenRefreshRequest, db: Session = Depends(get_db_session)):
    auth_service.logout(db, data.refresh_token)


@router.get("/me")
def me(current_user: User = Depends(get_current_active_user)):
    return {
        "id": current_user.id,
        "email": current_user.email,
        "name": current_user.name,
        "role": current_user.role.value if hasattr(current_user.role, "value") else current_user.role,
        "is_anonymous": current_user.is_anonymous,
    }
