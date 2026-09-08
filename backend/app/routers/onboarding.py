from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.onboarding import (
    OnboardingProgressResponse, SoftScanCreate, SoftScanResponse,
    PrivacyConsentCreate, PrivacyConsentResponse, CycleBaselineCreate, WearableConnectionCreate,
)
from app.services import onboarding_service

router = APIRouter(prefix="/onboarding", tags=["Onboarding"])


@router.get("/progress", response_model=OnboardingProgressResponse)
def get_progress(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.get_progress(db, current_user.id)


@router.put("/step")
def update_step(step: str, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.update_step(db, current_user.id, step)


@router.post("/soft-scan", response_model=SoftScanResponse)
def submit_scan(data: SoftScanCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.submit_scan(db, current_user.id, data.model_dump())


@router.post("/privacy-consent", response_model=PrivacyConsentResponse)
def save_privacy_consent(data: PrivacyConsentCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.save_privacy_consent(db, current_user.id, data.category, data.consented)


@router.post("/cycle-baseline")
def save_cycle_baseline(data: CycleBaselineCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.save_cycle_baseline(db, current_user.id, data.cycle_length, data.last_period_start)


@router.post("/wearable")
def save_wearable(data: WearableConnectionCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return onboarding_service.save_wearable(db, current_user.id, data.provider, data.device_id)
