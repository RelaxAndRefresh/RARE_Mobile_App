from datetime import date, timedelta
from sqlalchemy.orm import Session

from app.db.models import Insight, InsightType


def get_biweekly(db: Session, user_id: int) -> dict:
    today = date.today()
    period_end = today
    period_start = today - timedelta(days=14)
    insights = db.query(Insight).filter(
        Insight.user_id == user_id,
        Insight.insight_type == InsightType.biweekly,
        Insight.is_active == True,
        Insight.period_start >= period_start,
        Insight.period_end <= period_end,
    ).order_by(Insight.created_at.desc()).all()
    return {"insights": insights, "period_start": period_start, "period_end": period_end}


def get_monthly(db: Session, user_id: int) -> dict:
    today = date.today()
    month_start = today.replace(day=1)
    if today.month == 12:
        month_end = today.replace(year=today.year + 1, month=1, day=1) - timedelta(days=1)
    else:
        month_end = today.replace(month=today.month + 1, day=1) - timedelta(days=1)
    insights = db.query(Insight).filter(
        Insight.user_id == user_id,
        Insight.insight_type == InsightType.monthly,
        Insight.is_active == True,
        Insight.period_start >= month_start,
        Insight.period_end <= month_end,
    ).order_by(Insight.created_at.desc()).all()
    return {"insights": insights, "month": month_start.strftime("%Y-%m")}


def get_pulse_feed(db: Session, user_id: int, limit: int = 20) -> dict:
    insights = db.query(Insight).filter(
        Insight.user_id == user_id,
        Insight.insight_type == InsightType.pulse,
        Insight.is_active == True,
    ).order_by(Insight.created_at.desc()).limit(limit).all()
    return {"insights": insights, "total": len(insights)}
