from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User
from app.schemas.booking import BookingCreate
from app.services import booking_service

router = APIRouter(prefix="/bookings", tags=["Bookings"])


@router.get("/services")
def get_services(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return booking_service.get_services(db)


@router.get("/availability")
def get_availability(practitioner_id: int, date: str, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return booking_service.get_availability(db, practitioner_id, date)


@router.post("/")
def create_booking(data: BookingCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return booking_service.create_booking(db, current_user.id, data.model_dump())


@router.get("/")
def get_bookings(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return {"bookings": booking_service.get_bookings(db, current_user.id)}


@router.put("/{booking_id}/cancel")
def cancel_booking(booking_id: int, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    return booking_service.cancel_booking(db, current_user.id, booking_id)
