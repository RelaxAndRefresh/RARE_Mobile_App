import enum
from datetime import datetime, date
from sqlalchemy import (
    Column, Integer, String, Text, Float, Boolean, DateTime, Date, ForeignKey, JSON, Enum, Index, Numeric
)
from sqlalchemy.orm import relationship

from app.db.base import Base


class UserRole(str, enum.Enum):
    user = "user"
    practitioner = "practitioner"
    admin = "admin"
    partner = "partner"


class OnboardingStep(str, enum.Enum):
    welcome = "welcome"
    skin_scan = "skin_scan"
    privacy_consent = "privacy_consent"
    cycle_baseline = "cycle_baseline"
    wearable = "wearable"
    complete = "complete"


class CheckinType(str, enum.Enum):
    am = "am"
    pm = "pm"


class CycleEventType(str, enum.Enum):
    period_start = "period_start"
    period_end = "period_end"
    ovulation = "ovulation"
    spotting = "spotting"


class ShelfStatus(str, enum.Enum):
    standard = "standard"
    armed = "armed"
    depleted = "depleted"


class RoutineType(str, enum.Enum):
    am = "am"
    pm = "pm"
    both = "both"


class InterventionType(str, enum.Enum):
    algorithm = "algorithm"
    auto_swap = "auto_swap"
    practitioner = "practitioner"
    manual_edit = "manual_edit"


class InsightType(str, enum.Enum):
    biweekly = "biweekly"
    monthly = "monthly"
    pulse = "pulse"


class PrivacyCategory(str, enum.Enum):
    phone_activity = "phone_activity"
    pin_code = "pin_code"
    cycle_tracking = "cycle_tracking"
    skin_photos = "skin_photos"
    purchase_history = "purchase_history"
    wearable_data = "wearable_data"


class OrderStatus(str, enum.Enum):
    pending = "pending"
    confirmed = "confirmed"
    processing = "processing"
    shipped = "shipped"
    delivered = "delivered"
    cancelled = "cancelled"


class PaymentStatus(str, enum.Enum):
    pending = "pending"
    captured = "captured"
    failed = "failed"
    refunded = "refunded"


class CreditTransactionType(str, enum.Enum):
    credit = "credit"
    debit = "debit"


class SupportStatus(str, enum.Enum):
    open = "open"
    in_progress = "in_progress"
    resolved = "resolved"
    closed = "closed"


class LegalDocType(str, enum.Enum):
    privacy_policy = "privacy_policy"
    terms = "terms"


# ─── User ────────────────────────────────────────────────
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=True)
    phone = Column(String(20), unique=True, index=True, nullable=True)
    name = Column(String(255), nullable=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.user, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    is_anonymous = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    profile = relationship("UserProfile", back_populates="user", uselist=False)
    refresh_tokens = relationship("RefreshToken", back_populates="user")
    onboarding = relationship("OnboardingProgress", back_populates="user", uselist=False)
    privacy_consents = relationship("PrivacyConsent", back_populates="user")
    soft_scans = relationship("SoftScan", back_populates="user")
    daily_checkins = relationship("DailyCheckin", back_populates="user")
    hydration_logs = relationship("HydrationLog", back_populates="user")
    skin_logs = relationship("SkinLog", back_populates="user")
    skin_photos = relationship("SkinPhoto", back_populates="user")
    cycle_events = relationship("CycleEvent", back_populates="user")
    wearable_syncs = relationship("WearableSync", back_populates="user")
    shelf_items = relationship("ShelfItem", back_populates="user")
    routines = relationship("Routine", back_populates="user")
    routine_interventions = relationship("RoutineIntervention", back_populates="user")
    insights = relationship("Insight", back_populates="user")
    environmental_data = relationship("EnvironmentalData", back_populates="user")
    cart = relationship("Cart", back_populates="user", uselist=False)
    orders = relationship("Order", back_populates="user")
    payments = relationship("Payment", back_populates="user")
    credit_balance = relationship("CreditBalance", back_populates="user", uselist=False)
    credit_transactions = relationship("CreditTransaction", back_populates="user")
    notifications = relationship("Notification", back_populates="user")
    support_tickets = relationship("SupportTicket", back_populates="user")
    privacy_audit_logs = relationship("PrivacyAuditLog", back_populates="user")


# ─── UserProfile ─────────────────────────────────────────
class UserProfile(Base):
    __tablename__ = "user_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    skin_type = Column(String(50), nullable=True)
    barrier_status = Column(String(50), nullable=True)
    hydration_index = Column(Float, nullable=True)
    barrier_function = Column(Float, nullable=True)
    sebum_balance = Column(Float, nullable=True)
    sensitivity_score = Column(Float, nullable=True)
    cycle_length = Column(Integer, nullable=True)
    last_period_start = Column(Date, nullable=True)
    wearable_provider = Column(String(50), nullable=True)
    wearable_device_id = Column(String(255), nullable=True)
    last_wearable_sync = Column(DateTime, nullable=True)
    pincode = Column(String(10), nullable=True, index=True)
    city = Column(String(100), nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="profile")


# ─── RefreshToken ────────────────────────────────────────
class RefreshToken(Base):
    __tablename__ = "refresh_tokens"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    token = Column(String(500), unique=True, nullable=False, index=True)
    expires_at = Column(DateTime, nullable=False)
    revoked = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="refresh_tokens")


