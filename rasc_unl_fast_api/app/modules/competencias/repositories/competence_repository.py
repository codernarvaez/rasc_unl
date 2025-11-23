from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from typing import List, Optional
from app.modules.competencias.domain.models import CompetenceModel
from app.modules.competencias.domain.schemas.schemas import CompetenceCreate, CompetenceUpdate


class CompetenceRepository:
    """
    Repository for database operations related to Competences
    """

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, competence_data: CompetenceCreate, created_by_dni: str) -> CompetenceModel:
        """Crea una nueva competencia"""
        competence = CompetenceModel(
            **competence_data.model_dump(),
            created_by=created_by_dni
        )
        self.session.add(competence)
        await self.session.flush()
        await self.session.refresh(competence)
        return competence

    async def get_by_id(self, competence_id: int) -> Optional[CompetenceModel]:
        """Gets a competence by its ID"""
        result = await self.session.execute(
            select(CompetenceModel).where(CompetenceModel.id == competence_id)
        )
        return result.scalar_one_or_none()

    async def get_all(
        self,
        skip: int = 0,
        limit: int = 100,
        is_active: Optional[bool] = None
    ) -> List[CompetenceModel]:
        """Gets all competences with pagination and optional filters"""
        query = select(CompetenceModel)
        
        if is_active is not None:
            query = query.where(CompetenceModel.is_active == is_active)
        
        query = query.offset(skip).limit(limit).order_by(CompetenceModel.created_at.desc())
        
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def count(self, is_active: Optional[bool] = None) -> int:
        """Counts total competences"""
        query = select(func.count(CompetenceModel.id))
        
        if is_active is not None:
            query = query.where(CompetenceModel.is_active == is_active)
        
        result = await self.session.execute(query)
        return result.scalar_one()

    async def update(
        self,
        competence_id: int,
        competence_data: CompetenceUpdate
    ) -> Optional[CompetenceModel]:
        """Updates an existing competence"""
        competence = await self.get_by_id(competence_id)
        if not competence:
            return None

        # Update only provided fields
        update_data = competence_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(competence, field, value)

        await self.session.flush()
        await self.session.refresh(competence)
        return competence

    async def delete(self, competence_id: int) -> bool:
        """Deletes a competence"""
        competence = await self.get_by_id(competence_id)
        if not competence:
            return False

        await self.session.delete(competence)
        await self.session.flush()
        return True

    async def check_is_active(self, competence_id: int) -> bool:
        """Checks if a competence is active"""
        from app.modules.competencias.domain.models import CompetitionRegistrationModel
        
        competence = await self.get_by_id(competence_id)
        if not competence or not competence.is_active:
            return False
        
        return True
