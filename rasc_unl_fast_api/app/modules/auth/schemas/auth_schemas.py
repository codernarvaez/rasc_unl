from pydantic import BaseModel, EmailStr, Field, ConfigDict
from typing import Optional
from datetime import datetime, date
from app.modules.auth.models.user import RoleEnum

# Base schemas (solo campos comunes)
class UserBase(BaseModel):
    email: EmailStr
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    dni: str = Field(..., min_length=10, max_length=13)


# Request schemas
class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=100)


class UserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=1, max_length=100)
    last_name: Optional[str] = Field(None, min_length=1, max_length=100)
    date_of_birth: Optional[date] = Field(None, description="Fecha de nacimiento (YYYY-MM-DD)")


class UserUpdateAdmin(UserUpdate):
    """Schema para actualización de usuarios por parte de administradores"""
    role: Optional[RoleEnum] = None
    is_active: Optional[bool] = None


class UserUpdatePassword(BaseModel):
    current_password: str = Field(..., min_length=8, max_length=100)
    new_password: str = Field(..., min_length=8, max_length=100)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


# Response schemas
class UserResponse(BaseModel):
    id: int
    email: EmailStr
    first_name: str
    last_name: str
    dni: str
    date_of_birth: Optional[date]
    role: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class RefreshTokenRequest(BaseModel):
    refresh_token: str


class LogoutRequest(BaseModel):
    refresh_token: str


class MessageResponse(BaseModel):
    message: str
