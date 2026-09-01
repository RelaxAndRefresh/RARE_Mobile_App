from pydantic import BaseModel
from typing import Optional


class UserProfileResponse(BaseModel):
    id: int
    user_id: int
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    hydration_index: Optional[float] = None
    barrier_function: Optional[float] = None
    sebum_balance: Optional[float] = None
    sensitivity_score: Optional[float] = None
    cycle_length: Optional[int] = None
    last_period_start: Optional[str] = None
    wearable_provider: Optional[str] = None
    pincode: Optional[str] = None
    city: Optional[str] = None

    class Config:
        from_attributes = True


class UserProfileUpdate(BaseModel):
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    hydration_index: Optional[float] = None
    barrier_function: Optional[float] = None
    sebum_balance: Optional[float] = None
    sensitivity_score: Optional[float] = None
    pincode: Optional[str] = None
    city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class AccountDetailsUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
