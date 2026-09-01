from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from sqlalchemy import func

from app.core.dependencies import get_db_session, require_role
from app.core.exceptions import AuthorizationError
from app.db.models import User, UserRole, Order, TreatmentSession, Product

router = APIRouter(prefix="/admin", tags=["Admin"])


@router.get("/dashboard")
def admin_dashboard(
    db: Session = Depends(get_db_session),
    current_user: User = Depends(require_role(UserRole.admin)),
):
    total_users = db.query(User).filter(User.role == UserRole.user).count()
    total_orders = db.query(Order).count()
    total_revenue = db.query(func.sum(Order.total_inr)).scalar() or 0
    total_sessions = db.query(TreatmentSession).count()
    total_products = db.query(Product).filter(Product.is_active == True).count()
    return {
        "total_users": total_users,
        "total_orders": total_orders,
        "total_revenue": float(total_revenue),
        "total_practitioner_sessions": total_sessions,
        "total_products": total_products,
    }


@router.get("/users")
def list_users(
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db_session),
    current_user: User = Depends(require_role(UserRole.admin)),
):
    total = db.query(User).count()
    users = db.query(User).offset((page - 1) * page_size).limit(page_size).all()
    return {
        "users": [
            {
                "id": u.id,
                "email": u.email,
                "name": u.name,
                "role": u.role.value if hasattr(u.role, "value") else u.role,
                "is_active": u.is_active,
                "created_at": str(u.created_at) if hasattr(u, "created_at") else None,
            }
            for u in users
        ],
        "total": total,
        "page": page,
        "page_size": page_size,
    }


@router.get("/stats")
def admin_stats(
    db: Session = Depends(get_db_session),
    current_user: User = Depends(require_role(UserRole.admin)),
):
    from app.db.models import DailyCheckin, SkinLog
    return {
        "total_checkins": db.query(DailyCheckin).count(),
        "total_skin_logs": db.query(SkinLog).count(),
        "active_users": db.query(User).filter(User.is_active == True, User.role == UserRole.user).count(),
    }
