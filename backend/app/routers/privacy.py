from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.privacy import PrivacyConsentUpdate, DataExportRequest, AccountDeletionRequest
from app.services import privacy_service

router = APIRouter(prefix="/privacy", tags=["Privacy"])


@router.get("/consents")
def get_consents(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {"consents": privacy_service.get_consents(db, current_user.id)}


@router.put("/consents")
def update_consent(data: PrivacyConsentUpdate, request: Request, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    ip = request.client.host if request.client else None
    consent = privacy_service.update_consent(db, current_user.id, data.category, data.consented, ip)
    return {"status": "updated", "consent_id": consent.id}


@router.post("/export")
def request_export(data: DataExportRequest, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return privacy_service.request_export(db, current_user.id, data.export_type, data.email)


@router.post("/delete")
def request_deletion(data: AccountDeletionRequest, request: Request, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    if data.confirmation != "DELETE_MY_ACCOUNT":
        return {"error": "Please type DELETE_MY_ACCOUNT to confirm"}
    ip = request.client.host if request.client else None
    return privacy_service.request_deletion(db, current_user.id, data.reason, ip)
