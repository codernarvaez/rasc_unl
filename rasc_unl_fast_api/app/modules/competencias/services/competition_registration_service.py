from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from app.modules.competencias.repositories.competition_registration_repository import CompetitionRegistrationRepository
from app.modules.competencias.repositories.competence_repository import CompetenceRepository
from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.models.user_model import RoleEnum
from app.modules.competencias.domain.schemas.schemas import (
    CompetitionRegistrationCreate,
    CompetitionRegistrationUpdate,
    CompetitionRegistrationResponse,
    CompetitionRegistrationListResponse
)
from fastapi import HTTPException, status


class CompetitionRegistrationService:
    """
    Service for Competition Registration business logic
    Los moderadores registran equipos en competencias con: dorsal_number, name, n_participants
    """

    def __init__(self, session: AsyncSession):
        self.repository = CompetitionRegistrationRepository(session)
        self.competence_repository = CompetenceRepository(session)
        self.user_repository = UserRepository(session)
        self.session = session

    async def create_registration(
        self,
        registration_data: CompetitionRegistrationCreate,
        user_dni: str
    ) -> CompetitionRegistrationResponse:
        """Crea un nuevo registro de equipo en una competencia - Moderadores y Administradores"""
        # Validar que el usuario es moderador o admin
        user = await self.user_repository.get_by_dni(user_dni)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Usuario con DNI {user_dni} no encontrado"
            )
        
        if user.role not in [RoleEnum.MODERATOR, RoleEnum.ADMINISTRATOR]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Solo moderadores y administradores pueden registrar equipos"
            )

        # Validar que la competencia existe y está activa
        competence = await self.competence_repository.get_by_id(registration_data.competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competencia con ID {registration_data.competence_id} no encontrada"
            )

        if not competence.is_active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="La competencia no está activa"
            )

        # Verificar que el número de dorsal no esté duplicado en esta competencia
        existing = await self.repository.get_by_dorsal_and_competence(
            registration_data.dorsal_number,
            registration_data.competence_id
        )
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"El número de dorsal {registration_data.dorsal_number} ya está registrado en esta competencia"
            )

        # Crear el registro con el DNI del moderador
        registration = await self.repository.create(registration_data, user_dni)
        await self.session.commit()
        
        return CompetitionRegistrationResponse.model_validate(registration)

    async def get_registration(self, registration_id: str) -> CompetitionRegistrationResponse:
        """Obtiene un registro por ID"""
        registration = await self.repository.get_by_id(registration_id)
        if not registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registro con ID {registration_id} no encontrado"
            )
        return CompetitionRegistrationResponse.model_validate(registration)

    async def get_all_registrations(
        self,
        skip: int = 0,
        limit: int = 100,
        competence_id: Optional[str] = None
    ) -> CompetitionRegistrationListResponse:
        """Obtiene todos los registros con paginación y filtros"""
        registrations = await self.repository.get_all(
            skip=skip,
            limit=limit,
            competence_id=competence_id
        )
        total = await self.repository.count(competence_id=competence_id)
        
        return CompetitionRegistrationListResponse(
            competition_registrations=[CompetitionRegistrationResponse.model_validate(r) for r in registrations],
            total=total
        )

    async def get_registrations_by_competence(
        self,
        competence_id: str,
        skip: int = 0,
        limit: int = 100
    ) -> CompetitionRegistrationListResponse:
        """Obtiene todos los registros de una competencia"""
        competence = await self.competence_repository.get_by_id(competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competencia con ID {competence_id} no encontrada"
            )

        registrations = await self.repository.get_by_competence(
            competence_id=competence_id,
            skip=skip,
            limit=limit
        )
        total = await self.repository.count(competence_id=competence_id)
        
        return CompetitionRegistrationListResponse(
            competition_registrations=[CompetitionRegistrationResponse.model_validate(r) for r in registrations],
            total=total
        )

    async def update_registration(
        self,
        registration_id: str,
        registration_data: CompetitionRegistrationUpdate
    ) -> CompetitionRegistrationResponse:
        """Actualiza un registro - Solo administradores y moderadores"""
        current_registration = await self.repository.get_by_id(registration_id)
        if not current_registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registro con ID {registration_id} no encontrado"
            )

        # Si se está actualizando el dorsal, verificar que no esté duplicado
        if registration_data.dorsal_number and registration_data.dorsal_number != current_registration.dorsal_number:
            existing = await self.repository.get_by_dorsal_and_competence(
                registration_data.dorsal_number,
                current_registration.competence_id
            )
            if existing:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"El número de dorsal {registration_data.dorsal_number} ya está registrado en esta competencia"
                )

        registration = await self.repository.update(registration_id, registration_data)
        await self.session.commit()
        
        return CompetitionRegistrationResponse.model_validate(registration)

    async def delete_registration(self, registration_id: str) -> dict:
        """Elimina un registro - Solo administradores y moderadores"""
        success = await self.repository.delete(registration_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registro con ID {registration_id} no encontrado"
            )

        await self.session.commit()
        return {"message": "Registro eliminado exitosamente"}
