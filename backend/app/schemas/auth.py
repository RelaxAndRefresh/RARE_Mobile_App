from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


class UserCreate(BaseModel):
    email: EmailStr
    name: str = Field(min_length=1, max_length=200)
    password: str = Field(min_length=6, max_length=128)


class AnonymousSignup(BaseModel):
    name: str = Field(min_length=1, max_length=200, default="Anonymous User")


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserResponse(BaseModel):
    id: int
    email: Optional[str] = None
    name: Optional[str] = None
    role: str
    is_anonymous: bool = False

    class Config:
        from_attributes = True


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: UserResponse


class TokenRefreshRequest(BaseModel):
    refresh_token: str
