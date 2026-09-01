from pydantic_settings import BaseSettings
from typing import Optional


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5432/rare_db"
    JWT_SECRET: str = "your-super-secret-key-change-in-production"
    JWT_ALGORITHM: str = "HS256"
    JWT_ACCESS_EXPIRE_MINUTES: int = 30
    JWT_REFRESH_EXPIRE_DAYS: int = 7

    STORAGE_TYPE: str = "local"
    LOCAL_STORAGE_PATH: str = "./uploads"

    CORS_ORIGINS: str = "http://localhost:3000,http://localhost:8080"

    RAZORPAY_KEY_ID: Optional[str] = None
    RAZORPAY_KEY_SECRET: Optional[str] = None

    SMTP_HOST: Optional[str] = None
    SMTP_PORT: int = 587
    SMTP_USER: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None

    AQI_API_KEY: Optional[str] = None

    SKIN_ANALYSIS_MODE: str = "development"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"


settings = Settings()

if settings.JWT_SECRET == "your-super-secret-key-change-in-production":
    import os
    if os.environ.get("ENVIRONMENT") == "production":
        raise RuntimeError(
            "JWT_SECRET must be changed from the default value in production. "
            "Set the JWT_SECRET environment variable."
        )
