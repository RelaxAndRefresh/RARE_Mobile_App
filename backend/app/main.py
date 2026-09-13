from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.core.exceptions import exception_handlers
from app.db.database import engine, Base
from app.routers import (
    auth, users, onboarding, checkins, skin, cycle, wearable,
    shelf, routine, insights, environmental, inbox, rituals,
    products, commerce, bookings, orders, credits, privacy,
    support, practitioner, admin,
)

CORS_ORIGINS = [
    origin.strip()
    for origin in (settings.CORS_ORIGINS or "").split(",")
    if origin.strip()
] or ["http://localhost:3000", "http://localhost:8080"]


@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title="RARE Mobile App API",
    description="Backend API for the RARE mobile application - personalized skincare and wellness platform",
    version="1.0.0",
    lifespan=lifespan,
    openapi_tags=[
        {"name": "Authentication", "description": "User signup, login, and token management"},
        {"name": "Users", "description": "User profile and account management"},
        {"name": "Onboarding", "description": "New user onboarding flow"},
        {"name": "Check-ins", "description": "Daily AM/PM check-ins and hydration tracking"},
        {"name": "Skin Tracking", "description": "Skin logs, photos, and timeline"},
        {"name": "Cycle Tracking", "description": "Menstrual cycle tracking and calendar"},
        {"name": "Wearable", "description": "Wearable device integration"},
        {"name": "Product Shelf", "description": "Track product usage and depletion"},
        {"name": "Routine", "description": "Skincare routine management"},
        {"name": "Insights", "description": "Biweekly, monthly, and pulse insights"},
        {"name": "Environmental Data", "description": "AQI, UV, and environmental data"},
        {"name": "Inbox / Notifications", "description": "User notifications and messages"},
        {"name": "Rituals", "description": "Curated skincare rituals"},
        {"name": "Products", "description": "Product catalog"},
        {"name": "Commerce", "description": "Cart, checkout, and payments"},
        {"name": "Bookings", "description": "Practitioner booking and scheduling"},
        {"name": "Orders", "description": "Order history and details"},
        {"name": "Credits", "description": "Credit balance and transactions"},
        {"name": "Privacy", "description": "Privacy consents and data management"},
        {"name": "Support", "description": "Support tickets and messaging"},
        {"name": "Practitioner", "description": "Practitioner portal and client management"},
        {"name": "Admin", "description": "Admin dashboard and management"},
    ],
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

for exc_cls, handler in exception_handlers.items():
    app.add_exception_handler(exc_cls, handler)

app.include_router(auth.router, prefix="/api/v1")
app.include_router(users.router, prefix="/api/v1")
app.include_router(onboarding.router, prefix="/api/v1")
app.include_router(checkins.router, prefix="/api/v1")
app.include_router(skin.router, prefix="/api/v1")
app.include_router(cycle.router, prefix="/api/v1")
app.include_router(wearable.router, prefix="/api/v1")
app.include_router(shelf.router, prefix="/api/v1")
app.include_router(routine.router, prefix="/api/v1")
app.include_router(insights.router, prefix="/api/v1")
app.include_router(environmental.router, prefix="/api/v1")
app.include_router(inbox.router, prefix="/api/v1")
app.include_router(rituals.router, prefix="/api/v1")
app.include_router(products.router, prefix="/api/v1")
app.include_router(commerce.router, prefix="/api/v1")
app.include_router(bookings.router, prefix="/api/v1")
app.include_router(orders.router, prefix="/api/v1")
app.include_router(credits.router, prefix="/api/v1")
app.include_router(privacy.router, prefix="/api/v1")
app.include_router(support.router, prefix="/api/v1")
app.include_router(practitioner.router, prefix="/api/v1")
app.include_router(admin.router, prefix="/api/v1")


@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "RARE API", "version": "1.0.0"}
