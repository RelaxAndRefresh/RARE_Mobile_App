from datetime import datetime
import hashlib
import hmac
import secrets

from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.exceptions import NotFoundError, ValidationError
from app.db.models import Product, Cart, CartItem, Order, OrderItem, OrderStatus, Payment, PaymentStatus


def get_products(db: Session, category: str = None, page: int = 1, page_size: int = 20) -> dict:
    query = db.query(Product).filter(Product.is_active == True)
    if category:
        query = query.filter(Product.category == category)
    total = query.count()
    products = query.offset((page - 1) * page_size).limit(page_size).all()
    return {"products": products, "total": total}


def get_product(db: Session, product_id: int) -> Product:
    product = db.query(Product).filter(Product.id == product_id, Product.is_active == True).first()
    if not product:
        raise NotFoundError("Product not found")
    return product


def get_or_create_cart(db: Session, user_id: int) -> Cart:
    cart = db.query(Cart).filter(Cart.user_id == user_id).first()
    if not cart:
        cart = Cart(user_id=user_id)
        db.add(cart)
        db.commit()
        db.refresh(cart)
    return cart


def add_to_cart(db: Session, user_id: int, product_id: int, quantity: int = 1) -> Cart:
    product = get_product(db, product_id)
    cart = get_or_create_cart(db, user_id)
    existing_item = db.query(CartItem).filter(
        CartItem.cart_id == cart.id, CartItem.product_id == product_id
    ).first()
    if existing_item:
        existing_item.quantity += quantity
    else:
        item = CartItem(cart_id=cart.id, product_id=product_id, quantity=quantity)
        db.add(item)
    db.commit()
    db.refresh(cart)
    return cart


def remove_from_cart(db: Session, user_id: int, item_id: int) -> Cart:
    cart = get_or_create_cart(db, user_id)
    item = db.query(CartItem).filter(CartItem.id == item_id, CartItem.cart_id == cart.id).first()
    if item:
        db.delete(item)
        db.commit()
        db.refresh(cart)
    return cart


def checkout(db: Session, user_id: int, shipping_address: dict, payment_method: str = "razorpay") -> dict:
    cart = get_or_create_cart(db, user_id)
    if not cart.items:
        raise ValidationError("Cart is empty")

    subtotal = 0
    order_items = []
    for cart_item in cart.items:
        product = db.query(Product).filter(Product.id == cart_item.product_id).first()
        if not product or product.stock_quantity < cart_item.quantity:
            raise ValidationError(f"Insufficient stock for {product.name if product else 'product'}")
        item_total = float(product.price_inr) * cart_item.quantity
        subtotal += item_total
        order_items.append({
            "product_id": product.id,
            "quantity": cart_item.quantity,
            "unit_price_inr": float(product.price_inr),
            "total_price_inr": item_total,
        })

    tax = round(subtotal * 0.18, 2)
    shipping = 0 if subtotal >= 500 else 49
    total = subtotal + tax + shipping

    order_number = f"RARE-{secrets.token_hex(4).upper()}-{int(datetime.utcnow().timestamp())}"
    order = Order(
        user_id=user_id,
        order_number=order_number,
        status=OrderStatus.pending,
        subtotal_inr=subtotal,
        shipping_inr=shipping,
        tax_inr=tax,
        total_inr=total,
        shipping_address=shipping_address,
    )
    db.add(order)
    db.flush()

    for oi in order_items:
        db.add(OrderItem(order_id=order.id, **oi))
        product = db.query(Product).filter(Product.id == oi["product_id"]).first()
        product.stock_quantity -= oi["quantity"]

    for ci in cart.items:
        db.delete(ci)

    db.commit()
    db.refresh(order)

    payment_order_id = None
    if payment_method == "razorpay" and settings.RAZORPAY_KEY_ID:
        payment_order_id = f"order_{secrets.token_hex(12)}"

    return {"order": order, "payment_order_id": payment_order_id}


def verify_payment(db: Session, user_id: int, order_id: int, payment_id: str, signature: str) -> Payment:
    order = db.query(Order).filter(Order.id == order_id, Order.user_id == user_id).first()
    if not order:
        raise NotFoundError("Order not found")

    if settings.RAZORPAY_KEY_SECRET:
        generated = hmac.new(
            settings.RAZORPAY_KEY_SECRET.encode(),
            f"{order.payment_order_id or ''}|{payment_id}".encode(),
            hashlib.sha256,
        ).hexdigest()
        if generated != signature:
            raise ValidationError("Payment signature verification failed")

    payment = db.query(Payment).filter(Payment.order_id == order_id).first()
    if not payment:
        payment = Payment(
            order_id=order_id,
            user_id=user_id,
            provider="razorpay",
            payment_order_id=order.payment_order_id,
            payment_id=payment_id,
            signature=signature,
            amount_inr=order.total_inr,
            status=PaymentStatus.captured,
            verified_at=datetime.utcnow(),
        )
        db.add(payment)
    else:
        payment.payment_id = payment_id
        payment.signature = signature
        payment.status = PaymentStatus.captured
        payment.verified_at = datetime.utcnow()

    order.status = OrderStatus.confirmed
    db.commit()
    db.refresh(payment)
    return payment
