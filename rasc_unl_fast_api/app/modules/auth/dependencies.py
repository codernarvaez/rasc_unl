"""
Auth Module Dependencies
Dependencias inyectables para autenticación y autorización.
Este archivo centraliza todas las dependencias del módulo auth.
"""
from typing import Annotated
from fastapi import Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db.database import get_session
from app.core.jwt.jwt import JWTManager, oauth2_scheme
from app.modules.auth.models.user import User, RoleEnum
from app.modules.auth.repositories.user_repository import UserRepository


async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    session: Annotated[AsyncSession, Depends(get_session)]
) -> User:
    """
    Obtiene el usuario actual autenticado desde el token JWT.
    
    Esta dependencia:
    - Extrae el token del header Authorization
    - Valida el token JWT
    - Verifica que no esté revocado
    - Busca el usuario en la base de datos
    - Verifica que el usuario esté activo
    
    Args:
        token: Token JWT extraído del header Authorization
        session: Sesión de base de datos
        
    Returns:
        Usuario autenticado
        
    Raises:
        HTTPException 401: Si el token es inválido, expirado o revocado
        HTTPException 403: Si el usuario está inactivo
    """
    jwt_manager = JWTManager()
    
    try:
        # Decodificar token JWT
        payload = jwt_manager.decode(token)
        
        # Validar tipo de token
        if payload.get("type") != "access":
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Tipo de token inválido"
            )
        
        # Verificar si el token está revocado
        jti = payload.get("jti")
        if await jwt_manager.is_revoked(jti):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token ha sido revocado"
            )
        
        # Obtener ID del usuario del payload
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token inválido"
            )
        
        # Buscar usuario en la base de datos
        repository = UserRepository(session)
        user = await repository.get_by_id(int(user_id))
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Usuario no encontrado"
            )
        
        # Verificar que el usuario esté activo
        if not user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Usuario inactivo"
            )
        
        return user
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="No se pudieron validar las credenciales"
        )


async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)]
) -> User:
    """
    Obtiene el usuario actual y verifica que esté activo.
    
    Args:
        current_user: Usuario autenticado
        
    Returns:
        Usuario activo
        
    Raises:
        HTTPException 403: Si el usuario está inactivo
    """
    if not current_user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Usuario inactivo"
        )
    return current_user


async def require_admin(
    current_user: Annotated[User, Depends(get_current_active_user)]
) -> User:
    """
    Requiere que el usuario actual sea administrador.
    
    Uso en rutas:
    ```python
    @router.get("/admin-only")
    async def admin_route(admin: Annotated[User, Depends(require_admin)]):
        return {"message": "Solo administradores"}
    ```
    
    Args:
        current_user: Usuario autenticado
        
    Returns:
        Usuario con rol administrator
        
    Raises:
        HTTPException 403: Si el usuario no es administrador
    """
    if current_user.role != RoleEnum.ADMINISTRATOR:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Se requieren privilegios de administrador"
        )
    return current_user


async def require_competitor(
    current_user: Annotated[User, Depends(get_current_active_user)]
) -> User:
    """
    Requiere que el usuario actual sea competidor.
    
    Uso en rutas:
    ```python
    @router.get("/competitor-only")
    async def competitor_route(competitor: Annotated[User, Depends(require_competitor)]):
        return {"message": "Solo competidores"}
    ```
    
    Args:
        current_user: Usuario autenticado
        
    Returns:
        Usuario con rol competitor
        
    Raises:
        HTTPException 403: Si el usuario no es competidor
    """
    if current_user.role != RoleEnum.COMPETITOR:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Se requieren privilegios de competidor"
        )
    return current_user


# Type aliases para usar en otras rutas
# Esto facilita el uso de las dependencias en otros módulos
CurrentUser = Annotated[User, Depends(get_current_user)]
CurrentActiveUser = Annotated[User, Depends(get_current_active_user)]
AdminUser = Annotated[User, Depends(require_admin)]
CompetitorUser = Annotated[User, Depends(require_competitor)]
