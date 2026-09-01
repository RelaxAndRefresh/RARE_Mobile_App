from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_db_session, get_current_active_user
from app.db.models import User, CreditBalance, CreditTransaction
from app.schemas.credits import CreditBalanceResponse, CreditTransactionResponse

router = APIRouter(prefix="/credits", tags=["Credits"])


@router.get("/balance")
def get_balance(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    balance = db.query(CreditBalance).filter(CreditBalance.user_id == current_user.id).first()
    if not balance:
        balance = CreditBalance(user_id=current_user.id, balance=0)
        db.add(balance)
        db.commit()
        db.refresh(balance)
    return {"balance": balance.balance, "updated_at": str(balance.updated_at)}


@router.get("/transactions")
def get_transactions(db: Session = Depends(get_db_session), current_user: User = Depends(get_current_active_user)):
    transactions = db.query(CreditTransaction).filter(
        CreditTransaction.user_id == current_user.id
    ).order_by(CreditTransaction.created_at.desc()).limit(50).all()
    return {"transactions": transactions}
