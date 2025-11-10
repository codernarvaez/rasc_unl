from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional

from app.core.db.database import get_session
from app.core.jwt.jwt import JWTManager, oauth2_scheme
from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.schemas.auth_schemas import (
    UserCreate,
    UserUpdate,
    UserUpdatePassword,
    UserResponse,
    LoginRequest,
    TokenResponse,
    RefreshTokenRequest,
    LogoutRequest,
    MessageResponse
)

router = APIRouter(prefix="/auth", tags=["Authentication"])


# Dependency to get current user
async def get_current_user(
    token: str = Depends(oauth2_scheme),
    session: AsyncSession = Depends(get_session)
):
    """Get current authenticated user from token."""
    jwt_manager = JWTManager()
    
    try:
        payload = jwt_manager.decode(token)
        
        if payload.get("type") != "access":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type"
            )
        
        jti = payload.get("jti")
        if await jwt_manager.is_revoked(jti):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token has been revoked"
            )
        
        user_id = int(payload.get("sub"))
        repository = UserRepository(session)
        user = await repository.get_by_id(user_id)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )
        
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User is inactive"
            )
        
        return user
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )


# Dependency to check if user is admin
async def require_admin(current_user = Depends(get_current_user)):
    """Require user to be administrator."""
    if current_user.role != "administrator":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Administrator privileges required"
        )
    return current_user


@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(
    user_data: UserCreate,
    session: AsyncSession = Depends(get_session)
):
    """Register a new user."""
    repository = UserRepository(session)
    
    # Check if email already exists
    if await repository.exists(user_data.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    user = await repository.create(user_data)
    return user


@router.post("/login", response_model=TokenResponse)
async def login(
    credentials: LoginRequest,
    session: AsyncSession = Depends(get_session)
):
    """Login user and return access and refresh tokens."""
    repository = UserRepository(session)
    jwt_manager = JWTManager()
    
    # Get user by email
    user = await repository.get_by_email(credentials.email)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    # Verify password
    if not await repository.verify_password(user, credentials.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    # Check if user is active
    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="User account is inactive"
        )
    
    # Create tokens
    access_token = jwt_manager.create_access_token(str(user.id))
    refresh_token = jwt_manager.create_refresh_token(str(user.id))
    
    # Store refresh token
    refresh_payload = jwt_manager.decode(refresh_token)
    await jwt_manager.store_refresh(
        refresh_payload["jti"],
        str(user.id),
        refresh_payload["exp"]
    )
    
    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token
    )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(
    request: RefreshTokenRequest,
    session: AsyncSession = Depends(get_session)
):
    """Refresh access token using refresh token."""
    jwt_manager = JWTManager()
    
    try:
        payload = jwt_manager.decode(request.refresh_token)
        
        if payload.get("type") != "refresh":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid token type"
            )
        
        jti = payload.get("jti")
        
        # Consume refresh token (one-time use)
        user_id = await jwt_manager.consume_refresh(jti)
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Refresh token already used or invalid"
            )
        
        # Verify user still exists and is active
        repository = UserRepository(session)
        user = await repository.get_by_id(int(user_id))
        
        if not user or not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found or inactive"
            )
        
        # Create new tokens
        new_access_token = jwt_manager.create_access_token(user_id)
        new_refresh_token = jwt_manager.create_refresh_token(user_id)
        
        # Store new refresh token
        new_refresh_payload = jwt_manager.decode(new_refresh_token)
        await jwt_manager.store_refresh(
            new_refresh_payload["jti"],
            user_id,
            new_refresh_payload["exp"]
        )
        
        return TokenResponse(
            access_token=new_access_token,
            refresh_token=new_refresh_token
        )
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not refresh token"
        )


@router.post("/logout", response_model=MessageResponse)
async def logout(
    request: LogoutRequest,
    current_user = Depends(get_current_user)
):
    """Logout user by revoking tokens."""
    jwt_manager = JWTManager()
    
    try:
        # Revoke refresh token
        refresh_payload = jwt_manager.decode(request.refresh_token)
        await jwt_manager.consume_refresh(refresh_payload["jti"])
        
        return MessageResponse(message="Successfully logged out")
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Could not logout"
        )


@router.get("/me", response_model=UserResponse)
async def get_current_user_info(current_user = Depends(get_current_user)):
    """Get current authenticated user information."""
    return current_user


@router.put("/me", response_model=UserResponse)
async def update_current_user(
    user_data: UserUpdate,
    current_user = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    """Update current user information."""
    repository = UserRepository(session)
    
    # Prevent role change by non-admin
    if user_data.role and current_user.role != "administrator":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Cannot change own role"
        )
    
    # Check if email already exists (if being changed)
    if user_data.email and user_data.email != current_user.email:
        if await repository.exists(user_data.email):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
    
    updated_user = await repository.update(current_user.id, user_data)
    return updated_user


@router.put("/me/password", response_model=MessageResponse)
async def update_current_user_password(
    password_data: UserUpdatePassword,
    current_user = Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    """Update current user password."""
    repository = UserRepository(session)
    
    # Verify current password
    if not await repository.verify_password(current_user, password_data.current_password):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Current password is incorrect"
        )
    
    await repository.update_password(current_user.id, password_data.new_password)
    return MessageResponse(message="Password updated successfully")


# Admin routes
@router.get("/users", response_model=List[UserResponse])
async def get_users(
    skip: int = 0,
    limit: int = 100,
    role: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Get all users (admin only)."""
    repository = UserRepository(session)
    users = await repository.get_all(
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
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Get user by ID (admin only)."""
    repository = UserRepository(session)
    user = await repository.get_by_id(user_id)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return user


@router.put("/users/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    user_data: UserUpdate,
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Update user by ID (admin only)."""
    repository = UserRepository(session)
    
    # Check if email already exists (if being changed)
    if user_data.email:
        existing_user = await repository.get_by_email(user_data.email)
        if existing_user and existing_user.id != user_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
    
    updated_user = await repository.update(user_id, user_data)
    
    if not updated_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return updated_user


@router.delete("/users/{user_id}", response_model=MessageResponse)
async def delete_user(
    user_id: int,
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Delete user by ID (admin only)."""
    repository = UserRepository(session)
    
    # Prevent deleting self
    if user_id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot delete own account"
        )
    
    deleted = await repository.delete(user_id)
    
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return MessageResponse(message="User deleted successfully")


@router.put("/users/{user_id}/deactivate", response_model=UserResponse)
async def deactivate_user(
    user_id: int,
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Deactivate user (admin only)."""
    repository = UserRepository(session)
    
    # Prevent deactivating self
    if user_id == current_user.id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cannot deactivate own account"
        )
    
    user = await repository.deactivate(user_id)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return user


@router.put("/users/{user_id}/activate", response_model=UserResponse)
async def activate_user(
    user_id: int,
    current_user = Depends(require_admin),
    session: AsyncSession = Depends(get_session)
):
    """Activate user (admin only)."""
    repository = UserRepository(session)
    
    user = await repository.activate(user_id)
    
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found"
        )
    
    return user
