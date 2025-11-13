from typing import List, Optional
from fastapi import HTTPException, status
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
        competence_repository: CompetenceRepository
    ):
        self.time_record_repository = time_record_repository
        self.competence_repository = competence_repository

    async def create_time_record(
        self, 
        time_record_data: CompetitionTimeRecordCreate
    ) -> CompetitionTimeRecordResponse:
        """Creates a new time record"""
        # Verify competence exists
        competence = await self.competence_repository.get_by_id(time_record_data.competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with id {time_record_data.competence_id} not found"
            )

        # Check max_registrations limit if registration_number is provided
        if time_record_data.registration_number and competence.max_registrations:
            count = await self.time_record_repository.count_by_competence_and_registration(
                competence_id=time_record_data.competence_id,
                registration_number=time_record_data.registration_number
            )
            if count >= competence.max_registrations:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Maximum number of time records ({competence.max_registrations}) reached for registration number '{time_record_data.registration_number}'"
                )

        time_record = await self.time_record_repository.create(time_record_data)
        return CompetitionTimeRecordResponse.model_validate(time_record)

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
