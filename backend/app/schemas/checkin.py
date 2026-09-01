from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date, datetime


class DailyCheckinCreate(BaseModel):
    checkin_type: str = Field(pattern=r"^(am|pm)$")
    sleep_hours: Optional[float] = Field(None, ge=0, le=24)
    mood: Optional[int] = Field(None, ge=1, le=10)
    energy: Optional[int] = Field(None, ge=1, le=10)
    stress: Optional[int] = Field(None, ge=1, le=10)
    skin_feel: Optional[str] = None
    tags: List[str] = []
    notes: Optional[str] = None


class DailyCheckinResponse(BaseModel):
    id: int
    checkin_type: str
    date: date
    sleep_hours: Optional[float] = None
    mood: Optional[int] = None
    energy: Optional[int] = None
    stress: Optional[int] = None
    skin_feel: Optional[str] = None
    tags: List[str] = []
    notes: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class HydrationLogCreate(BaseModel):
    volume_ml: int = 0


class HydrationLogResponse(BaseModel):
    id: int
    date: date
    volume_ml: int
    tap_count: int
    created_at: datetime

    class Config:
        from_attributes = True
