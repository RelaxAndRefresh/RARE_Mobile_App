from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from datetime import date

from app.core.dependencies import get_db_session, get_current_active_user
from app.core.exceptions import ValidationError
from app.db.models import User, CycleEvent, UserProfile, CycleEventType
from app.core.exceptions import NotFoundError

VALID_CYCLE_EVENTS = {e.value for e in CycleEventType}

router = APIRouter(prefix="/cycle", tags=["Cycle Tracking"])


@router.post("/event", status_code=201)
def create_event(
    event_type: str = Query(...),
    notes: str = None,
    event_date: str = None,
    db: Session = Depends(get_db_session),
    current_user: User = Depends(get_current_active_user),
):
    if event_type not in VALID_CYCLE_EVENTS:
        raise ValidationError(f"Invalid event_type. Must be one of: {', '.join(VALID_CYCLE_EVENTS)}")

    parsed_date = date.today()
    if event_date:
        try:
            parsed_date = date.fromisoformat(event_date)
        except ValueError:
            raise ValidationError("Invalid date format. Use YYYY-MM-DD.")

    cycle_event = CycleEvent(
        user_id=current_user.id,
        event_type=CycleEventType(event_type),
        date=parsed_date,
        notes=notes,
    )
    db.add(cycle_event)
    if event_type == "period_start":
        profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
        if profile:
            profile.last_period_start = cycle_event.date
    db.commit()
    return {"status": "created", "event_id": cycle_event.id}


@router.get("/calendar")
def get_calendar(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    events = db.query(CycleEvent).filter(
        CycleEvent.user_id == current_user.id
    ).order_by(CycleEvent.date.desc()).limit(90).all()
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    return {
        "events": [{"id": e.id, "event_type": e.event_type.value, "date": str(e.date), "notes": e.notes} for e in events],
        "cycle_length": profile.cycle_length if profile else None,
        "last_period_start": str(profile.last_period_start) if profile and profile.last_period_start else None,
    }


@router.put("/pause")
def pause_tracking(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {"status": "paused", "message": "Cycle tracking paused"}
