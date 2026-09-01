from pydantic import BaseModel
from typing import List
from datetime import datetime


class CreditBalanceResponse(BaseModel):
    balance: int
    updated_at: datetime

    class Config:
        from_attributes = True


class CreditTransactionResponse(BaseModel):
    id: int
    amount: int
    transaction_type: str
    reason: str = ""
    balance_after: int
    created_at: datetime

    class Config:
        from_attributes = True
