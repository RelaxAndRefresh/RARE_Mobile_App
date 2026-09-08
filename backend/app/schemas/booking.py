from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class ServiceResponse(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    duration_minutes: int
    price_inr: float

    class Config:
        from_attributes = True


class BookingCreate(BaseModel):
    service_id: int
    practitioner_id: int
    scheduled_at: datetime
    notes: Optional[str] = None


class BookingResponse(BaseModel):
    id: int
    service_name: str
    practitioner_name: str
    scheduled_at: datetime
    status: str
    notes: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class BookingListResponse(BaseModel):
    bookings: List[BookingResponse]
    total: int
