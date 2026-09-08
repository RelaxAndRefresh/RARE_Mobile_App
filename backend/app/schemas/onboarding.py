from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class OnboardingProgressResponse(BaseModel):
    current_step: str
    completed_steps: List[str]
    is_complete: bool

    class Config:
        from_attributes = True


class SoftScanCreate(BaseModel):
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    adaptive_tags: List[str] = []
    scan_metadata: dict = {}
    confidence: Optional[float] = None
    is_manual_fallback: bool = False


class SoftScanResponse(BaseModel):
    id: int
    skin_type: Optional[str] = None
    barrier_status: Optional[str] = None
    adaptive_tags: List[str] = []
    confidence: Optional[float] = None
    created_at: datetime

    class Config:
        from_attributes = True


class PrivacyConsentCreate(BaseModel):
    category: str
    consented: bool


class PrivacyConsentResponse(BaseModel):
    id: int
    category: str
    consented: bool
    created_at: datetime

    class Config:
        from_attributes = True


class CycleBaselineCreate(BaseModel):
    cycle_length: int
    last_period_start: str


class WearableConnectionCreate(BaseModel):
    provider: str
    device_id: str
