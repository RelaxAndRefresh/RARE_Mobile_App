from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.routine import RoutineCreate, RoutineResponse, RoutineInterventionResponse
from app.services import routine_service

router = APIRouter(prefix="/routine", tags=["Routine"])


@router.post("/", status_code=201)
def create_routine(data: RoutineCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    routine = routine_service.create_routine(db, current_user.id, data.model_dump())
    return routine


@router.get("/")
def get_routines(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    routines = routine_service.get_routines(db, current_user.id)
    return {"routines": routines}


@router.put("/{routine_id}")
def update_routine(routine_id: int, data: dict, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    routine = routine_service.update_routine(db, current_user.id, routine_id, data)
    return routine


@router.get("/interventions")
def get_interventions(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    interventions = routine_service.get_interventions(db, current_user.id)
    return {"interventions": interventions}
