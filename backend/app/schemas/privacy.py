from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class PrivacyConsentUpdate(BaseModel):
    category: str
    consented: bool


class DataExportRequest(BaseModel):
    export_type: str = "full"
    email: Optional[str] = None


class AccountDeletionRequest(BaseModel):
    confirmation: str
    reason: Optional[str] = None
