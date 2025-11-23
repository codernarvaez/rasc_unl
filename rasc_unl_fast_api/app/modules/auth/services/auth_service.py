"""
Authentication Service
Handles business logic for authentication operations
"""
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
import logging

from app.core.jwt.jwt import JWTManager
from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.schemas.auth_schemas import UserCreate, LoginRequest, UserCreateByAdmin

logger = logging.getLogger(__name__)


class AuthService:
    """Servicio para operaciones de autenticación."""
    
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = UserRepository(session)
        self.jwt_manager = JWTManager()
    
    async def register_user(self, user_data: UserCreate):
        """Registrar un nuevo usuario con validación."""
        logger.info(f"Attempting to register user: {user_data.email}")
        
        # Check if email already exists
        if await self.repository.exists(user_data.email):
            logger.warning(f"Email already exists: {user_data.email}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        # Check if DNI already exists
        existing_dni = await self.repository.get_by_dni(user_data.dni)
        if existing_dni:
            logger.warning(f"DNI already exists: {user_data.dni}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="DNI already registered"
            )
        
        user = await self.repository.create(user_data)
        logger.info(f"UserModel registered successfully: {user.email} (ID: {user.id})")
        return user
    
    async def create_user_by_admin(self, user_data: UserCreateByAdmin):
        """Create a new user by admin. Password defaults to DNI if not provided."""
        logger.info(f"Admin attempting to create user: {user_data.email}")
        
        # Check if email already exists
        if await self.repository.exists(user_data.email):
            logger.warning(f"Email already exists: {user_data.email}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered"
            )
        
        # Check if DNI already exists
        existing_dni = await self.repository.get_by_dni(user_data.dni)
        if existing_dni:
            logger.warning(f"DNI already exists: {user_data.dni}")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="DNI already registered"
            )
        
        user = await self.repository.create_by_admin(user_data)
        logger.info(f"UserModel created by admin: {user.email} (ID: {user.id}, Role: {user.role})")
        return user
    
    async def login(self, credentials: LoginRequest) -> dict:
        """Autenticar al usuario y devolver tokens."""
        logger.info(f"Login attempt for email: {credentials.email}")
        
        # Get user by email
        user = await self.repository.get_by_email(credentials.email)
        
        if not user:
            logger.warning(f"UserModel not found: {credentials.email}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        # Verify password
        password_valid = await self.repository.verify_password(user, credentials.password)
        logger.info(f"Password verification for {credentials.email}: {password_valid}")
        
        if not password_valid:
            logger.warning(f"Invalid password for: {credentials.email}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password"
            )
        
        # Check if user is active
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="UserModel account is inactive"
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
        """Refrescar el token de acceso usando el token de refresco."""
        try:
            payload = self.jwt_manager.decode(refresh_token)
            
            if payload.get("type") != "refresh":
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid token type"
                )
            
            jti = payload.get("jti")
            
            # Consume refresh token (one-time use)
            user_id = await self.jwt_manager.consume_refresh(jti)
            if not user_id:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Refresh token already used or invalid"
                )
            
            # Verify user still exists and is active
            user = await self.repository.get_by_id(int(user_id))
            
            if not user or not user.is_active:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="UserModel not found or inactive"
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
        """Cerrar sesión del usuario revocando el token de refresco."""
        try:
            refresh_payload = self.jwt_manager.decode(refresh_token)
            await self.jwt_manager.consume_refresh(refresh_payload["jti"])
        except Exception as e:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Could not logout"
            )
