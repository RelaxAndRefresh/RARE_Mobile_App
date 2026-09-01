from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.skin import SkinLogCreate, SkinLogResponse, SkinTimelineResponse
from app.services import skin_service

router = APIRouter(prefix="/skin", tags=["Skin Tracking"])


@router.post("/log", response_model=SkinLogResponse, status_code=201)
def create_log(data: SkinLogCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return skin_service.create_log(db, current_user.id, data.model_dump())


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


@router.post("/photo")
def upload_photo(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {"status": "upload_endpoint", "message": "Use multipart/form-data upload"}
