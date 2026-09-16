from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, Notification
from app.services import notification_service

router = APIRouter(prefix="/inbox", tags=["Inbox / Notifications"])


@router.get("/")
def get_notifications(unread_only: bool = False, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    notifications = notification_service.get_notifications(db, current_user.id, unread_only)
    return {"notifications": notifications}


@router.get("/unread-count")
def get_unread_count(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    from sqlalchemy import func
    count = db.query(func.count()).filter(
        Notification.user_id == current_user.id,
        Notification.is_read == False
    ).scalar()
    return {"count": count}


@router.put("/{notification_id}/read")
def mark_notification_read(notification_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    count = notification_service.mark_read(db, current_user.id, [notification_id])
    return {"status": "read", "updated": count}
