from sqlalchemy.orm import Session

from app.core.exceptions import NotFoundError
from app.db.models import Routine, RoutineStep, RoutineIntervention


def create_routine(db: Session, user_id: int, data: dict) -> Routine:
    routine = Routine(
        user_id=user_id,
        name=data["name"],
        routine_type=data.get("routine_type", "both"),
    )
    db.add(routine)
    db.flush()
    for step_data in data.get("steps", []):
        step = RoutineStep(
            routine_id=routine.id,
            product_id=step_data.get("product_id"),
            step_order=step_data["step_order"],
            step_name=step_data["step_name"],
            instruction=step_data.get("instruction"),
        )
        db.add(step)
    db.commit()
    db.refresh(routine)
    return routine


def get_routines(db: Session, user_id: int) -> list:
    return db.query(Routine).filter(Routine.user_id == user_id).order_by(Routine.created_at.desc()).all()


def get_routine(db: Session, user_id: int, routine_id: int) -> Routine:
    routine = db.query(Routine).filter(Routine.id == routine_id, Routine.user_id == user_id).first()
    if not routine:
        raise NotFoundError("Routine not found")
    return routine


def update_routine(db: Session, user_id: int, routine_id: int, data: dict) -> Routine:
    routine = get_routine(db, user_id, routine_id)
    if "name" in data:
        routine.name = data["name"]
    if "routine_type" in data:
        routine.routine_type = data["routine_type"]
    if "is_active" in data:
        routine.is_active = data["is_active"]
    db.commit()
    db.refresh(routine)
    return routine


def get_interventions(db: Session, user_id: int) -> list:
    return db.query(RoutineIntervention).filter(
        RoutineIntervention.user_id == user_id
    ).order_by(RoutineIntervention.created_at.desc()).all()
