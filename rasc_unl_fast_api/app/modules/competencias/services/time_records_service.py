from typing import List
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.modules.competencias.repositories.time_records_repository import TimeRecordRepository
from app.modules.competencias.repositories.competition_registration_repository import CompetitionRegistrationRepository
from app.modules.auth.repositories.user_repository import UserRepository
from app.modules.auth.models.user_model import RoleEnum
from app.modules.competencias.domain.schemas.schemas import (
    TimeRecordCreate,
    TimeRecordUpdate,
    TimeRecordResponse,
    TimeRecordListResponse
)


class TimeRecordService:
    """
    Service for managing time records
    Los moderadores registran tiempos de participantes durante las competencias
    """

    def __init__(self, session: AsyncSession):
        self.repository = TimeRecordRepository(session)
        self.registration_repository = CompetitionRegistrationRepository(session)
        self.user_repository = UserRepository(session)
        self.session = session

    async def create_time_record(
        self, 
        time_record_data: TimeRecordCreate,
        user_dni: str
    ) -> TimeRecordResponse:
        """
        Crea un nuevo registro de tiempo - Solo moderadores/admins
        """
        # Verificar que el usuario es moderador o admin
        user = await self.user_repository.get_by_dni(user_dni)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with DNI {user_dni} not found"
            )
        
        if user.role not in [RoleEnum.MODERATOR, RoleEnum.ADMINISTRATOR]:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Only moderators and administrators can record times"
            )

        # Verificar que el competition_registration existe
        registration = await self.registration_repository.get_by_id(time_record_data.competition_registration_id)
        if not registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competition registration with id {time_record_data.competition_registration_id} not found"
            )
        
        # Verificar que la competencia esté activa
        if not registration.competence.is_active:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Competition is not active"
            )
        
        # Crear el registro
        time_record = await self.repository.create(time_record_data)
        
        await self.session.commit()
        await self.session.refresh(time_record)
        
        return TimeRecordResponse.model_validate(time_record)

    async def get_time_record(self, time_record_id: int) -> TimeRecordResponse:
        """Obtiene un registro de tiempo por ID"""
        time_record = await self.repository.get_by_id(time_record_id)
        if not time_record:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        return TimeRecordResponse.model_validate(time_record)

    async def get_time_records_by_registration(
        self,
        competition_registration_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> TimeRecordListResponse:
        """Obtiene registros de tiempo de un competition registration específico"""
        registration = await self.registration_repository.get_by_id(competition_registration_id)
        if not registration:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competition registration with id {competition_registration_id} not found"
            )

        time_records = await self.repository.get_by_competition_registration(
            competition_registration_id=competition_registration_id,
            skip=skip,
            limit=limit
        )
        total = await self.repository.count_by_competition_registration(competition_registration_id)
        
        return TimeRecordListResponse(
            time_records=[TimeRecordResponse.model_validate(tr) for tr in time_records],
            total=total
        )

    async def get_all_time_records(
        self,
        skip: int = 0,
        limit: int = 100
    ) -> TimeRecordListResponse:
        """Obtiene todos los registros de tiempo"""
        time_records = await self.repository.get_all(skip=skip, limit=limit)
        total = await self.repository.count_all()
        
        return TimeRecordListResponse(
            time_records=[TimeRecordResponse.model_validate(tr) for tr in time_records],
            total=total
        )

    async def update_time_record(
        self,
        time_record_id: int,
        time_record_data: TimeRecordUpdate
    ) -> TimeRecordResponse:
        """Actualiza un registro de tiempo"""
        time_record = await self.repository.update(time_record_id, time_record_data)
        if not time_record:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        
        await self.session.commit()
        await self.session.refresh(time_record)
        
        return TimeRecordResponse.model_validate(time_record)

    async def delete_time_record(self, time_record_id: int) -> dict:
        """Elimina un registro de tiempo"""
        time_record = await self.repository.get_by_id(time_record_id)
        if not time_record:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        
        deleted = await self.repository.delete(time_record_id)
        if not deleted:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        
        await self.session.commit()
        
        return {"message": "Time record deleted successfully"}
