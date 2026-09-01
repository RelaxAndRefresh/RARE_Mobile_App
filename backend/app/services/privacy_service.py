from sqlalchemy.orm import Session

from app.db.models import PrivacyConsent, PrivacyAuditLog, PrivacyCategory


def get_consents(db: Session, user_id: int) -> list:
    return db.query(PrivacyConsent).filter(PrivacyConsent.user_id == user_id).all()


def update_consent(db: Session, user_id: int, category: str, consented: bool, ip_address: str = None) -> PrivacyConsent:
    cat = PrivacyCategory(category)
    existing = db.query(PrivacyConsent).filter(
        PrivacyConsent.user_id == user_id, PrivacyConsent.category == cat
    ).first()
    if existing:
        existing.consented = consented
        consent = existing
    else:
        consent = PrivacyConsent(user_id=user_id, category=cat, consented=consented)
        db.add(consent)

    audit = PrivacyAuditLog(
        user_id=user_id,
        action="consent_update",
        details={"category": category, "consented": consented},
        ip_address=ip_address,
    )
    db.add(audit)
    db.commit()
    db.refresh(consent)
    return consent


def request_export(db: Session, user_id: int, export_type: str, email: str = None) -> dict:
    audit = PrivacyAuditLog(
        user_id=user_id,
        action="data_export_request",
        details={"export_type": export_type, "email": email},
    )
    db.add(audit)
    db.commit()
    return {"status": "export_requested", "message": "Your data export will be processed within 48 hours."}


def request_deletion(db: Session, user_id: int, reason: str = None, ip_address: str = None) -> dict:
    audit = PrivacyAuditLog(
        user_id=user_id,
        action="account_deletion_request",
        details={"reason": reason},
        ip_address=ip_address,
    )
    db.add(audit)
    db.commit()
    return {"status": "deletion_requested", "message": "Your account deletion request will be processed within 30 days."}
