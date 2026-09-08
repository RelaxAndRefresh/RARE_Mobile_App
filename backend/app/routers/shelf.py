from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.shelf import ShelfItemResponse, DepletionConfirmRequest
from app.services import shelf_service

router = APIRouter(prefix="/shelf", tags=["Product Shelf"])


@router.get("/items")
def get_items(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    items = shelf_service.get_shelf(db, current_user.id)
    return {"items": items}


@router.post("/depletion-confirm")
def confirm_depletion(data: DepletionConfirmRequest, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    item = shelf_service.confirm_depletion(db, current_user.id, data.item_id, data.is_depleted)
    return {"status": "updated", "item_id": item.id, "status": item.status.value}


@router.put("/auto-swap")
def toggle_auto_swap(item_id: int, enabled: bool, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    item = shelf_service.toggle_auto_swap(db, current_user.id, item_id, enabled)
    return {"status": "updated", "item_id": item.id, "auto_swap_enabled": item.auto_swap_enabled}
