from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.services import insight_service

router = APIRouter(prefix="/insights", tags=["Insights"])


@router.get("/biweekly")
def get_biweekly(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return insight_service.get_biweekly(db, current_user.id)


@router.get("/monthly")
def get_monthly(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return insight_service.get_monthly(db, current_user.id)


@router.get("/pulse")
def get_pulse(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return insight_service.get_pulse_feed(db, current_user.id)
