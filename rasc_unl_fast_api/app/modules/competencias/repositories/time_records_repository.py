from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func
from typing import List, Optional
from app.modules.competencias.domain.models.time_record_model import CompetitionTimeRecordModel
from app.modules.competencias.domain.schemas.schemas import CompetitionTimeRecordCreate, CompetitionTimeRecordUpdate


class CompetitionTimeRecordRepository:
    """Repository para manejar registros de tiempo de competencias"""

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, time_record_data: CompetitionTimeRecordCreate) -> CompetitionTimeRecordModel:
        """Creates a new time record"""
        time_record = CompetitionTimeRecordModel(
            registration_number=time_record_data.registration_number,
            time=time_record_data.time,
            competence_id=time_record_data.competence_id,
        )
        self.session.add(time_record)
        await self.session.commit()
        await self.session.refresh(time_record)
        return time_record

    async def get_by_id(self, time_record_id: int) -> Optional[CompetitionTimeRecordModel]:
        """Gets a time record by ID"""
        result = await self.session.execute(
            select(CompetitionTimeRecordModel).where(CompetitionTimeRecordModel.id == time_record_id)
        )
        return result.scalar_one_or_none()

    async def get_by_competence_id(
        self, 
        competence_id: int, 
        registration_number: Optional[str] = None,
        skip: int = 0, 
        limit: int = 100
    ) -> tuple[List[CompetitionTimeRecordModel], int]:
        """Gets time records by competence ID, optionally filtered by registration number"""
        query = select(CompetitionTimeRecordModel).where(
            CompetitionTimeRecordModel.competence_id == competence_id
        )
        
        if registration_number:
            query = query.where(CompetitionTimeRecordModel.registration_number == registration_number)
        
        # Get total count
        count_query = select(func.count()).select_from(query.subquery())
        total_result = await self.session.execute(count_query)
        total = total_result.scalar()
        
        # Get paginated results
        query = query.offset(skip).limit(limit).order_by(CompetitionTimeRecordModel.time.asc())
        result = await self.session.execute(query)
        time_records = result.scalars().all()
        
        return list(time_records), total

    async def get_all(
        self, 
        skip: int = 0, 
        limit: int = 100
    ) -> tuple[List[CompetitionTimeRecordModel], int]:
        """Gets all time records with pagination"""
        # Get total count
        count_result = await self.session.execute(
            select(func.count()).select_from(CompetitionTimeRecordModel)
        )
        total = count_result.scalar()
        
        # Get paginated results
        result = await self.session.execute(
            select(CompetitionTimeRecordModel)
            .offset(skip)
            .limit(limit)
            .order_by(CompetitionTimeRecordModel.created_at.desc())
        )
        time_records = result.scalars().all()
        
        return list(time_records), total

    async def update(
        self, 
        time_record_id: int, 
        time_record_data: CompetitionTimeRecordUpdate
    ) -> Optional[CompetitionTimeRecordModel]:
        """Updates an existing time record"""
        time_record = await self.get_by_id(time_record_id)
        if not time_record:
            return None

        update_data = time_record_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(time_record, key, value)

        await self.session.commit()
        await self.session.refresh(time_record)
        return time_record

    async def delete(self, time_record_id: int) -> bool:
        """Deletes a time record"""
        time_record = await self.get_by_id(time_record_id)
        if not time_record:
            return False

        await self.session.delete(time_record)
        await self.session.commit()
        return True

    async def count_by_competence_and_registration(
        self, 
        competence_id: int, 
        registration_number: str
    ) -> int:
        """Counts time records for a specific competence and registration number"""
        result = await self.session.execute(
            select(func.count()).select_from(CompetitionTimeRecordModel).where(
                CompetitionTimeRecordModel.competence_id == competence_id,
                CompetitionTimeRecordModel.registration_number == registration_number
            )
        )
        return result.scalar()