# ─── OnboardingProgress ──────────────────────────────────
class OnboardingProgress(Base):
    __tablename__ = "onboarding_progress"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    current_step = Column(Enum(OnboardingStep), default=OnboardingStep.welcome, nullable=False)
    completed_steps = Column(JSON, default=list, nullable=False)
    is_complete = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="onboarding")


# ─── PrivacyConsent ──────────────────────────────────────
class PrivacyConsent(Base):
    __tablename__ = "privacy_consents"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    category = Column(Enum(PrivacyCategory), nullable=False)
    consented = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="privacy_consents")


# ─── SoftScan ────────────────────────────────────────────
class SoftScan(Base):
    __tablename__ = "soft_scans"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    skin_type = Column(String(50), nullable=True)
    barrier_status = Column(String(50), nullable=True)
    adaptive_tags = Column(JSON, default=list)
    scan_metadata = Column(JSON, default=dict)
    confidence = Column(Float, nullable=True)
    is_manual_fallback = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="soft_scans")


# ─── DailyCheckin ────────────────────────────────────────
class DailyCheckin(Base):
    __tablename__ = "daily_checkins"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    checkin_type = Column(Enum(CheckinType), nullable=False)
    date = Column(Date, nullable=False, index=True)
    sleep_hours = Column(Float, nullable=True)
    mood = Column(Integer, nullable=True)
    energy = Column(Integer, nullable=True)
    stress = Column(Integer, nullable=True)
    skin_feel = Column(String(50), nullable=True)
    tags = Column(JSON, default=list)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="daily_checkins")


# ─── HydrationLog ────────────────────────────────────────
class HydrationLog(Base):
    __tablename__ = "hydration_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    date = Column(Date, nullable=False, index=True)
    volume_ml = Column(Integer, default=0)
    tap_count = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="hydration_logs")


# ─── SkinLog ─────────────────────────────────────────────
class SkinLog(Base):
    __tablename__ = "skin_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    tags = Column(JSON, default=list)
    notes = Column(Text, nullable=True)
    rating = Column(Integer, nullable=True)
    photo_url = Column(String(500), nullable=True)
    photo_key = Column(String(500), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="skin_logs")
    photos = relationship("SkinPhoto", back_populates="skin_log")


# ─── SkinPhoto ───────────────────────────────────────────
class SkinPhoto(Base):
    __tablename__ = "skin_photos"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    skin_log_id = Column(Integer, ForeignKey("skin_logs.id", ondelete="SET NULL"), nullable=True)
    file_key = Column(String(500), nullable=False)
    file_url = Column(String(500), nullable=True)
    tags = Column(JSON, default=list)
    is_deleted = Column(Boolean, default=False)
    deleted_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="skin_photos")
    skin_log = relationship("SkinLog", back_populates="photos")


# ─── CycleEvent ──────────────────────────────────────────
class CycleEvent(Base):
    __tablename__ = "cycle_events"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    event_type = Column(Enum(CycleEventType), nullable=False)
    date = Column(Date, nullable=False, index=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="cycle_events")


# ─── WearableSync ────────────────────────────────────────
class WearableSync(Base):
    __tablename__ = "wearable_syncs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    provider = Column(String(50), nullable=False)
    device_id = Column(String(255), nullable=False)
    metric_type = Column(String(50), nullable=False)
    value = Column(Float, nullable=False)
    unit = Column(String(20), nullable=False)
    recorded_at = Column(DateTime, nullable=False)
    synced_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="wearable_syncs")


