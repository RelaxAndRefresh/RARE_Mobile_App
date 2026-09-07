from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.commerce import CartItemAdd, CheckoutRequest, PaymentVerifyRequest
from app.services import commerce_service

router = APIRouter(prefix="/commerce", tags=["Commerce"])


@router.get("/cart")
def get_cart(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    cart = commerce_service.get_or_create_cart(db, current_user.id)
    return {"cart": cart}


@router.post("/cart/items")
def add_to_cart(data: CartItemAdd, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    cart = commerce_service.add_to_cart(db, current_user.id, data.product_id, data.quantity)
    return {"cart": cart}


@router.delete("/cart/items/{item_id}")
def remove_from_cart(item_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    cart = commerce_service.remove_from_cart(db, current_user.id, item_id)
    return {"cart": cart}


@router.post("/checkout")
def checkout(data: CheckoutRequest, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return commerce_service.checkout(db, current_user.id, data.shipping_address)


@router.post("/verify-payment")
def verify_payment(data: PaymentVerifyRequest, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    payment = commerce_service.verify_payment(db, current_user.id, data.order_id, data.payment_id, data.signature)
    return {"status": "verified", "payment_id": payment.id}
