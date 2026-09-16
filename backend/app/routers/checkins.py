from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from datetime import date

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, DailyCheckin, HydrationLog, CheckinType
from app.schemas.checkin import DailyCheckinCreate, DailyCheckinResponse, HydrationLogCreate, HydrationLogResponse
from app.core.exceptions import NotFoundError

router = APIRouter(prefix="/checkins", tags=["Check-ins"])


@router.post("/am", response_model=DailyCheckinResponse, status_code=201)
def create_am_checkin(data: DailyCheckinCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    checkin = DailyCheckin(
        user_id=current_user.id,
        checkin_type=CheckinType.am,
        date=date.today(),
        sleep_hours=data.sleep_hours,
        mood=data.mood,
        energy=data.energy,
        stress=data.stress,
        skin_feel=data.skin_feel,
        tags=data.tags,
        notes=data.notes,
    )
    db.add(checkin)
    db.commit()
    db.refresh(checkin)
    return checkin


@router.post("/pm", response_model=DailyCheckinResponse, status_code=201)
def create_pm_checkin(data: DailyCheckinCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    checkin = DailyCheckin(
        user_id=current_user.id,
        checkin_type=CheckinType.pm,
        date=date.today(),
        sleep_hours=data.sleep_hours,
        mood=data.mood,
        energy=data.energy,
        stress=data.stress,
        skin_feel=data.skin_feel,
        tags=data.tags,
        notes=data.notes,
    )
    db.add(checkin)
    db.commit()
    db.refresh(checkin)
    return checkin


@router.get("/today")
def get_today_checkins(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    today = date.today()
    checkins = db.query(DailyCheckin).filter(
        DailyCheckin.user_id == current_user.id, DailyCheckin.date == today
    ).all()
    hydration = db.query(HydrationLog).filter(
        HydrationLog.user_id == current_user.id, HydrationLog.date == today
    ).first()
    return {
        "checkins": checkins,
        "hydration": hydration,
    }


@router.put("/{checkin_id}", response_model=DailyCheckinResponse)
def update_checkin(checkin_id: int, data: DailyCheckinCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    checkin = db.query(DailyCheckin).filter(
        DailyCheckin.id == checkin_id, DailyCheckin.user_id == current_user.id
    ).first()
    if not checkin:
        raise NotFoundError("Check-in not found")
    for field in ["sleep_hours", "mood", "energy", "stress", "skin_feel", "tags", "notes"]:
        val = getattr(data, field, None)
        if val is not None:
            setattr(checkin, field, val)
    db.commit()
    db.refresh(checkin)
    return checkin


@router.post("/hydration", response_model=HydrationLogResponse, status_code=201)
def log_hydration(data: HydrationLogCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    today = date.today()
    existing = db.query(HydrationLog).filter(
        HydrationLog.user_id == current_user.id, HydrationLog.date == today
    ).first()
    if existing:
        existing.volume_ml += data.volume_ml
        existing.tap_count += 1
        db.commit()
        db.refresh(existing)
        return existing
    log = HydrationLog(
        user_id=current_user.id,
        date=today,
        volume_ml=data.volume_ml,
        tap_count=1,
    )
    db.add(log)
    db.commit()
    db.refresh(log)
    return log


@router.get("/hydration/today")
def get_today_hydration(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    today = date.today()
    logs = db.query(HydrationLog).filter(
        HydrationLog.user_id == current_user.id, HydrationLog.date == today
    ).all()
    return {"logs": [log.__dict__ for log in logs], "total_ml": sum(l.volume_ml for l in logs), "tap_count": sum(l.tap_count for l in logs)}
