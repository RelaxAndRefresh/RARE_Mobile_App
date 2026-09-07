from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, UserProfile
from app.schemas.user import UserProfileResponse, UserProfileUpdate, AccountDetailsUpdate
from app.core.exceptions import NotFoundError

router = APIRouter(prefix="/users", tags=["Users"])


@router.get("/profile", response_model=UserProfileResponse)
def get_profile(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        profile = UserProfile(user_id=current_user.id)
        db.add(profile)
        db.commit()
        db.refresh(profile)
    return profile


@router.put("/profile", response_model=UserProfileResponse)
def update_profile(data: UserProfileUpdate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    profile = db.query(UserProfile).filter(UserProfile.user_id == current_user.id).first()
    if not profile:
        profile = UserProfile(user_id=current_user.id)
        db.add(profile)
    update_data = data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(profile, field, value)
    db.commit()
    db.refresh(profile)
    return profile


@router.put("/account-details")
def update_account_details(data: AccountDetailsUpdate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    if data.name is not None:
        current_user.name = data.name
    if data.email is not None:
        current_user.email = data.email
    if data.phone is not None:
        current_user.phone = data.phone
    db.commit()
    return {"status": "updated"}
