"""
User Service
Handles business logic for user management operations
"""
from typing import List, Optional
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.schemas.auth_schemas import UserUpdate
from app.modules.auth.models.user import User


class UserService:
    """Servicio para operaciones de gestión de usuarios.""" 
    
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
        """Actualizar la información del usuario con validación.""" 
        # Check if email already exists (if being changed)
        if user_data.email:
            existing_user = await self.repository.get_by_email(user_data.email)
            if existing_user and existing_user.id != user_id:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email already registered"
                )
        
        # Check if DNI already exists (if being changed)
        if user_data.dni:
            existing_user = await self.repository.get_by_dni(user_data.dni)
            if existing_user and existing_user.id != user_id:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="DNI already registered"
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
        user: User,
        current_password: str,
        new_password: str
    ) -> None:
        """Actualizar la contraseña del usuario con validación."""
        if not await self.repository.verify_password(user, current_password):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Current password is incorrect"
            )
        
        await self.repository.update_password(user.id, new_password)
    
    async def delete_user(self, user_id: int, current_user_id: int) -> None:
        """Eliminar usuario con validación."""
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
    
    async def activate_user(self, user_id: int) -> User:
        """Activar la cuenta del usuario.""" 
        user = await self.repository.activate(user_id)
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        return user
    
    async def deactivate_user(self, user_id: int, current_user_id: int) -> User:
        """Desactivar la cuenta del usuario con validación.""" 
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
    
    async def count_users(
        self,
        role: Optional[str] = None,
        is_active: Optional[bool] = None
    ) -> int:
        """Count users with filters."""
        return await self.repository.count(role=role, is_active=is_active)
