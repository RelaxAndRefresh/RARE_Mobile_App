"""initial schema

Revision ID: 001
Revises:
Create Date: 2024-01-01 00:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = "001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    userrole = sa.Enum("user", "practitioner", "admin", "partner", name="userrole", create_type=False)
    userrole.create(op.get_bind(), checkfirst=True)

    onboardingstep = sa.Enum(
        "welcome", "skin_scan", "privacy_consent", "cycle_baseline", "wearable", "complete",
        name="onboardingstep", create_type=False,
    )
    onboardingstep.create(op.get_bind(), checkfirst=True)

    checkintype = sa.Enum("am", "pm", name="checkintype", create_type=False)
    checkintype.create(op.get_bind(), checkfirst=True)

    cycleeventtype = sa.Enum("period_start", "period_end", "ovulation", "spotting", name="cycleeventtype", create_type=False)
    cycleeventtype.create(op.get_bind(), checkfirst=True)

    shelfstatus = sa.Enum("standard", "armed", "depleted", name="shelfstatus", create_type=False)
    shelfstatus.create(op.get_bind(), checkfirst=True)

    routinetype = sa.Enum("am", "pm", "both", name="routinetype", create_type=False)
    routinetype.create(op.get_bind(), checkfirst=True)

    interventiontype = sa.Enum("algorithm", "auto_swap", "practitioner", "manual_edit", name="interventiontype", create_type=False)
    interventiontype.create(op.get_bind(), checkfirst=True)

    insighttype = sa.Enum("biweekly", "monthly", "pulse", name="insighttype", create_type=False)
    insighttype.create(op.get_bind(), checkfirst=True)

    privacycategory = sa.Enum(
        "phone_activity", "pin_code", "cycle_tracking", "skin_photos", "purchase_history", "wearable_data",
        name="privacycategory", create_type=False,
    )
    privacycategory.create(op.get_bind(), checkfirst=True)

    orderstatus = sa.Enum("pending", "confirmed", "processing", "shipped", "delivered", "cancelled", name="orderstatus", create_type=False)
    orderstatus.create(op.get_bind(), checkfirst=True)

    paymentstatus = sa.Enum("pending", "captured", "failed", "refunded", name="paymentstatus", create_type=False)
    paymentstatus.create(op.get_bind(), checkfirst=True)

    credittransactiontype = sa.Enum("credit", "debit", name="credittransactiontype", create_type=False)
    credittransactiontype.create(op.get_bind(), checkfirst=True)

    supportstatus = sa.Enum("open", "in_progress", "resolved", "closed", name="supportstatus", create_type=False)
    supportstatus.create(op.get_bind(), checkfirst=True)

    legaldocdoctype = sa.Enum("privacy_policy", "terms", name="legaldocdoctype", create_type=False)
    legaldocdoctype.create(op.get_bind(), checkfirst=True)

    # ── users ──
    op.create_table(
        "users",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("email", sa.String(255), unique=True, index=True, nullable=True),
        sa.Column("phone", sa.String(20), unique=True, index=True, nullable=True),
        sa.Column("name", sa.String(255), nullable=True),
        sa.Column("password_hash", sa.String(255), nullable=False),
        sa.Column("role", userrole, nullable=False, server_default="user"),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.text("true")),
        sa.Column("is_anonymous", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── user_profiles ──
    op.create_table(
        "user_profiles",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True),
        sa.Column("skin_type", sa.String(50), nullable=True),
        sa.Column("barrier_status", sa.String(50), nullable=True),
        sa.Column("hydration_index", sa.Float(), nullable=True),
        sa.Column("barrier_function", sa.Float(), nullable=True),
        sa.Column("sebum_balance", sa.Float(), nullable=True),
        sa.Column("sensitivity_score", sa.Float(), nullable=True),
        sa.Column("cycle_length", sa.Integer(), nullable=True),
        sa.Column("last_period_start", sa.Date(), nullable=True),
        sa.Column("wearable_provider", sa.String(50), nullable=True),
        sa.Column("wearable_device_id", sa.String(255), nullable=True),
        sa.Column("last_wearable_sync", sa.DateTime(), nullable=True),
        sa.Column("pincode", sa.String(10), nullable=True),
        sa.Column("city", sa.String(100), nullable=True),
        sa.Column("latitude", sa.Float(), nullable=True),
        sa.Column("longitude", sa.Float(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_user_profiles_pincode", "user_profiles", ["pincode"])

    # ── refresh_tokens ──
    op.create_table(
        "refresh_tokens",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("token", sa.String(500), unique=True, nullable=False, index=True),
        sa.Column("expires_at", sa.DateTime(), nullable=False),
        sa.Column("revoked", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── onboarding_progress ──
    op.create_table(
        "onboarding_progress",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True),
        sa.Column("current_step", onboardingstep, nullable=False, server_default="welcome"),
        sa.Column("completed_steps", sa.JSON(), nullable=False, server_default=sa.text("'[]'::json")),
        sa.Column("is_complete", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── privacy_consents ──
    op.create_table(
        "privacy_consents",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("category", privacycategory, nullable=False),
        sa.Column("consented", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── products ──
    op.create_table(
        "products",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("brand", sa.String(255), nullable=True),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("category", sa.String(100), nullable=True),
        sa.Column("price_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("image_url", sa.String(500), nullable=True),
        sa.Column("stock_quantity", sa.Integer(), server_default=sa.text("0")),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_products_category", "products", ["category"])

    # ── soft_scans ──
    op.create_table(
        "soft_scans",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("skin_type", sa.String(50), nullable=True),
        sa.Column("barrier_status", sa.String(50), nullable=True),
        sa.Column("adaptive_tags", sa.JSON(), server_default=sa.text("'[]'::json")),
        sa.Column("scan_metadata", sa.JSON(), server_default=sa.text("'{}'::json")),
        sa.Column("confidence", sa.Float(), nullable=True),
        sa.Column("is_manual_fallback", sa.Boolean(), server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── daily_checkins ──
    op.create_table(
        "daily_checkins",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("checkin_type", checkintype, nullable=False),
        sa.Column("date", sa.Date(), nullable=False, index=True),
        sa.Column("sleep_hours", sa.Float(), nullable=True),
        sa.Column("mood", sa.Integer(), nullable=True),
        sa.Column("energy", sa.Integer(), nullable=True),
        sa.Column("stress", sa.Integer(), nullable=True),
        sa.Column("skin_feel", sa.String(50), nullable=True),
        sa.Column("tags", sa.JSON(), server_default=sa.text("'[]'::json")),
        sa.Column("notes", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── hydration_logs ──
    op.create_table(
        "hydration_logs",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("date", sa.Date(), nullable=False, index=True),
        sa.Column("volume_ml", sa.Integer(), server_default=sa.text("0")),
        sa.Column("tap_count", sa.Integer(), server_default=sa.text("0")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── skin_logs ──
    op.create_table(
        "skin_logs",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("tags", sa.JSON(), server_default=sa.text("'[]'::json")),
        sa.Column("notes", sa.Text(), nullable=True),
        sa.Column("rating", sa.Integer(), nullable=True),
        sa.Column("photo_url", sa.String(500), nullable=True),
        sa.Column("photo_key", sa.String(500), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── skin_photos ──
    op.create_table(
        "skin_photos",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("skin_log_id", sa.Integer(), sa.ForeignKey("skin_logs.id", ondelete="SET NULL"), nullable=True),
        sa.Column("file_key", sa.String(500), nullable=False),
        sa.Column("file_url", sa.String(500), nullable=True),
        sa.Column("tags", sa.JSON(), server_default=sa.text("'[]'::json")),
        sa.Column("is_deleted", sa.Boolean(), server_default=sa.text("false")),
        sa.Column("deleted_at", sa.DateTime(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── cycle_events ──
    op.create_table(
        "cycle_events",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("event_type", cycleeventtype, nullable=False),
        sa.Column("date", sa.Date(), nullable=False, index=True),
        sa.Column("notes", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── wearable_syncs ──
    op.create_table(
        "wearable_syncs",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("provider", sa.String(50), nullable=False),
        sa.Column("device_id", sa.String(255), nullable=False),
        sa.Column("metric_type", sa.String(50), nullable=False),
        sa.Column("value", sa.Float(), nullable=False),
        sa.Column("unit", sa.String(20), nullable=False),
        sa.Column("recorded_at", sa.DateTime(), nullable=False),
        sa.Column("synced_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── shelf_items ──
    op.create_table(
        "shelf_items",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("product_id", sa.Integer(), sa.ForeignKey("products.id", ondelete="SET NULL"), nullable=True),
        sa.Column("status", shelfstatus, nullable=False, server_default="standard"),
        sa.Column("depletion_estimate_days", sa.Integer(), nullable=True),
        sa.Column("last_restocked", sa.DateTime(), nullable=True),
        sa.Column("auto_swap_enabled", sa.Boolean(), server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── routines ──
    op.create_table(
        "routines",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("name", sa.String(255), nullable=False),
        sa.Column("routine_type", routinetype, nullable=False, server_default="both"),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── routine_steps ──
    op.create_table(
        "routine_steps",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("routine_id", sa.Integer(), sa.ForeignKey("routines.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("product_id", sa.Integer(), sa.ForeignKey("products.id", ondelete="SET NULL"), nullable=True),
        sa.Column("step_order", sa.Integer(), nullable=False),
        sa.Column("step_name", sa.String(255), nullable=False),
        sa.Column("instruction", sa.Text(), nullable=True),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── routine_interventions ──
    op.create_table(
        "routine_interventions",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("routine_id", sa.Integer(), sa.ForeignKey("routines.id", ondelete="SET NULL"), nullable=True),
        sa.Column("intervention_type", interventiontype, nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("reason", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── insights ──
    op.create_table(
        "insights",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("insight_type", insighttype, nullable=False, index=True),
        sa.Column("title", sa.String(255), nullable=False),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("variable_a", sa.String(100), nullable=True),
        sa.Column("variable_b", sa.String(100), nullable=True),
        sa.Column("observation_count", sa.Integer(), server_default=sa.text("0")),
        sa.Column("confidence", sa.Float(), nullable=True),
        sa.Column("tier", sa.String(50), nullable=True),
        sa.Column("claim", sa.Text(), nullable=True),
        sa.Column("confound", sa.Text(), nullable=True),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true")),
        sa.Column("period_start", sa.Date(), nullable=True),
        sa.Column("period_end", sa.Date(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── environmental_data ──
    op.create_table(
        "environmental_data",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="SET NULL"), nullable=True),
        sa.Column("pincode", sa.String(10), nullable=True),
        sa.Column("city", sa.String(100), nullable=True),
        sa.Column("latitude", sa.Float(), nullable=True),
        sa.Column("longitude", sa.Float(), nullable=True),
        sa.Column("aqi", sa.Integer(), nullable=True),
        sa.Column("pm25", sa.Float(), nullable=True),
        sa.Column("pm10", sa.Float(), nullable=True),
        sa.Column("humidity", sa.Float(), nullable=True),
        sa.Column("uv_index", sa.Float(), nullable=True),
        sa.Column("monitoring_coverage", sa.String(50), nullable=True),
        sa.Column("recorded_at", sa.DateTime(), nullable=False, index=True),
        sa.Column("cached_until", sa.DateTime(), nullable=True),
    )
    op.create_index("ix_environmental_data_pincode", "environmental_data", ["pincode"])

    # ── carts ──
    op.create_table(
        "carts",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── cart_items ──
    op.create_table(
        "cart_items",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("cart_id", sa.Integer(), sa.ForeignKey("carts.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("product_id", sa.Integer(), sa.ForeignKey("products.id", ondelete="CASCADE"), nullable=False),
        sa.Column("quantity", sa.Integer(), nullable=False, server_default=sa.text("1")),
        sa.Column("added_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── orders ──
    op.create_table(
        "orders",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("order_number", sa.String(50), unique=True, nullable=False, index=True),
        sa.Column("status", orderstatus, nullable=False, server_default="pending", index=True),
        sa.Column("subtotal_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("shipping_inr", sa.Numeric(10, 2), server_default=sa.text("0")),
        sa.Column("tax_inr", sa.Numeric(10, 2), server_default=sa.text("0")),
        sa.Column("total_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("shipping_address", sa.JSON(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── order_items ──
    op.create_table(
        "order_items",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("order_id", sa.Integer(), sa.ForeignKey("orders.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("product_id", sa.Integer(), sa.ForeignKey("products.id", ondelete="CASCADE"), nullable=False),
        sa.Column("quantity", sa.Integer(), nullable=False),
        sa.Column("unit_price_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("total_price_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── payments ──
    op.create_table(
        "payments",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("order_id", sa.Integer(), sa.ForeignKey("orders.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("provider", sa.String(50), nullable=False),
        sa.Column("payment_order_id", sa.String(255), nullable=True),
        sa.Column("payment_id", sa.String(255), nullable=True),
        sa.Column("signature", sa.String(500), nullable=True),
        sa.Column("amount_inr", sa.Numeric(10, 2), nullable=False),
        sa.Column("currency", sa.String(10), server_default="INR"),
        sa.Column("status", paymentstatus, nullable=False, server_default="pending", index=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("verified_at", sa.DateTime(), nullable=True),
    )

    # ── credit_balances ──
    op.create_table(
        "credit_balances",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False, index=True),
        sa.Column("balance", sa.Integer(), nullable=False, server_default=sa.text("0")),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── credit_transactions ──
    op.create_table(
        "credit_transactions",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("amount", sa.Integer(), nullable=False),
        sa.Column("transaction_type", credittransactiontype, nullable=False),
        sa.Column("reason", sa.String(255), nullable=True),
        sa.Column("reference_type", sa.String(50), nullable=True),
        sa.Column("reference_id", sa.Integer(), nullable=True),
        sa.Column("balance_after", sa.Integer(), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── notifications ──
    op.create_table(
        "notifications",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("notification_type", sa.String(50), nullable=False),
        sa.Column("title", sa.String(255), nullable=False),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("target_screen", sa.String(100), nullable=True),
        sa.Column("payload", sa.JSON(), nullable=True),
        sa.Column("is_read", sa.Boolean(), server_default=sa.text("false")),
        sa.Column("expires_at", sa.DateTime(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── support_tickets ──
    op.create_table(
        "support_tickets",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("subject", sa.String(255), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("status", supportstatus, nullable=False, server_default="open", index=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── support_messages ──
    op.create_table(
        "support_messages",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("ticket_id", sa.Integer(), sa.ForeignKey("support_tickets.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("sender_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("message", sa.Text(), nullable=False),
        sa.Column("attachment_url", sa.String(500), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── practitioner_clients ──
    op.create_table(
        "practitioner_clients",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("practitioner_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("client_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── treatment_sessions ──
    op.create_table(
        "treatment_sessions",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("practitioner_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("client_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("session_type", sa.String(100), nullable=False),
        sa.Column("pre_treatment_notes", sa.Text(), nullable=True),
        sa.Column("post_treatment_notes", sa.Text(), nullable=True),
        sa.Column("protocol", sa.JSON(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── legal_documents ──
    op.create_table(
        "legal_documents",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("document_type", legaldocdoctype, nullable=False),
        sa.Column("version", sa.String(20), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )

    # ── privacy_audit_logs ──
    op.create_table(
        "privacy_audit_logs",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("user_id", sa.Integer(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True),
        sa.Column("action", sa.String(100), nullable=False),
        sa.Column("details", sa.JSON(), nullable=True),
        sa.Column("ip_address", sa.String(50), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.now()),
    )


def downgrade() -> None:
    op.drop_table("privacy_audit_logs")
    op.drop_table("legal_documents")
    op.drop_table("treatment_sessions")
    op.drop_table("practitioner_clients")
    op.drop_table("support_messages")
    op.drop_table("support_tickets")
    op.drop_table("notifications")
    op.drop_table("credit_transactions")
    op.drop_table("credit_balances")
    op.drop_table("payments")
    op.drop_table("order_items")
    op.drop_table("orders")
    op.drop_table("cart_items")
    op.drop_table("carts")
    op.drop_index("ix_environmental_data_pincode", table_name="environmental_data")
    op.drop_table("environmental_data")
    op.drop_table("insights")
    op.drop_table("routine_interventions")
    op.drop_table("routine_steps")
    op.drop_table("routines")
    op.drop_table("shelf_items")
    op.drop_table("wearable_syncs")
    op.drop_table("cycle_events")
    op.drop_table("skin_photos")
    op.drop_table("skin_logs")
    op.drop_table("hydration_logs")
    op.drop_table("daily_checkins")
    op.drop_table("soft_scans")
    op.drop_index("ix_products_category", table_name="products")
    op.drop_table("products")
    op.drop_table("privacy_consents")
    op.drop_table("onboarding_progress")
    op.drop_table("refresh_tokens")
    op.drop_index("ix_user_profiles_pincode", table_name="user_profiles")
    op.drop_table("user_profiles")
    op.drop_table("users")

    sa.Enum(name="legaldocdoctype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="supportstatus").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="credittransactiontype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="paymentstatus").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="orderstatus").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="privacycategory").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="insighttype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="interventiontype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="routinetype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="shelfstatus").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="cycleeventtype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="checkintype").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="onboardingstep").drop(op.get_bind(), checkfirst=True)
    sa.Enum(name="userrole").drop(op.get_bind(), checkfirst=True)
