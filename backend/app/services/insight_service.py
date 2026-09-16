from datetime import date, timedelta
from sqlalchemy.orm import Session

from app.db.models import Insight, InsightType


def _serialize_insight(insight: Insight) -> dict:
    return {
        "id": insight.id,
        "user_id": insight.user_id,
        "type": insight.insight_type.value if hasattr(insight.insight_type, "value") else insight.insight_type,
        "title": insight.title,
        "summary": insight.body,
        "data": {
            "confidence": insight.confidence,
            "tier": insight.tier,
            "claim": insight.claim,
            "confound": insight.confound,
            "variable_a": insight.variable_a,
            "variable_b": insight.variable_b,
            "observation_count": insight.observation_count,
        },
        "period_start": str(insight.period_start) if insight.period_start else None,
        "period_end": str(insight.period_end) if insight.period_end else None,
        "created_at": str(insight.created_at) if insight.created_at else None,
    }


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
    return {"insights": [_serialize_insight(i) for i in insights], "period_start": str(period_start), "period_end": str(period_end)}


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
    return {"insights": [_serialize_insight(i) for i in insights], "month": month_start.strftime("%Y-%m")}


def get_pulse_feed(db: Session, user_id: int, limit: int = 20) -> dict:
    insights = db.query(Insight).filter(
        Insight.user_id == user_id,
        Insight.insight_type == InsightType.pulse,
        Insight.is_active == True,
    ).order_by(Insight.created_at.desc()).limit(limit).all()
    return {"insights": [_serialize_insight(i) for i in insights], "total": len(insights)}
