from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy import func
from typing import List, Optional
from app.modules.competencias.domain.models.time_record_model import TimeRecordModel
from app.modules.competencias.domain.schemas.schemas import TimeRecordCreate, TimeRecordUpdate


class TimeRecordRepository:
    """Repository para manejar registros de tiempo de competencias"""

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, time_record_data: TimeRecordCreate) -> TimeRecordModel:
        """Crea un nuevo registro de tiempo"""
        time_record = TimeRecordModel(
            time=time_record_data.time,
            competition_registration_id=time_record_data.competition_registration_id,
        )
        self.session.add(time_record)
        await self.session.flush()
        return time_record

    async def get_by_id(self, time_record_id: int) -> Optional[TimeRecordModel]:
        """Obtiene un registro de tiempo por ID"""
        result = await self.session.execute(
            select(TimeRecordModel).where(TimeRecordModel.id == time_record_id)
        )
        return result.scalar_one_or_none()

    async def get_by_competition_registration(
        self, 
        competition_registration_id: int,
        skip: int = 0, 
        limit: int = 100
    ) -> List[TimeRecordModel]:
        """Obtiene registros de tiempo por registration con paginación"""
        query = select(TimeRecordModel).where(
            TimeRecordModel.competition_registration_id == competition_registration_id
        ).offset(skip).limit(limit).order_by(TimeRecordModel.created_at.asc())
        
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def count_by_competition_registration(self, competition_registration_id: int) -> int:
        """Cuenta registros de tiempo de un registration"""
        result = await self.session.execute(
            select(func.count()).select_from(TimeRecordModel).where(
                TimeRecordModel.competition_registration_id == competition_registration_id
            )
        )
        return result.scalar()

    async def get_all(self, skip: int = 0, limit: int = 100) -> List[TimeRecordModel]:
        """Obtiene todos los registros de tiempo con paginación"""
        result = await self.session.execute(
            select(TimeRecordModel)
            .offset(skip)
            .limit(limit)
            .order_by(TimeRecordModel.created_at.desc())
        )
        return list(result.scalars().all())
    
    async def count_all(self) -> int:
        """Cuenta todos los registros de tiempo"""
        result = await self.session.execute(
            select(func.count()).select_from(TimeRecordModel)
        )
        return result.scalar()

    async def update(
        self, 
        time_record_id: int, 
        time_record_data: TimeRecordUpdate
    ) -> Optional[TimeRecordModel]:
        """Actualiza un registro de tiempo existente"""
        time_record = await self.get_by_id(time_record_id)
        if not time_record:
            return None

        update_data = time_record_data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(time_record, key, value)

        await self.session.flush()
        await self.session.refresh(time_record)
        return time_record

    async def delete(self, time_record_id: int) -> bool:
        """Elimina un registro de tiempo"""
        time_record = await self.get_by_id(time_record_id)
        if not time_record:
            return False

        await self.session.delete(time_record)
        await self.session.flush()
        return True
