from pydantic import BaseModel
from typing import Optional, List, Any
from datetime import datetime


class ProductListResponse(BaseModel):
    products: List[Any]
    total: int


class CartItemAdd(BaseModel):
    product_id: int
    quantity: int = 1


class CartResponse(BaseModel):
    id: int
    items: List[Any] = []
    total: float = 0

    class Config:
        from_attributes = True


class CheckoutRequest(BaseModel):
    shipping_address: dict
    payment_method: str = "razorpay"


class OrderResponse(BaseModel):
    id: int
    order_number: str
    status: str
    subtotal_inr: float
    shipping_inr: float = 0
    tax_inr: float = 0
    total_inr: float
    items: List[Any] = []
    created_at: datetime

    class Config:
        from_attributes = True


class PaymentVerifyRequest(BaseModel):
    order_id: int
    payment_id: str
    signature: str
