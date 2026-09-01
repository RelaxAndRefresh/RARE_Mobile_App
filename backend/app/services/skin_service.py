from datetime import date
from typing import Optional
from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError
from app.db.models import SkinLog, SkinPhoto


def create_log(db: Session, user_id: int, data: dict) -> SkinLog:
    log = SkinLog(
        user_id=user_id,
        tags=data.get("tags", []),
        notes=data.get("notes"),
        rating=data.get("rating"),
        photo_url=data.get("photo_url"),
        photo_key=data.get("photo_key"),
    )
    db.add(log)
    db.commit()
    db.refresh(log)
    return log


def get_timeline(
    db: Session, user_id: int, page: int = 1, page_size: int = 20,
    start_date: Optional[str] = None, end_date: Optional[str] = None,
) -> dict:
    query = db.query(SkinLog).filter(SkinLog.user_id == user_id)
    if start_date:
        query = query.filter(SkinLog.created_at >= date.fromisoformat(start_date))
    if end_date:
        query = query.filter(SkinLog.created_at <= date.fromisoformat(end_date))
    total = query.count()
    logs = query.order_by(SkinLog.created_at.desc()).offset((page - 1) * page_size).limit(page_size).all()
    return {"logs": logs, "total": total, "page": page, "page_size": page_size}


def delete_log(db: Session, user_id: int, log_id: int) -> bool:
    log = db.query(SkinLog).filter(SkinLog.id == log_id, SkinLog.user_id == user_id).first()
    if not log:
        raise NotFoundError("Skin log not found")
    db.delete(log)
    db.commit()
    return True


def get_photos(db: Session, user_id: int, log_id: Optional[int] = None) -> list:
    query = db.query(SkinPhoto).filter(SkinPhoto.user_id == user_id, SkinPhoto.is_deleted == False)
    if log_id:
        query = query.filter(SkinPhoto.skin_log_id == log_id)
    return query.order_by(SkinPhoto.created_at.desc()).all()
