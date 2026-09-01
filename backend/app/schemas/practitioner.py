from pydantic import BaseModel
from typing import Optional, List, Any
from datetime import datetime


class PractitionerLogin(BaseModel):
    email: str
    password: str


class ClientSummaryResponse(BaseModel):
    id: int
    name: Optional[str] = None
    email: Optional[str] = None
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    last_checkin: Optional[datetime] = None
    recent_logs: List[Any] = []

    class Config:
        from_attributes = True


class PreTreatmentSyncResponse(BaseModel):
    client_id: int
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    recent_checkins: List[Any] = []
    skin_logs: List[Any] = []
    cycle_status: Optional[Any] = None


class PostTreatmentProtocolCreate(BaseModel):
    client_id: int
    session_type: str
    pre_treatment_notes: Optional[str] = None
    post_treatment_notes: Optional[str] = None
    protocol: dict = {}
