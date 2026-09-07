from sqlalchemy.orm import Session

from app.db.models import Notification


def get_notifications(db: Session, user_id: int, unread_only: bool = False) -> list:
    query = db.query(Notification).filter(Notification.user_id == user_id)
    if unread_only:
        query = query.filter(Notification.is_read == False)
    return query.order_by(Notification.created_at.desc()).all()


def mark_read(db: Session, user_id: int, notification_ids: list = None, mark_all: bool = False) -> int:
    query = db.query(Notification).filter(Notification.user_id == user_id)
    if mark_all:
        query = query.filter(Notification.is_read == False)
    elif notification_ids:
        query = query.filter(Notification.id.in_(notification_ids))
    else:
        return 0
    count = query.update({"is_read": True})
    db.commit()
    return count


def create_notification(db: Session, user_id: int, notification_type: str, title: str, body: str,
                        target_screen: str = None, payload: dict = None) -> Notification:
    notification = Notification(
        user_id=user_id,
        notification_type=notification_type,
        title=title,
        body=body,
        target_screen=target_screen,
        payload=payload,
    )
    db.add(notification)
    db.commit()
    db.refresh(notification)
    return notification
