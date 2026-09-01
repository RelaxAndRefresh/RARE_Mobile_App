from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User

router = APIRouter(prefix="/rituals", tags=["Rituals"])


@router.get("/featured")
def get_featured(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {
        "featured": [
            {"id": 1, "name": "Morning Glow Ritual", "description": "A 5-step AM routine for radiant skin", "duration": "15 min", "category": "glow"},
            {"id": 2, "name": "Night Repair Ritual", "description": "An intensive PM routine for skin repair", "duration": "20 min", "category": "repair"},
            {"id": 3, "name": "Hydration Boost", "description": "Quick hydration ritual for dry skin days", "duration": "10 min", "category": "hydration"},
        ]
    }


@router.get("/library")
def get_library(page: int = 1, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {
        "rituals": [
            {"id": 1, "name": "Cleansing Ritual", "category": "cleansing"},
            {"id": 2, "name": "Toning Ritual", "category": "toning"},
            {"id": 3, "name": "Moisturizing Ritual", "category": "moisturizing"},
            {"id": 4, "name": "Sun Protection Ritual", "category": "protection"},
        ],
        "total": 4,
        "page": page,
    }
