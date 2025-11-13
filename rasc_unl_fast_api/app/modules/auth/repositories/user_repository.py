from typing import Optional, List
from sqlalchemy import select, or_
from sqlalchemy.ext.asyncio import AsyncSession
from app.modules.auth.models.user import User, RoleEnum
from app.modules.auth.schemas.auth_schemas import UserCreate, UserUpdate
from app.core.jwt.jwt import PasswordHasher


class UserRepository:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.password_hasher = PasswordHasher()

    async def create(self, user_data: UserCreate) -> User:
        """Create a new user with hashed password."""
        hashed_password = self.password_hasher.hash(user_data.password)
        
        user = User(
            email=user_data.email,
            first_name=user_data.first_name,
            last_name=user_data.last_name,
            dni=user_data.dni,
            date_of_birth=None,
            password=hashed_password,
            role=RoleEnum.COMPETITOR,
            is_active=True
        )
        
        self.session.add(user)
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def get_by_id(self, user_id: int) -> Optional[User]:
        """Get user by ID."""
        result = await self.session.execute(
            select(User).where(User.id == user_id)
        )
        return result.scalar_one_or_none()

    async def get_by_email(self, email: str) -> Optional[User]:
        """Get user by email."""
        result = await self.session.execute(
            select(User).where(User.email == email)
        )
        return result.scalar_one_or_none()

    async def get_by_dni(self, dni: str) -> Optional[User]:
        """Get user by DNI."""
        result = await self.session.execute(
            select(User).where(User.dni == dni)
        )
        return result.scalar_one_or_none()

    async def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100,
        role: Optional[str] = None,
        is_active: Optional[bool] = None,
        search: Optional[str] = None
    ) -> List[User]:
        """Get all users with optional filters."""
        query = select(User)
        
        # Apply filters
        if role:
            query = query.where(User.role == RoleEnum(role))
        
        if is_active is not None:
            query = query.where(User.is_active == is_active)
        
        if search:
            search_filter = or_(
                User.first_name.ilike(f"%{search}%"),
                User.last_name.ilike(f"%{search}%"),
                User.email.ilike(f"%{search}%"),
                User.dni.ilike(f"%{search}%")
            )
            query = query.where(search_filter)
        
        query = query.offset(skip).limit(limit)
        
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def update(self, user_id: int, user_data: UserUpdate) -> Optional[User]:
        """Update user information."""
        user = await self.get_by_id(user_id)
        if not user:
            return None
        
        update_data = user_data.model_dump(exclude_unset=True)
        
        for field, value in update_data.items():
            if field == "role" and value:
                value = RoleEnum(value)
            setattr(user, field, value)
        
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def update_password(self, user_id: int, new_password: str) -> Optional[User]:
        """Update user password."""
        user = await self.get_by_id(user_id)
        if not user:
            return None
        
        hashed_password = self.password_hasher.hash(new_password)
        user.password = hashed_password
        
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def delete(self, user_id: int) -> bool:
        """Delete user by ID."""
        user = await self.get_by_id(user_id)
        if not user:
            return False
        
        await self.session.delete(user)
        await self.session.commit()
        return True

    async def deactivate(self, user_id: int) -> Optional[User]:
        """Deactivate user (soft delete)."""
        user = await self.get_by_id(user_id)
        if not user:
            return None
        
        user.is_active = False
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def activate(self, user_id: int) -> Optional[User]:
        """Activate user."""
        user = await self.get_by_id(user_id)
        if not user:
            return None
        
        user.is_active = True
        await self.session.commit()
        await self.session.refresh(user)
        return user

    async def exists(self, email: str) -> bool:
        """Check if user exists by email."""
        user = await self.get_by_email(email)
        return user is not None

    async def verify_password(self, user: User, password: str) -> bool:
        """Verify user password."""
        return self.password_hasher.verify(password, user.password)

    async def count(
        self,
        role: Optional[str] = None,
        is_active: Optional[bool] = None
    ) -> int:
        """Count users with optional filters."""
        query = select(User)
        
        if role:
            query = query.where(User.role == RoleEnum(role))
        
        if is_active is not None:
            query = query.where(User.is_active == is_active)
        
        result = await self.session.execute(query)
        return len(list(result.scalars().all()))
