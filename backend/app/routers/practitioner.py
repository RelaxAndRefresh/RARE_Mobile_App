from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_user
from app.core.security import verify_password, create_access_token
from app.db.models import User, UserRole
from app.schemas.practitioner import PractitionerLogin, PostTreatmentProtocolCreate
from app.services import practitioner_service
from app.core.exceptions import AuthenticationError

router = APIRouter(prefix="/practitioner", tags=["Practitioner"])


@router.post("/login")
def login(data: PractitionerLogin, db: Session = Depends(get_db_session)):
    user = db.query(User).filter(User.email == data.email, User.role == UserRole.practitioner).first()
    if not user or not verify_password(data.password, user.password_hash):
        raise AuthenticationError("Invalid credentials")
    if not user.is_active:
        raise AuthenticationError("Account is deactivated")
    access_token = create_access_token(data={"sub": str(user.id), "role": user.role.value})
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "role": user.role.value,
        },
    }


@router.get("/clients/{client_id}")
def get_client_summary(client_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_user)):
    return practitioner_service.get_client_summary(db, current_user.id, client_id)


@router.post("/sessions")
def create_session(data: PostTreatmentProtocolCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_user)):
    return practitioner_service.create_session(db, current_user.id, data.model_dump())


@router.get("/sessions/{session_id}/protocol")
def get_protocol(session_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_user)):
    return practitioner_service.get_protocol(db, current_user.id, session_id)
