from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError
from app.db.models import ShelfItem, ShelfStatus


def get_shelf(db: Session, user_id: int) -> list:
    return db.query(ShelfItem).filter(ShelfItem.user_id == user_id).order_by(ShelfItem.created_at.desc()).all()


def confirm_depletion(db: Session, user_id: int, item_id: int, is_depleted: bool) -> ShelfItem:
    item = db.query(ShelfItem).filter(ShelfItem.id == item_id, ShelfItem.user_id == user_id).first()
    if not item:
        raise NotFoundError("Shelf item not found")
    item.status = ShelfStatus.depleted if is_depleted else ShelfStatus.standard
    db.commit()
    db.refresh(item)
    return item


def toggle_auto_swap(db: Session, user_id: int, item_id: int, enabled: bool) -> ShelfItem:
    item = db.query(ShelfItem).filter(ShelfItem.id == item_id, ShelfItem.user_id == user_id).first()
    if not item:
        raise NotFoundError("Shelf item not found")
    item.auto_swap_enabled = enabled
    db.commit()
    db.refresh(item)
    return item
