from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError, ConflictError
from app.db.models import (
    OnboardingProgress, UserProfile, SoftScan, PrivacyConsent,
    CycleEvent, WearableSync, User, OnboardingStep, PrivacyCategory, CycleEventType
)


def get_progress(db: Session, user_id: int) -> OnboardingProgress:
    progress = db.query(OnboardingProgress).filter(OnboardingProgress.user_id == user_id).first()
    if not progress:
        progress = OnboardingProgress(user_id=user_id)
        db.add(progress)
        db.commit()
        db.refresh(progress)
    return progress


def update_step(db: Session, user_id: int, step: str) -> OnboardingProgress:
    progress = get_progress(db, user_id)
    progress.current_step = OnboardingStep(step)
    completed = progress.completed_steps or []
    if step not in completed:
        completed.append(step)
    progress.completed_steps = completed
    if step == "complete":
        progress.is_complete = True
    db.commit()
    db.refresh(progress)
    return progress


def submit_scan(db: Session, user_id: int, data: dict) -> SoftScan:
    scan = SoftScan(
        user_id=user_id,
        skin_type=data.get("skin_type"),
        barrier_status=data.get("barrier_status"),
        adaptive_tags=data.get("adaptive_tags", []),
        scan_metadata=data.get("scan_metadata", {}),
        confidence=data.get("confidence"),
        is_manual_fallback=data.get("is_manual_fallback", False),
    )
    db.add(scan)
    db.flush()

    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        profile = UserProfile(user_id=user_id)
        db.add(profile)
    if scan.skin_type:
        profile.skin_type = scan.skin_type
    if scan.barrier_status:
        profile.barrier_status = scan.barrier_status
    db.commit()
    db.refresh(scan)
    return scan


def save_privacy_consent(db: Session, user_id: int, category: str, consented: bool) -> PrivacyConsent:
    cat = PrivacyCategory(category)
    existing = db.query(PrivacyConsent).filter(
        PrivacyConsent.user_id == user_id,
        PrivacyConsent.category == cat,
    ).first()
    if existing:
        existing.consented = consented
        db.commit()
        db.refresh(existing)
        return existing
    consent = PrivacyConsent(user_id=user_id, category=cat, consented=consented)
    db.add(consent)
    db.commit()
    db.refresh(consent)
    return consent


def save_cycle_baseline(db: Session, user_id: int, cycle_length: int, last_period_start: str) -> UserProfile:
    from datetime import date
    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        profile = UserProfile(user_id=user_id)
        db.add(profile)
    profile.cycle_length = cycle_length
    profile.last_period_start = date.fromisoformat(last_period_start)
    db.commit()
    db.refresh(profile)
    return profile


def save_wearable(db: Session, user_id: int, provider: str, device_id: str) -> UserProfile:
    profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
    if not profile:
        profile = UserProfile(user_id=user_id)
        db.add(profile)
    profile.wearable_provider = provider
    profile.wearable_device_id = device_id
    db.commit()
    db.refresh(profile)
    return profile
