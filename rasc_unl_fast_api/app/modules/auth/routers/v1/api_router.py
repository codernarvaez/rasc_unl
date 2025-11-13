from typing import Annotated, List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db.database import get_session
from app.modules.auth.dependencies import CurrentUser, AdminUser
from app.modules.auth.services import AuthService, UserService
from app.modules.auth.schemas.auth_schemas import (
    UserCreate,
    UserUpdate,
    UserUpdateAdmin,
    UserUpdatePassword,
    UserResponse,
    LoginRequest,
    TokenResponse,
    RefreshTokenRequest,
    LogoutRequest,
    MessageResponse
)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    user_data: UserCreate,
    session: AsyncSession = Depends(get_session)
):
    """Register a new user."""
    service = AuthService(session)
    user = await service.register_user(user_data)
    return user


@router.post("/login", response_model=TokenResponse)
async def login(
    credentials: LoginRequest,
    session: AsyncSession = Depends(get_session)
):
    """Login user and return access and refresh tokens."""
    service = AuthService(session)
    tokens = await service.login(credentials)
    return TokenResponse(**tokens)


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(
    request: RefreshTokenRequest,
    session: AsyncSession = Depends(get_session)
):
    """Refresh access token using refresh token."""
    service = AuthService(session)
    tokens = await service.refresh_tokens(request.refresh_token)
    return TokenResponse(**tokens)


@router.post("/logout", response_model=MessageResponse)
async def logout(
    request: LogoutRequest,
    current_user: CurrentUser,
    session: AsyncSession = Depends(get_session)
):
    """Logout user by revoking tokens."""
    service = AuthService(session)
    await service.logout(request.refresh_token)
    return MessageResponse(message="Successfully logged out")


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(current_user: CurrentUser):
    """Get current authenticated user information."""
    return current_user


@router.put("/me", response_model=UserResponse)
async def update_current_user(
    user_data: UserUpdate,
    current_user: CurrentUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Update current user information (users can only update their own basic data)."""
    service = UserService(session)
    updated_user = await service.update_user(current_user.id, user_data)
    return updated_user


@router.put("/me/password", response_model=MessageResponse)
async def update_current_user_password(
    password_data: UserUpdatePassword,
    current_user: CurrentUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Update current user password."""
    service = UserService(session)
    await service.update_password(
        current_user,
        password_data.current_password,
        password_data.new_password
    )
    return MessageResponse(message="Password updated successfully")


# Admin routes
@router.get("/users", response_model=List[UserResponse])
async def get_users(
    skip: int = 0,
    limit: int = 100,
    role: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    current_user: AdminUser = None,
    session: Annotated[AsyncSession, Depends(get_session)] = None
):
    """Get all users (admin only)."""
    service = UserService(session)
    users = await service.get_users(
        skip=skip,
        limit=limit,
        role=role,
        is_active=is_active,
        search=search
    )
    return users


@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: int,
    current_user: AdminUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Get user by ID (admin only)."""
    service = UserService(session)
    user = await service.get_user_by_id(user_id)
    return user


@router.put("/users/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    user_data: UserUpdateAdmin,
    current_user: AdminUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Update user by ID (admin only - can update all fields including role and is_active)."""
    service = UserService(session)
    updated_user = await service.update_user(user_id, user_data)
    return updated_user


@router.delete("/users/{user_id}", response_model=MessageResponse)
async def delete_user(
    user_id: int,
    current_user: AdminUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Delete user by ID (admin only)."""
    service = UserService(session)
    await service.delete_user(user_id, current_user.id)
    return MessageResponse(message="User deleted successfully")


@router.put("/users/{user_id}/deactivate", response_model=UserResponse)
async def deactivate_user(
    user_id: int,
    current_user: AdminUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Deactivate user (admin only)."""
    service = UserService(session)
    user = await service.deactivate_user(user_id, current_user.id)
    return user


@router.put("/users/{user_id}/activate", response_model=UserResponse)
async def activate_user(
    user_id: int,
    current_user: AdminUser,
    session: Annotated[AsyncSession, Depends(get_session)]
):
    """Activate user (admin only)."""
    service = UserService(session)
    user = await service.activate_user(user_id)
    return user
