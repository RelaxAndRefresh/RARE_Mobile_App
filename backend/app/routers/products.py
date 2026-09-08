from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.services import commerce_service

router = APIRouter(prefix="/products", tags=["Products"])


@router.get("/")
def get_products(category: str = None, page: int = Query(1, ge=1), db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return commerce_service.get_products(db, category, page)


@router.get("/{product_id}")
def get_product(product_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    product = commerce_service.get_product(db, product_id)
    return product
