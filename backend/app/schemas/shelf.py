from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class ProductResponse(BaseModel):
    id: int
    name: str
    brand: Optional[str] = None
    description: Optional[str] = None
    category: Optional[str] = None
    price_inr: float
    image_url: Optional[str] = None
    stock_quantity: int = 0

    class Config:
        from_attributes = True


class ShelfItemResponse(BaseModel):
    id: int
    product: Optional[ProductResponse] = None
    status: str
    depletion_estimate_days: Optional[int] = None
    last_restocked: Optional[datetime] = None
    auto_swap_enabled: bool = False
    created_at: datetime

    class Config:
        from_attributes = True


class DepletionConfirmRequest(BaseModel):
    item_id: int
    is_depleted: bool = True
