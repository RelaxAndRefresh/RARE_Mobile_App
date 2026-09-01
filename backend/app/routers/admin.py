from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_user
from app.db.models import User, UserRole

router = APIRouter(prefix="/admin", tags=["Admin"])


@router.get("/dashboard")
def admin_dashboard(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_user)):
    if current_user.role != UserRole.admin:
        return {"error": "Admin access required"}
    return {"status": "admin dashboard", "message": "Admin endpoints coming soon"}


@router.get("/users")
def list_users(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_user)):
    if current_user.role != UserRole.admin:
        return {"error": "Admin access required"}
    return {"users": [], "message": "Admin user management coming soon"}
