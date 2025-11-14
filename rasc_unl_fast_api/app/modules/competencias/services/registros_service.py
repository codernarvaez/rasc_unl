from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from datetime import datetime, timezone
from app.modules.competencias.repositories.registros_repository import CompetitionRegistrationRepository
from app.modules.competencias.repositories.competencias_repository import CompetenceRepository
from app.modules.competencias.repositories.time_records_repository import CompetitionTimeRecordRepository
from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.models.user import RoleEnum
from app.modules.competencias.services.timer_service import TimerService
from app.modules.competencias.domain.schemas.schemas import (
    CompetitionRegistrationCreate,
    CompetitionRegistrationUpdate,
    CompetitionRegistrationResponse,
    CompetitionRegistrationListResponse,
    StopTimeRequest,
    StopTimeResponse
)
from fastapi import HTTPException, status


class CompetitionRegistrationService:
    """
    Service for Competition Registration business logic
    """

    def __init__(self, session: AsyncSession):
        self.repository = CompetitionRegistrationRepository(session)
        self.competence_repository = CompetenceRepository(session)
        self.user_repository = UserRepository(session)
        self.time_record_repository = CompetitionTimeRecordRepository(session)
        self.timer_service = TimerService(session)
        self.session = session
    
    async def stop_time(
        self,
        competence_id: int,
        user_dni: str,
        stop_time_data: StopTimeRequest
    ) -> StopTimeResponse:
        """
        Detiene el cronómetro para un competidor.
        Valida proximidad a la meta y tiempo mínimo.
        """
        # Verificar que la competencia existe
        competence = await self.competence_repository.get_by_id(competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )
        
        # Verificar que el cronómetro ha iniciado
        if not competence.timer_started or not competence.timer_start_time:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Competition timer has not started yet"
            )
        
        # Verificar que el usuario está registrado en la competencia
        registration = await self.repository.get_by_user_and_competence(
            user_dni=user_dni,
            competence_id=competence_id
        )
        
        if not registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User is not registered in this competition"
            )
        
        # Verificar que no haya detenido el tiempo ya
        if registration.time is not None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="You have already stopped your time for this competition"
            )
        
        # Calcular tiempo transcurrido
        elapsed_time_ms = await self.timer_service.get_elapsed_time_ms(competence_id)
        
        if elapsed_time_ms is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Could not calculate elapsed time"
            )
        
        # Validar tiempo mínimo (2 minutos si salida != meta)
        is_valid_time = self.timer_service.validate_minimum_time(
            elapsed_time_ms,
            competence.start_coordinates,
            competence.finish_coordinates
        )
        
        if not is_valid_time:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Minimum time not reached. You must wait at least 2 minutes before stopping."
            )
        
        # Validar proximidad a la meta
        is_near, distance = self.timer_service.validate_proximity_to_finish(
            stop_time_data.latitude,
            stop_time_data.longitude,
            competence.finish_coordinates,
            competence.proximity_radius_meters
        )
        
        if not is_near:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"You are too far from the finish line. Distance: {distance:.2f} meters. Required: {competence.proximity_radius_meters} meters."
            )
        
        # Verificar si detuvo el tiempo antes del primer registro del moderador
        reference_time_record = await self.time_record_repository.get_reference_record(competence_id)
        is_early = False
        
        if reference_time_record and elapsed_time_ms < reference_time_record.time:
            is_early = True
        
        # Actualizar el registro con el tiempo
        registration.time = elapsed_time_ms
        
        await self.session.commit()
        await self.session.refresh(registration)
        
        message = "Time stopped successfully"
        if is_early:
            message += " (WARNING: You stopped before the moderator's reference time - shown in red)"
        
        return StopTimeResponse(
            registration_id=registration.id,
            time=elapsed_time_ms,
            distance_to_finish=distance,
            is_valid=is_near,
            message=message
        )

    async def create_registration(self, registration_data: CompetitionRegistrationCreate) -> CompetitionRegistrationResponse:
        """Creates a new competition registration"""
        # Validate that user exists
        user = await self.user_repository.get_by_dni(registration_data.user_dni)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with DNI {registration_data.user_dni} not found"
            )
        
        # CRITICAL: Moderators CANNOT participate in competitions
        if user.role == RoleEnum.MODERATOR:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Moderators cannot participate in competitions"
            )
        
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
