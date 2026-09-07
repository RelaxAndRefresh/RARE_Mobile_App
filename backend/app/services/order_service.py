from sqlalchemy.orm import Session

from app.db.models import Order


def get_orders(db: Session, user_id: int, page: int = 1, page_size: int = 20) -> dict:
    query = db.query(Order).filter(Order.user_id == user_id)
    total = query.count()
    orders = query.order_by(Order.created_at.desc()).offset((page - 1) * page_size).limit(page_size).all()
    return {"orders": orders, "total": total}


def get_order_detail(db: Session, user_id: int, order_id: int) -> Order:
    from app.core.exceptions import NotFoundError
    order = db.query(Order).filter(Order.id == order_id, Order.user_id == user_id).first()
    if not order:
        raise NotFoundError("Order not found")
    return order
