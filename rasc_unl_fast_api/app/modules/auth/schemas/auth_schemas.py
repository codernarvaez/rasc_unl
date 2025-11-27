from pydantic import BaseModel, EmailStr, Field, ConfigDict, field_serializer
from typing import Optional
from datetime import datetime, date, timezone
from app.modules.auth.models.user_model import RoleEnum

# Base schemas (solo campos comunes)
class UserBase(BaseModel):
    email: EmailStr
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    dni: str = Field(..., min_length=10, max_length=13)


# Request schemas
class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=100)

class UserCreateByAdmin(BaseModel):
    """Schema for admin creating users - password defaults to DNI"""
    email: EmailStr
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    dni: str = Field(..., min_length=10, max_length=13)
    birth_date: Optional[date] = Field(None, description="Date of birth (YYYY-MM-DD)")
    password: Optional[str] = Field(None, min_length=8, max_length=100, description="Password (defaults to DNI if not provided)")
    role: Optional[RoleEnum] = Field(RoleEnum.MODERATOR, description="Role for the user (ADMINISTRATOR or MODERATOR)")

class UserUpdate(BaseModel):
    first_name: Optional[str] = Field(None, min_length=1, max_length=100)
    last_name: Optional[str] = Field(None, min_length=1, max_length=100)
    birth_date: Optional[date] = Field(None, description="Fecha de nacimiento (YYYY-MM-DD)")


class UserUpdateAdmin(UserUpdate):
    """Schema para actualización de usuarios por parte de administradores.
    Admin CANNOT update dni or email for existing users."""
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
    """Schema de respuesta para usuarios - Fechas en UTC"""
    id: int
    email: EmailStr
    first_name: str
    last_name: str
    dni: str
    birth_date: Optional[date]
    role: str
    is_active: bool
    created_at: datetime
    updated_at: datetime
    
    model_config = ConfigDict(from_attributes=True)
    
    @field_serializer('created_at', 'updated_at')
    def serialize_datetime(self, dt: datetime) -> str:
        """Serializar todas las fechas en UTC ISO 8601"""
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()


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
