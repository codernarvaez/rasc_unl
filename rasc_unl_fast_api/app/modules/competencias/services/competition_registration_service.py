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
        """Crea un nuevo registro de equipo en una competencia - Solo moderadores"""
        # Validar que el usuario es moderador o admin
        user = await self.user_repository.get_by_dni(user_dni)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with DNI {user_dni} not found"
            )
        
        if user.role not in [RoleEnum.MODERATOR, RoleEnum.ADMINISTRATOR]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only moderators and administrators can register teams"
            )

        # Validar que la competencia existe y está activa
        competence = await self.competence_repository.get_by_id(registration_data.competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {registration_data.competence_id} not found"
            )

        if not competence.is_active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="The competence is not active"
            )

        # Verificar que el número de dorsal no esté duplicado en esta competencia
        existing = await self.repository.get_by_dorsal_and_competence(
            registration_data.dorsal_number,
            registration_data.competence_id
        )
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Dorsal number {registration_data.dorsal_number} already registered in this competition"
            )

        # Crear el registro con el DNI del moderador
        registration = await self.repository.create(registration_data, user_dni)
        await self.session.commit()
        
        return CompetitionRegistrationResponse.model_validate(registration)

    async def get_registration(self, registration_id: int) -> CompetitionRegistrationResponse:
        """Obtiene un registro por ID"""
        registration = await self.repository.get_by_id(registration_id)
        if not registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registration with ID {registration_id} not found"
            )
        return CompetitionRegistrationResponse.model_validate(registration)

    async def get_all_registrations(
        self,
        skip: int = 0,
        limit: int = 100,
        competence_id: Optional[int] = None
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
        competence_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> CompetitionRegistrationListResponse:
        """Obtiene todos los registros de una competencia"""
        competence = await self.competence_repository.get_by_id(competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
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
        registration_id: int,
        registration_data: CompetitionRegistrationUpdate
    ) -> CompetitionRegistrationResponse:
        """Actualiza un registro"""
        current_registration = await self.repository.get_by_id(registration_id)
        if not current_registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registration with ID {registration_id} not found"
            )

        registration = await self.repository.update(registration_id, registration_data)
        await self.session.commit()
        
        return CompetitionRegistrationResponse.model_validate(registration)

    async def delete_registration(self, registration_id: int) -> dict:
        """Elimina un registro"""
        success = await self.repository.delete(registration_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registration with ID {registration_id} not found"
            )

        await self.session.commit()
        return {"message": "Registration deleted successfully"}
