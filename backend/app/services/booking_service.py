from sqlalchemy.orm import Session
from datetime import datetime

from app.core.exceptions import NotFoundError, ValidationError
from app.db.models import TreatmentSession, PractitionerClient


# Placeholder services - booking service manages practitioner-client sessions
# In production, this would integrate with a calendar/availability system


def get_services(db: Session) -> list:
    return [
        {"id": 1, "name": "Consultation", "description": "Initial skin consultation", "duration_minutes": 30, "price_inr": 500},
        {"id": 2, "name": "Treatment Session", "description": "Standard treatment session", "duration_minutes": 60, "price_inr": 1500},
        {"id": 3, "name": "Follow-up", "description": "Follow-up review session", "duration_minutes": 20, "price_inr": 300},
    ]


def get_availability(db: Session, practitioner_id: int, date_str: str) -> list:
    from datetime import date
    d = date.fromisoformat(date_str)
    slots = []
    for hour in range(10, 18):
        slots.append({
            "time": f"{hour:02d}:00",
            "available": True,
        })
        slots.append({
            "time": f"{hour:02d}:30",
            "available": True,
        })
    return slots


def create_booking(db: Session, user_id: int, data: dict) -> dict:
    practitioner = db.query(PractitionerClient).filter(
        PractitionerClient.practitioner_id == data["practitioner_id"],
        PractitionerClient.client_id == user_id,
        PractitionerClient.is_active == True,
    ).first()
    if not practitioner:
        practitioner = PractitionerClient(
            practitioner_id=data["practitioner_id"],
            client_id=user_id,
        )
        db.add(practitioner)

    session = TreatmentSession(
        practitioner_id=data["practitioner_id"],
        client_id=user_id,
        session_type=data.get("session_type", "consultation"),
        pre_treatment_notes=data.get("notes"),
    )
    db.add(session)
    db.commit()
    db.refresh(session)
    return {
        "id": session.id,
        "service_name": "Consultation",
        "practitioner_name": "Practitioner",
        "scheduled_at": data.get("scheduled_at", datetime.utcnow()),
        "status": "confirmed",
        "notes": data.get("notes"),
        "created_at": session.created_at,
    }


def cancel_booking(db: Session, user_id: int, booking_id: int) -> dict:
    session = db.query(TreatmentSession).filter(
        TreatmentSession.id == booking_id,
        TreatmentSession.client_id == user_id,
    ).first()
    if not session:
        raise NotFoundError("Booking not found")
    return {"id": session.id, "status": "cancelled"}


def get_bookings(db: Session, user_id: int) -> list:
    sessions = db.query(TreatmentSession).filter(
        TreatmentSession.client_id == user_id,
    ).order_by(TreatmentSession.created_at.desc()).all()
    return [
        {
            "id": s.id,
            "service_name": s.session_type,
            "practitioner_name": "Practitioner",
            "scheduled_at": s.created_at,
            "status": "confirmed",
            "notes": s.pre_treatment_notes,
            "created_at": s.created_at,
        }
        for s in sessions
    ]
