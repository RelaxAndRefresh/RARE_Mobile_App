from pydantic import BaseModel
from typing import Optional, Any
from datetime import datetime


class NotificationResponse(BaseModel):
    id: int
    notification_type: str
    title: str
    body: str
    target_screen: Optional[str] = None
    payload: Optional[Any] = None
    is_read: bool = False
    created_at: datetime

    class Config:
        from_attributes = True


class NotificationMarkRead(BaseModel):
    notification_ids: list[int] = []
    mark_all: bool = False
