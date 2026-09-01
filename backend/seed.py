import os
import sys
from datetime import datetime, date, timedelta
from decimal import Decimal

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

from app.core.config import settings
from app.core.security import get_password_hash
from app.db.database import Base
from app.db.models import (
    User, UserProfile, OnboardingProgress, PrivacyConsent,
    Product, Routine, RoutineStep, DailyCheckin, SkinLog, Insight,
    ShelfItem, CreditBalance, CreditTransaction, Notification,
    LegalDocument, EnvironmentalData, UserRole, OnboardingStep,
    CheckinType, ShelfStatus, RoutineType, InsightType, PrivacyCategory,
    LegalDocType, CreditTransactionType,
)


def seed():
    engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)
    Session = sessionmaker(bind=engine)
    db = Session()

    try:
        # ── Check if seed already ran ──
        existing_user = db.query(User).filter(User.email == "test@rare.com").first()
        if existing_user:
            print("Seed data already exists. Skipping.")
            return

        now = datetime.utcnow()
        today = date.today()

        # ── Users ──
        print("Creating users...")
        test_user = User(
            email="test@rare.com",
            name="Test User",
            password_hash=get_password_hash("password123"),
            role=UserRole.user,
            is_active=True,
        )
        pract_user = User(
            email="practitioner@rare.com",
            name="Dr. Priya Sharma",
            password_hash=get_password_hash("password123"),
            role=UserRole.practitioner,
            is_active=True,
        )
        admin_user = User(
            email="admin@rare.com",
            name="Admin User",
            password_hash=get_password_hash("password123"),
            role=UserRole.admin,
            is_active=True,
        )
        db.add_all([test_user, pract_user, admin_user])
        db.flush()

        # ── User Profiles ──
        print("Creating profiles...")
        db.add(UserProfile(
            user_id=test_user.id,
            skin_type="combination",
            barrier_status="slightly_compromised",
            hydration_index=6.5,
            barrier_function=7.0,
            sebum_balance=5.5,
            sensitivity_score=4.0,
            cycle_length=28,
            pincode="400001",
            city="Mumbai",
            latitude=18.9388,
            longitude=72.8354,
        ))
        db.add(UserProfile(
            user_id=pract_user.id,
            skin_type="normal",
            barrier_status="healthy",
            hydration_index=8.0,
            barrier_function=8.5,
            sebum_balance=7.0,
            sensitivity_score=2.0,
            pincode="400001",
            city="Mumbai",
        ))

        # ── Onboarding Progress ──
        print("Creating onboarding progress...")
        db.add(OnboardingProgress(
            user_id=test_user.id,
            current_step=OnboardingStep.complete,
            completed_steps=["welcome", "skin_scan", "privacy_consent", "cycle_baseline", "wearable", "complete"],
            is_complete=True,
        ))

        # ── Privacy Consents ──
        print("Creating privacy consents...")
        for cat in PrivacyCategory:
            db.add(PrivacyConsent(
                user_id=test_user.id,
                category=cat,
                consented=True,
            ))

        # ── Products ──
        print("Creating products...")
        products_data = [
            {"name": "Barrier Repair Serum", "brand": "RARE", "description": "Ceramide-rich serum that strengthens the skin barrier with niacinamide and centella asiatica.", "category": "serum", "price_inr": Decimal("2400.00"), "stock_quantity": 100},
            {"name": "Vitamin C Elixir", "brand": "RARE", "description": "Brightening vitamin C serum with ferulic acid and vitamin E for antioxidant protection.", "category": "serum", "price_inr": Decimal("1800.00"), "stock_quantity": 80},
            {"name": "Gentle Exfoliant", "brand": "RARE", "description": "PHA-based gentle exfoliant for sensitive skin. Removes dead cells without irritation.", "category": "exfoliant", "price_inr": Decimal("2100.00"), "stock_quantity": 60},
            {"name": "Hydrating Moisturizer", "brand": "RARE", "description": "Lightweight gel-cream moisturizer with hyaluronic acid and squalane for all-day hydration.", "category": "moisturizer", "price_inr": Decimal("1600.00"), "stock_quantity": 120},
            {"name": "SPF 50 Sunscreen", "brand": "RARE", "description": "Invisible fluid sunscreen with SPF 50 PA++++. No white cast, suitable for all skin tones.", "category": "sunscreen", "price_inr": Decimal("1200.00"), "stock_quantity": 150},
        ]
        products = []
        for pdata in products_data:
            p = Product(**pdata, is_active=True)
            db.add(p)
            products.append(p)
        db.flush()

        # ── Routine ──
        print("Creating routine...")
        routine = Routine(
            user_id=test_user.id,
            name="Daily Glow Routine",
            routine_type=RoutineType.both,
            is_active=True,
        )
        db.add(routine)
        db.flush()

        steps_data = [
            {"step_order": 1, "step_name": "Cleanse", "instruction": "Gently massage cleanser onto damp skin for 60 seconds."},
            {"step_order": 2, "step_name": "Serum", "instruction": "Apply Barrier Repair Serum to face and neck."},
            {"step_order": 3, "step_name": "Moisturize", "instruction": "Lock in hydration with Hydrating Moisturizer."},
            {"step_order": 4, "step_name": "Protect", "instruction": "Apply SPF 50 Sunscreen generously. Reapply every 2 hours."},
        ]
        for i, sd in enumerate(steps_data):
            db.add(RoutineStep(
                routine_id=routine.id,
                product_id=products[i].id if i < len(products) else None,
                step_order=sd["step_order"],
                step_name=sd["step_name"],
                instruction=sd["instruction"],
            ))

        # ── Daily Check-ins ──
        print("Creating check-ins...")
        db.add(DailyCheckin(
            user_id=test_user.id,
            checkin_type=CheckinType.am,
            date=today,
            sleep_hours=7.5,
            mood=8,
            energy=7,
            stress=3,
            skin_feel="hydrated",
            tags=["well-rested", "clear-skin"],
            notes="Woke up feeling great. Skin looks dewy.",
        ))
        db.add(DailyCheckin(
            user_id=test_user.id,
            checkin_type=CheckinType.pm,
            date=today,
            sleep_hours=None,
            mood=7,
            energy=6,
            stress=5,
            skin_feel="slightly-oily",
            tags=["t-zone-oil", "end-of-day"],
            notes="T-zone got a bit oily by afternoon but overall good day.",
        ))

        # ── Skin Logs ──
        print("Creating skin logs...")
        log1 = SkinLog(
            user_id=test_user.id,
            tags=["glow", "hydrated"],
            notes="Skin feels plump and glowing after using the new serum for a week.",
            rating=8,
        )
        log2 = SkinLog(
            user_id=test_user.id,
            tags=["dry-patch", "flaking"],
            notes="Noticed small dry patch near the jawline. Might need more moisturizer there.",
            rating=6,
        )
        db.add_all([log1, log2])

        # ── Insights ──
        print("Creating insights...")
        db.add(Insight(
            user_id=test_user.id,
            insight_type=InsightType.biweekly,
            title="Sleep Quality Correlates with Skin Clarity",
            body="Your skin ratings tend to be 1.5 points higher on days following 7+ hours of sleep.",
            variable_a="sleep_hours",
            variable_b="skin_rating",
            observation_count=14,
            confidence=0.82,
            tier="A",
            claim="Consistent sleep above 7 hours improves visible skin clarity.",
            period_start=today - timedelta(days=14),
            period_end=today,
        ))
        db.add(Insight(
            user_id=test_user.id,
            insight_type=InsightType.monthly,
            title="Hydration Level Trending Upward",
            body="Your average hydration index has improved from 5.8 to 6.5 over the past month.",
            variable_a="hydration_index",
            variable_b="time",
            observation_count=30,
            confidence=0.75,
            tier="B",
            claim="Your hydration routine is showing measurable improvement.",
            confound="Weather changes during the month may have influenced results.",
            period_start=today - timedelta(days=30),
            period_end=today,
        ))

        # ── Shelf Items ──
        print("Creating shelf items...")
        db.add(ShelfItem(
            user_id=test_user.id,
            product_id=products[0].id,
            status=ShelfStatus.standard,
            depletion_estimate_days=45,
            last_restocked=now - timedelta(days=15),
            auto_swap_enabled=False,
        ))
        db.add(ShelfItem(
            user_id=test_user.id,
            product_id=products[1].id,
            status=ShelfStatus.armed,
            depletion_estimate_days=10,
            last_restocked=now - timedelta(days=50),
            auto_swap_enabled=True,
        ))
        db.add(ShelfItem(
            user_id=test_user.id,
            product_id=products[4].id,
            status=ShelfStatus.depleted,
            depletion_estimate_days=0,
            last_restocked=now - timedelta(days=60),
            auto_swap_enabled=False,
        ))

        # ── Credits ──
        print("Creating credits...")
        cb = CreditBalance(user_id=test_user.id, balance=500)
        db.add(cb)
        db.flush()

        db.add(CreditTransaction(
            user_id=test_user.id,
            amount=500,
            transaction_type=CreditTransactionType.credit,
            reason="Welcome bonus",
            balance_after=500,
        ))
        db.add(CreditTransaction(
            user_id=test_user.id,
            amount=50,
            transaction_type=CreditTransactionType.debit,
            reason="Redeemed for discount",
            balance_after=450,
        ))

        # ── Notifications ──
        print("Creating notifications...")
        db.add(Notification(
            user_id=test_user.id,
            notification_type="reminder",
            title="Time for PM Routine",
            body="Don't forget your evening skincare routine tonight!",
            target_screen="routine",
            is_read=False,
            expires_at=now + timedelta(hours=12),
        ))
        db.add(Notification(
            user_id=test_user.id,
            notification_type="insight",
            title="New Insight Available",
            body="Your biweekly insight about sleep and skin is ready.",
            target_screen="insights",
            is_read=False,
        ))
        db.add(Notification(
            user_id=test_user.id,
            notification_type="promo",
            title="10% Off Vitamin C Elixir",
            body="Use code GLOW10 at checkout. Valid for 3 days.",
            target_screen="product",
            is_read=True,
            expires_at=now + timedelta(days=3),
        ))

        # ── Legal Document ──
        print("Creating legal document...")
        db.add(LegalDocument(
            document_type=LegalDocType.privacy_policy,
            version="1.0",
            content=(
                "RARE Privacy Policy\n\n"
                "Effective Date: January 1, 2024\n\n"
                "1. Information We Collect\n"
                "We collect information you provide directly, including your name, email, "
                "phone number, skin profile data, and usage patterns.\n\n"
                "2. How We Use Your Information\n"
                "We use your information to personalize your skincare recommendations, "
                "track your progress, and improve our services.\n\n"
                "3. Data Sharing\n"
                "We do not sell your personal data. We may share anonymized data with "
                "research partners with your explicit consent.\n\n"
                "4. Your Rights\n"
                "You can access, modify, or delete your data at any time through the "
                "app settings or by contacting support@rare.com.\n\n"
                "5. Contact\n"
                "For privacy-related questions, email privacy@rare.com."
            ),
            is_active=True,
        ))

        # ── Environmental Data ──
        print("Creating environmental data...")
        db.add(EnvironmentalData(
            user_id=test_user.id,
            pincode="400001",
            city="Mumbai",
            latitude=18.9388,
            longitude=72.8354,
            aqi=145,
            pm25=65.3,
            pm10=98.7,
            humidity=72.0,
            uv_index=8.5,
            monitoring_coverage="central",
            recorded_at=now,
            cached_until=now + timedelta(hours=1),
        ))
        db.add(EnvironmentalData(
            user_id=test_user.id,
            pincode="400001",
            city="Mumbai",
            latitude=18.9388,
            longitude=72.8354,
            aqi=132,
            pm25=58.1,
            pm10=89.2,
            humidity=75.0,
            uv_index=7.0,
            monitoring_coverage="central",
            recorded_at=now - timedelta(hours=6),
            cached_until=now - timedelta(hours=5),
        ))

        db.commit()
        print("Seed completed successfully!")

    except Exception as e:
        db.rollback()
        print(f"Seed failed: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed()
