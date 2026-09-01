from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.services import order_service

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.get("/")
def get_orders(page: int = Query(1, ge=1), db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return order_service.get_orders(db, current_user.id, page)


@router.get("/{order_id}")
def get_order(order_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return order_service.get_order_detail(db, current_user.id, order_id)