# ─── ShelfItem ───────────────────────────────────────────
class ShelfItem(Base):
    __tablename__ = "shelf_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="SET NULL"), nullable=True)
    status = Column(Enum(ShelfStatus), default=ShelfStatus.standard, nullable=False)
    depletion_estimate_days = Column(Integer, nullable=True)
    last_restocked = Column(DateTime, nullable=True)
    auto_swap_enabled = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="shelf_items")
    product = relationship("Product")


# ─── Product ─────────────────────────────────────────────
class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    brand = Column(String(255), nullable=True)
    description = Column(Text, nullable=True)
    category = Column(String(100), nullable=True, index=True)
    price_inr = Column(Numeric(10, 2), nullable=False)
    image_url = Column(String(500), nullable=True)
    stock_quantity = Column(Integer, default=0)
    is_active = Column(Boolean, default=True, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)


# ─── Routine ─────────────────────────────────────────────
class Routine(Base):
    __tablename__ = "routines"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    name = Column(String(255), nullable=False)
    routine_type = Column(Enum(RoutineType), default=RoutineType.both, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="routines")
    steps = relationship("RoutineStep", back_populates="routine", order_by="RoutineStep.step_order")


# ─── RoutineStep ─────────────────────────────────────────
class RoutineStep(Base):
    __tablename__ = "routine_steps"

    id = Column(Integer, primary_key=True, index=True)
    routine_id = Column(Integer, ForeignKey("routines.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="SET NULL"), nullable=True)
    step_order = Column(Integer, nullable=False)
    step_name = Column(String(255), nullable=False)
    instruction = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    routine = relationship("Routine", back_populates="steps")
    product = relationship("Product")


# ─── RoutineIntervention ─────────────────────────────────
class RoutineIntervention(Base):
    __tablename__ = "routine_interventions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    routine_id = Column(Integer, ForeignKey("routines.id", ondelete="SET NULL"), nullable=True)
    intervention_type = Column(Enum(InterventionType), nullable=False)
    description = Column(Text, nullable=False)
    reason = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="routine_interventions")
    routine = relationship("Routine")


# ─── Insight ─────────────────────────────────────────────
class Insight(Base):
    __tablename__ = "insights"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    insight_type = Column(Enum(InsightType), nullable=False, index=True)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=False)
    variable_a = Column(String(100), nullable=True)
    variable_b = Column(String(100), nullable=True)
    observation_count = Column(Integer, default=0)
    confidence = Column(Float, nullable=True)
    tier = Column(String(50), nullable=True)
    claim = Column(Text, nullable=True)
    confound = Column(Text, nullable=True)
    is_active = Column(Boolean, default=True)
    period_start = Column(Date, nullable=True)
    period_end = Column(Date, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="insights")


# ─── EnvironmentalData ───────────────────────────────────
class EnvironmentalData(Base):
    __tablename__ = "environmental_data"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    pincode = Column(String(10), nullable=True, index=True)
    city = Column(String(100), nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    aqi = Column(Integer, nullable=True)
    pm25 = Column(Float, nullable=True)
    pm10 = Column(Float, nullable=True)
    humidity = Column(Float, nullable=True)
    uv_index = Column(Float, nullable=True)
    monitoring_coverage = Column(String(50), nullable=True)
    recorded_at = Column(DateTime, nullable=False, index=True)
    cached_until = Column(DateTime, nullable=True)

    user = relationship("User", back_populates="environmental_data")


# ─── Cart ────────────────────────────────────────────────
class Cart(Base):
    __tablename__ = "carts"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="cart")
    items = relationship("CartItem", back_populates="cart")


