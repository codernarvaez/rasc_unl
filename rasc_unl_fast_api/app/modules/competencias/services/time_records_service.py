from typing import List, Optional
from fastapi import HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.modules.competencias.repositories.time_records_repository import CompetitionTimeRecordRepository
from app.modules.competencias.repositories.competencias_repository import CompetenceRepository
from app.modules.competencias.domain.schemas.schemas import (
    CompetitionTimeRecordCreate,
    CompetitionTimeRecordUpdate,
    CompetitionTimeRecordResponse,
)
from app.modules.competencias.domain.models.time_record_model import CompetitionTimeRecordModel


class CompetitionTimeRecordService:
    """Service for managing competition time records"""

    def __init__(
        self, 
        time_record_repository: CompetitionTimeRecordRepository,
        competence_repository: CompetenceRepository,
        session: AsyncSession
    ):
        self.time_record_repository = time_record_repository
        self.competence_repository = competence_repository
        self.session = session

    async def create_time_record(
        self, 
        time_record_data: CompetitionTimeRecordCreate
    ) -> CompetitionTimeRecordResponse:
        """
        Creates a new time record.
        Implementa lógica de consenso: el primer registro del moderador es la referencia.
        """
        # Verify competence exists and timer has started
        competence = await self.competence_repository.get_by_id(time_record_data.competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with id {time_record_data.competence_id} not found"
            )
        
        if not competence.timer_started:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Competition timer has not started yet"
            )

        # Check if this is the first time record (reference time)
        existing_records, total = await self.time_record_repository.get_by_competence_id(
            competence_id=time_record_data.competence_id,
            registration_number=None,
            skip=0,
            limit=1
        )
        
        is_reference = total == 0  # Primer registro = referencia
        
        # Check max_registrations limit per moderator
        if competence.max_registrations:
            moderator_count = await self.time_record_repository.count_by_moderator(
                competence_id=time_record_data.competence_id,
                recorded_by_dni=time_record_data.recorded_by_dni
            )
            if moderator_count >= competence.max_registrations:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Maximum number of time records ({competence.max_registrations}) reached for this moderator"
                )
        
        # Crear el registro con is_reference
        time_record = await self.time_record_repository.create(time_record_data, is_reference=is_reference)
        
        # Si no es el primer registro, recalcular posiciones
        if not is_reference:
            await self._recalculate_positions(time_record_data.competence_id)
        
        await self.session.commit()
        await self.session.refresh(time_record)
        
        return CompetitionTimeRecordResponse.model_validate(time_record)
    
    async def _recalculate_positions(self, competence_id: int):
        """
        Recalcula las posiciones de todos los registros de una competencia.
        Ordena por tiempo ascendente y asigna posiciones.
        """
        all_records, _ = await self.time_record_repository.get_by_competence_id(
            competence_id=competence_id,
            registration_number=None,
            skip=0,
            limit=10000  # Obtener todos
        )
        
        # Ordenar por tiempo ascendente
        sorted_records = sorted(all_records, key=lambda r: r.time)
        
        # Asignar posiciones
        for index, record in enumerate(sorted_records, start=1):
            record.position = index
        
        await self.session.flush()
    
    async def get_reference_time(self, competence_id: int) -> Optional[int]:
        """
        Obtiene el tiempo de referencia (primer registro del moderador) para una competencia.
        
        Returns:
            Tiempo en milisegundos del registro de referencia, None si no existe
        """
        reference_record = await self.time_record_repository.get_reference_record(competence_id)
        
        if reference_record:
            return reference_record.time
        
        return None

    async def get_time_record(self, time_record_id: int) -> CompetitionTimeRecordResponse:
        """Gets a time record by ID"""
        time_record = await self.time_record_repository.get_by_id(time_record_id)
        if not time_record:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        return CompetitionTimeRecordResponse.model_validate(time_record)

    async def get_time_records_by_competence(
        self,
        competence_id: int,
        registration_number: Optional[str] = None,
        skip: int = 0,
        limit: int = 100
    ) -> tuple[List[CompetitionTimeRecordResponse], int]:
        """Gets time records for a specific competence"""
        # Verify competence exists
        competence = await self.competence_repository.get_by_id(competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with id {competence_id} not found"
            )

        time_records, total = await self.time_record_repository.get_by_competence_id(
            competence_id=competence_id,
            registration_number=registration_number,
            skip=skip,
            limit=limit
        )
        return [CompetitionTimeRecordResponse.model_validate(tr) for tr in time_records], total

    async def get_all_time_records(
        self,
        skip: int = 0,
        limit: int = 100
    ) -> tuple[List[CompetitionTimeRecordResponse], int]:
        """Gets all time records"""
        time_records, total = await self.time_record_repository.get_all(skip=skip, limit=limit)
        return [CompetitionTimeRecordResponse.model_validate(tr) for tr in time_records], total

    async def update_time_record(
        self,
        time_record_id: int,
        time_record_data: CompetitionTimeRecordUpdate
    ) -> CompetitionTimeRecordResponse:
        """Updates a time record"""
        time_record = await self.time_record_repository.update(time_record_id, time_record_data)
        if not time_record:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        return CompetitionTimeRecordResponse.model_validate(time_record)

    async def delete_time_record(self, time_record_id: int) -> dict:
        """Deletes a time record"""
        deleted = await self.time_record_repository.delete(time_record_id)
        if not deleted:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Time record with id {time_record_id} not found"
            )
        return {"message": "Time record deleted successfully"}
