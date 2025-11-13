from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from app.modules.competencias.repositories.registros_repository import CompetitionRegistrationRepository
from app.modules.competencias.repositories.competencias_repository import CompetenceRepository
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
    """

    def __init__(self, session: AsyncSession):
        self.repository = CompetitionRegistrationRepository(session)
        self.competence_repository = CompetenceRepository(session)
        self.session = session

    async def create_registration(self, registration_data: CompetitionRegistrationCreate) -> CompetitionRegistrationResponse:
        """Creates a new competition registration"""
        # Validate that competence exists and is active
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

        # Check if user is already registered in this competence
        user_exists = await self.repository.check_user_registered(
            registration_data.competence_id,
            registration_data.user_dni
        )
        if user_exists:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="This user is already registered in the competence"
            )

        registration = await self.repository.create(registration_data)
        await self.session.commit()
        
        return CompetitionRegistrationResponse.model_validate(registration)

    async def get_registration(self, registration_id: int) -> CompetitionRegistrationResponse:
        """Gets a registration by ID"""
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
        competence_id: Optional[int] = None,
        user_dni: Optional[str] = None
    ) -> CompetitionRegistrationListResponse:
        """Gets all registrations with pagination and filters"""
        registrations = await self.repository.get_all(
            skip=skip,
            limit=limit,
            competence_id=competence_id,
            user_dni=user_dni
        )
        total = await self.repository.count(
            competence_id=competence_id,
            user_dni=user_dni
        )
        
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
        """Gets all registrations for a competence"""
        # Validate that competence exists
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
        """Updates a registration"""
        # Check that registration exists
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
        """Deletes a registration"""
        success = await self.repository.delete(registration_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Registration with ID {registration_id} not found"
            )

        await self.session.commit()
        return {"message": "Registration deleted successfully"}
