from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class SupportTicketCreate(BaseModel):
    subject: str
    description: str


class SupportTicketResponse(BaseModel):
    id: int
    subject: str
    description: str
    status: str
    created_at: datetime

    class Config:
        from_attributes = True


class SupportMessageCreate(BaseModel):
    message: str
    attachment_url: Optional[str] = None
