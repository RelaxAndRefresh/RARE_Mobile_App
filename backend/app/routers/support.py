from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, SupportTicket, SupportMessage, SupportStatus
from app.schemas.support import SupportTicketCreate, SupportMessageCreate
from app.core.exceptions import NotFoundError

router = APIRouter(prefix="/support", tags=["Support"])


@router.post("/tickets", status_code=201)
def create_ticket(data: SupportTicketCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    ticket = SupportTicket(
        user_id=current_user.id,
        subject=data.subject,
        description=data.description,
    )
    db.add(ticket)
    db.commit()
    db.refresh(ticket)
    return ticket


@router.get("/tickets")
def get_tickets(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    tickets = db.query(SupportTicket).filter(
        SupportTicket.user_id == current_user.id
    ).order_by(SupportTicket.created_at.desc()).all()
    return {"tickets": tickets}


@router.post("/tickets/{ticket_id}/messages", status_code=201)
def add_message(ticket_id: int, data: SupportMessageCreate, db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    ticket = db.query(SupportTicket).filter(
        SupportTicket.id == ticket_id, SupportTicket.user_id == current_user.id
    ).first()
    if not ticket:
        raise NotFoundError("Ticket not found")
    message = SupportMessage(
        ticket_id=ticket_id,
        sender_id=current_user.id,
        message=data.message,
        attachment_url=data.attachment_url,
    )
    db.add(message)
    if ticket.status == SupportStatus.open:
        ticket.status = SupportStatus.in_progress
    db.commit()
    db.refresh(message)
    return message
