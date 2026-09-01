from fastapi import APIRouter, Depends, Body
from sqlalchemy.orm import Session
from datetime import datetime, timezone

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, UserProfile

router = APIRouter(prefix="/wearable", tags=["Wearable"])


@router.get("/status")
def get_status(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    return {
        "connected": bool(profile and profile.wearable_provider),
        "provider": profile.wearable_provider if profile else None,
        "device_id": profile.wearable_device_id if profile else None,
        "last_sync": str(profile.last_wearable_sync) if profile and profile.last_wearable_sync else None,
    }


@router.post("/sync")
def sync_data(
    db: Session = Depends(get_db_session),
    current_user: User = Depends(get_current_active_user),
    data: dict = Body(default={}),
):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        profile = UserProfile(user_id=current_user.id)
        db.add(profile)

    wearable_data = data.get("wearable_data", {})
    if wearable_data:
        if "steps" in wearable_data:
            profile.steps_today = wearable_data["steps"]
        if "heart_rate" in wearable_data:
            profile.heart_rate = wearable_data["heart_rate"]
        if "sleep_hours" in wearable_data:
            profile.sleep_hours = wearable_data["sleep_hours"]

    profile.last_wearable_sync = datetime.now(timezone.utc)
    db.commit()
    return {
        "status": "synced",
        "message": "Wearable data synced successfully",
        "last_sync": str(profile.last_wearable_sync),
    }


@router.post("/connect")
def connect(
    provider: str,
    device_id: str,
    db: Session = Depends(get_db_session),
    current_user: User = Depends(get_current_active_user),
):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        profile = UserProfile(user_id=current_user.id)
        db.add(profile)
    profile.wearable_provider = provider
    profile.wearable_device_id = device_id
    profile.last_wearable_sync = datetime.now(timezone.utc)
    db.commit()
    return {"status": "connected", "provider": provider}


@router.delete("/disconnect")
def disconnect(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if profile:
        profile.wearable_provider = None
        profile.wearable_device_id = None
        profile.last_wearable_sync = None
        db.commit()
    return {"status": "disconnected"}
