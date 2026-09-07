from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class SkinLogCreate(BaseModel):
    tags: List[str] = []
    notes: Optional[str] = None
    rating: Optional[int] = Field(None, ge=1, le=10)


class SkinLogResponse(BaseModel):
    id: int
    tags: List[str] = []
    notes: Optional[str] = None
    rating: Optional[int] = None
    photo_url: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class SkinTimelineResponse(BaseModel):
    logs: List[SkinLogResponse]
    total: int
    page: int
    page_size: int


class SkinLogDeleteRequest(BaseModel):
    log_id: int