# ─── CartItem ────────────────────────────────────────────
class CartItem(Base):
    __tablename__ = "cart_items"

    id = Column(Integer, primary_key=True, index=True)
    cart_id = Column(Integer, ForeignKey("carts.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, default=1, nullable=False)
    added_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    cart = relationship("Cart", back_populates="items")
    product = relationship("Product")


# ─── Order ───────────────────────────────────────────────
class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    order_number = Column(String(50), unique=True, nullable=False, index=True)
    status = Column(Enum(OrderStatus), default=OrderStatus.pending, nullable=False, index=True)
    subtotal_inr = Column(Numeric(10, 2), nullable=False)
    shipping_inr = Column(Numeric(10, 2), default=0)
    tax_inr = Column(Numeric(10, 2), default=0)
    total_inr = Column(Numeric(10, 2), nullable=False)
    shipping_address = Column(JSON, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="orders")
    items = relationship("OrderItem", back_populates="order")
    payment = relationship("Payment", back_populates="order", uselist=False)


# ─── OrderItem ───────────────────────────────────────────
class OrderItem(Base):
    __tablename__ = "order_items"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False, index=True)
    product_id = Column(Integer, ForeignKey("products.id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price_inr = Column(Numeric(10, 2), nullable=False)
    total_price_inr = Column(Numeric(10, 2), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    order = relationship("Order", back_populates="items")
    product = relationship("Product")


# ─── Payment ─────────────────────────────────────────────
class Payment(Base):
    __tablename__ = "payments"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    provider = Column(String(50), nullable=False)
    payment_order_id = Column(String(255), nullable=True)
    payment_id = Column(String(255), nullable=True)
    signature = Column(String(500), nullable=True)
    amount_inr = Column(Numeric(10, 2), nullable=False)
    currency = Column(String(10), default="INR")
    status = Column(Enum(PaymentStatus), default=PaymentStatus.pending, nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    verified_at = Column(DateTime, nullable=True)

    order = relationship("Order", back_populates="payment")
    user = relationship("User", back_populates="payments")


# ─── CreditBalance ───────────────────────────────────────
class CreditBalance(Base):
    __tablename__ = "credit_balances"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True)
    balance = Column(Integer, default=0, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="credit_balance")


# ─── CreditTransaction ───────────────────────────────────
class CreditTransaction(Base):
    __tablename__ = "credit_transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    amount = Column(Integer, nullable=False)
    transaction_type = Column(Enum(CreditTransactionType), nullable=False)
    reason = Column(String(255), nullable=True)
    reference_type = Column(String(50), nullable=True)
    reference_id = Column(Integer, nullable=True)
    balance_after = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="credit_transactions")


# ─── Notification ────────────────────────────────────────
class Notification(Base):
    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    notification_type = Column(String(50), nullable=False)
    title = Column(String(255), nullable=False)
    body = Column(Text, nullable=False)
    target_screen = Column(String(100), nullable=True)
    payload = Column(JSON, nullable=True)
    is_read = Column(Boolean, default=False)
    expires_at = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="notifications")


# ─── SupportTicket ───────────────────────────────────────
class SupportTicket(Base):
    __tablename__ = "support_tickets"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    subject = Column(String(255), nullable=False)
    description = Column(Text, nullable=False)
    status = Column(Enum(SupportStatus), default=SupportStatus.open, nullable=False, index=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="support_tickets")
    messages = relationship("SupportMessage", back_populates="ticket")


# ─── SupportMessage ──────────────────────────────────────
class SupportMessage(Base):
    __tablename__ = "support_messages"

    id = Column(Integer, primary_key=True, index=True)
    ticket_id = Column(Integer, ForeignKey("support_tickets.id", ondelete="CASCADE"), nullable=False, index=True)
    sender_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    message = Column(Text, nullable=False)
    attachment_url = Column(String(500), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    ticket = relationship("SupportTicket", back_populates="messages")
    sender = relationship("User")


# ─── PractitionerClient ──────────────────────────────────
class PractitionerClient(Base):
    __tablename__ = "practitioner_clients"

    id = Column(Integer, primary_key=True, index=True)
    practitioner_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    client_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    practitioner = relationship("User", foreign_keys=[practitioner_id])
    client = relationship("User", foreign_keys=[client_id])


# ─── TreatmentSession ────────────────────────────────────
class TreatmentSession(Base):
    __tablename__ = "treatment_sessions"

    id = Column(Integer, primary_key=True, index=True)
    practitioner_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    client_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    session_type = Column(String(100), nullable=False)
    pre_treatment_notes = Column(Text, nullable=True)
    post_treatment_notes = Column(Text, nullable=True)
    protocol = Column(JSON, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    practitioner = relationship("User", foreign_keys=[practitioner_id])
    client = relationship("User", foreign_keys=[client_id])


# ─── LegalDocument ───────────────────────────────────────
class LegalDocument(Base):
    __tablename__ = "legal_documents"

    id = Column(Integer, primary_key=True, index=True)
    document_type = Column(Enum(LegalDocType), nullable=False)
    version = Column(String(20), nullable=False)
    content = Column(Text, nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)


# ─── PrivacyAuditLog ─────────────────────────────────────
class PrivacyAuditLog(Base):
    __tablename__ = "privacy_audit_logs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    action = Column(String(100), nullable=False)
    details = Column(JSON, nullable=True)
    ip_address = Column(String(50), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    user = relationship("User", back_populates="privacy_audit_logs")
