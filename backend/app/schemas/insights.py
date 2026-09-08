from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime


class InsightResponse(BaseModel):
    id: int
    insight_type: str
    title: str
    body: str
    variable_a: Optional[str] = None
    variable_b: Optional[str] = None
    observation_count: int = 0
    confidence: Optional[float] = None
    tier: Optional[str] = None
    claim: Optional[str] = None
    confound: Optional[str] = None
    period_start: Optional[date] = None
    period_end: Optional[date] = None
    created_at: datetime

    class Config:
        from_attributes = True


class BiweeklyInsightResponse(BaseModel):
    insights: List[InsightResponse]
    period_start: date
    period_end: date


class MonthlyInsightResponse(BaseModel):
    insights: List[InsightResponse]
    month: str


class PulseFeedResponse(BaseModel):
    insights: List[InsightResponse]
    total: int
