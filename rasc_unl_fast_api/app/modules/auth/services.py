"""
Authentication and User Services
Handles business logic for user management and authentication
"""
from typing import Optional, List
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.schemas.auth_schemas import (
    UserCreate,
    UserUpdate,
    UserUpdatePassword,
    LoginRequest
)
from app.modules.auth.models.user import User
from app.core.jwt.jwt import JWTManager


class AuthService:
    """Service for authentication operations."""
    
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = UserRepository(session)
        self.jwt_manager = JWTManager()
    
    async def register_user(self, user_data: UserCreate) -> User:
        """Register a new user."""
        if await self.repository.exists(user_data.email):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        return await self.repository.create(user_data)
    
    async def login(self, credentials: LoginRequest) -> dict:
        """Authenticate user and return tokens."""
        user = await self.repository.get_by_email(credentials.email)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        if not await self.repository.verify_password(user, credentials.password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User account is inactive"
            )
        
        # Create tokens
        access_token = self.jwt_manager.create_access_token(str(user.id))
        refresh_token = self.jwt_manager.create_refresh_token(str(user.id))
        
        # Store refresh token
        refresh_payload = self.jwt_manager.decode(refresh_token)
        await self.jwt_manager.store_refresh(
            refresh_payload["jti"],
            str(user.id),
            refresh_payload["exp"]
        )
        
        return {
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "bearer"
        }
    
    async def refresh_tokens(self, refresh_token: str) -> dict:
        """Refresh access token using refresh token."""
        try:
            payload = self.jwt_manager.decode(refresh_token)
            
            if payload.get("type") != "refresh":
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid token type"
                )
            
            jti = payload.get("jti")
            user_id = await self.jwt_manager.consume_refresh(jti)
            
            if not user_id:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Refresh token already used or invalid"
                )
            
            user = await self.repository.get_by_id(int(user_id))
            
            if not user or not user.is_active:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="User not found or inactive"
                )
            
            # Create new tokens
            new_access_token = self.jwt_manager.create_access_token(user_id)
            new_refresh_token = self.jwt_manager.create_refresh_token(user_id)
            
            # Store new refresh token
            new_refresh_payload = self.jwt_manager.decode(new_refresh_token)
            await self.jwt_manager.store_refresh(
                new_refresh_payload["jti"],
                user_id,
                new_refresh_payload["exp"]
            )
            
            return {
                "access_token": new_access_token,
                "refresh_token": new_refresh_token,
                "token_type": "bearer"
            }
            
        except HTTPException:
            raise
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Could not refresh token"
            )
    
    async def logout(self, refresh_token: str) -> None:
        """Logout user by revoking refresh token."""
        try:
            refresh_payload = self.jwt_manager.decode(refresh_token)
            await self.jwt_manager.consume_refresh(refresh_payload["jti"])
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Could not logout"
            )


class UserService:
    """Service for user management operations."""
    
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = UserRepository(session)
    
    async def get_user_by_id(self, user_id: int) -> User:
        """Get user by ID."""
        user = await self.repository.get_by_id(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        return user
    
    async def get_users(
        self,
        skip: int = 0,
        limit: int = 100,
        role: Optional[str] = None,
        is_active: Optional[bool] = None,
        search: Optional[str] = None
    ) -> List[User]:
        """Get all users with filters."""
        return await self.repository.get_all(
            skip=skip,
            limit=limit,
            role=role,
            is_active=is_active,
            search=search
        )
    
    async def update_user(self, user_id: int, user_data: UserUpdate) -> User:
        """Update user information."""
        # Check if email already exists (if being changed)
        if user_data.email:
            existing_user = await self.repository.get_by_email(user_data.email)
            if existing_user and existing_user.id != user_id:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email already registered"
                )
        
        updated_user = await self.repository.update(user_id, user_data)
        
        if not updated_user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return updated_user
    
    async def update_password(
        self,
        user_id: int,
        current_password: str,
        new_password: str
    ) -> None:
        """Update user password."""
        user = await self.get_user_by_id(user_id)
        
        if not await self.repository.verify_password(user, current_password):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Current password is incorrect"
            )
        
        await self.repository.update_password(user_id, new_password)
    
    async def delete_user(self, user_id: int, current_user_id: int) -> None:
        """Delete user."""
        if user_id == current_user_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot delete own account"
            )
        
        deleted = await self.repository.delete(user_id)
        
        if not deleted:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
    
    async def deactivate_user(self, user_id: int, current_user_id: int) -> User:
        """Deactivate user."""
        if user_id == current_user_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot deactivate own account"
            )
        
        user = await self.repository.deactivate(user_id)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return user
    
    async def activate_user(self, user_id: int) -> User:
        """Activate user."""
        user = await self.repository.activate(user_id)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return user
    
    async def count_users(
        self,
        role: Optional[str] = None,
        is_active: Optional[bool] = None
    ) -> int:
        """Count users with filters."""
        return await self.repository.count(role=role, is_active=is_active)
