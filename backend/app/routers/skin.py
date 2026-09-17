from fastapi import APIRouter, Depends, Query, UploadFile, File
from sqlalchemy.orm import Session
import os
import uuid

from app.core.config import settings
from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.skin import SkinLogCreate, SkinLogResponse, SkinTimelineResponse
from app.services import skin_service

router = APIRouter(prefix="/skin", tags=["Skin Tracking"])


@router.post("/log", response_model=SkinLogResponse, status_code=201)
def create_log(data: SkinLogCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return skin_service.create_log(db, current_user.id, data.model_dump())


@router.get("/quick-log-status")
def get_quick_log_status(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {"logged_today": skin_service.has_quick_log_today(db, current_user.id)}


@router.get("/timeline", response_model=SkinTimelineResponse)
def get_timeline(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    start_date: str = None,
    end_date: str = None,
    db: Session = Depends(get_db_session),
    current_user: User = Depends(get_current_active_user),
):
    return skin_service.get_timeline(db, current_user.id, page, page_size, start_date, end_date)


@router.delete("/{log_id}")
def delete_log(log_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    skin_service.delete_log(db, current_user.id, log_id)
    return {"status": "deleted"}


@router.post("/photo", response_model=SkinLogResponse, status_code=201)
def upload_photo(
    file: UploadFile = File(...),
    notes: str = None,
    db: Session = Depends(get_db_session),
    current_user: User = Depends(get_current_active_user),
):
    os.makedirs(settings.LOCAL_STORAGE_PATH, exist_ok=True)
    ext = os.path.splitext(file.filename)[1] if file.filename else ".jpg"
    filename = f"skin_{current_user.id}_{uuid.uuid4().hex}{ext}"
    filepath = os.path.join(settings.LOCAL_STORAGE_PATH, filename)
    with open(filepath, "wb") as f:
        f.write(file.file.read())

    photo_url = f"/uploads/{filename}"
    log_data = {"notes": notes, "photo_url": photo_url, "tags": [], "rating": None}
    return skin_service.create_log(db, current_user.id, log_data)
