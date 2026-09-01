from datetime import datetime
from sqlalchemy.orm import Session

from app.core.exceptions import AuthenticationError, NotFoundError
from app.core.security import verify_password, create_access_token
from app.db.models import User, UserRole, UserProfile, DailyCheckin, SkinLog, CycleEvent, TreatmentSession, PractitionerClient


def login(db: Session, email: str, password: str) -> dict:
    user = db.query(User).filter(User.email == email, User.role == UserRole.practitioner).first()
    if not user or not verify_password(password, user.password_hash):
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


def get_client_summary(db: Session, practitioner_id: int, client_id: int) -> dict:
    client = db.query(User).filter(User.id == client_id).first()
    if not client:
        raise NotFoundError("Client not found")
    link = db.query(PractitionerClient).filter(
        PractitionerClient.practitioner_id == practitioner_id,
        PractitionerClient.client_id == client_id,
        PractitionerClient.is_active == True,
    ).first()
    if not link:
        raise NotFoundError("Client not associated with this practitioner")

    profile = db.query(UserProfile).filter(UserProfile.user_id == client_id).first()
    last_checkin = db.query(DailyCheckin).filter(DailyCheckin.user_id == client_id).order_by(DailyCheckin.created_at.desc()).first()
    recent_logs = db.query(SkinLog).filter(SkinLog.user_id == client_id).order_by(SkinLog.created_at.desc()).limit(5).all()

    return {
        "id": client.id,
        "name": client.name,
        "email": client.email,
        "skin_type": profile.skin_type if profile else None,
        "barrier_status": profile.barrier_status if profile else None,
        "last_checkin": last_checkin.created_at if last_checkin else None,
        "recent_logs": [{"id": l.id, "tags": l.tags, "rating": l.rating, "created_at": l.created_at} for l in recent_logs],
    }


def create_session(db: Session, practitioner_id: int, data: dict) -> TreatmentSession:
    session = TreatmentSession(
        practitioner_id=practitioner_id,
        client_id=data["client_id"],
        session_type=data["session_type"],
        pre_treatment_notes=data.get("pre_treatment_notes"),
        post_treatment_notes=data.get("post_treatment_notes"),
        protocol=data.get("protocol"),
    )
    db.add(session)
    db.commit()
    db.refresh(session)
    return session


def get_protocol(db: Session, practitioner_id: int, session_id: int) -> TreatmentSession:
    session = db.query(TreatmentSession).filter(
        TreatmentSession.id == session_id,
        TreatmentSession.practitioner_id == practitioner_id,
    ).first()
    if not session:
        raise NotFoundError("Session not found")
    return session
