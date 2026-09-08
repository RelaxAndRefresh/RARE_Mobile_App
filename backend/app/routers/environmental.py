from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, EnvironmentalData

router = APIRouter(prefix="/environmental", tags=["Environmental Data"])


@router.get("/by-pincode")
def get_by_pincode(pincode: str, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    data = db.query(EnvironmentalData).filter(
        EnvironmentalData.pincode == pincode
    ).order_by(EnvironmentalData.recorded_at.desc()).first()
    if not data:
        return {"message": "No environmental data available for this pincode"}
    return {
        "pincode": data.pincode,
        "city": data.city,
        "aqi": data.aqi,
        "pm25": data.pm25,
        "pm10": data.pm10,
        "humidity": data.humidity,
        "uv_index": data.uv_index,
        "recorded_at": str(data.recorded_at),
    }


@router.get("/current")
def get_current(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    from app.db.models import UserProfile
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile or not profile.pincode:
        return {"message": "No pincode set in profile"}
    data = db.query(EnvironmentalData).filter(
        EnvironmentalData.pincode == profile.pincode
    ).order_by(EnvironmentalData.recorded_at.desc()).first()
    if not data:
        return {"message": "No environmental data available"}
    return {
        "pincode": data.pincode,
        "city": data.city,
        "aqi": data.aqi,
        "pm25": data.pm25,
        "pm10": data.pm10,
        "humidity": data.humidity,
        "uv_index": data.uv_index,
        "recorded_at": str(data.recorded_at),
    }
