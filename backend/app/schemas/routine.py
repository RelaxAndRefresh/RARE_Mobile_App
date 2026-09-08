from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class RoutineStepCreate(BaseModel):
    product_id: Optional[int] = None
    step_order: int
    step_name: str
    instruction: Optional[str] = None


class RoutineCreate(BaseModel):
    name: str
    routine_type: str = "both"
    steps: List[RoutineStepCreate] = []


class RoutineUpdate(BaseModel):
    name: Optional[str] = None
    routine_type: Optional[str] = None
    is_active: Optional[bool] = None


class RoutineResponse(BaseModel):
    id: int
    name: str
    routine_type: str
    is_active: bool
    steps: List[dict] = []
    created_at: datetime

    class Config:
        from_attributes = True


class RoutineInterventionResponse(BaseModel):
    id: int
    intervention_type: str
    description: str
    reason: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True
