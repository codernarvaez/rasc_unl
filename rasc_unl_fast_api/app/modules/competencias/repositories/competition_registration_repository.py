from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from typing import List, Optional
from app.modules.competencias.domain.models import CompetitionRegistrationModel
from app.modules.competencias.domain.schemas.schemas import CompetitionRegistrationCreate, CompetitionRegistrationUpdate


class CompetitionRegistrationRepository:
    """
    Repository for database operations related to Competition Registrations
    """

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, registration_data: CompetitionRegistrationCreate) -> CompetitionRegistrationModel:
        """Creates a new competition registration"""
        registration = CompetitionRegistrationModel(**registration_data.model_dump())
        self.session.add(registration)
        await self.session.flush()
        await self.session.refresh(registration)
        return registration

    async def get_by_id(self, registration_id: int) -> Optional[CompetitionRegistrationModel]:
        """Gets a registration by its ID"""
        result = await self.session.execute(
            select(CompetitionRegistrationModel).where(CompetitionRegistrationModel.id == registration_id)
        )
        return result.scalar_one_or_none()

    async def get_all(
        self,
        skip: int = 0,
        limit: int = 100,
        competence_id: Optional[int] = None,
        user_dni: Optional[str] = None
    ) -> List[CompetitionRegistrationModel]:
        """Gets all registrations with pagination and optional filters"""
        query = select(CompetitionRegistrationModel)
        
        filters = []
        if competence_id is not None:
            filters.append(CompetitionRegistrationModel.competence_id == competence_id)
        if user_dni is not None:
            filters.append(CompetitionRegistrationModel.user_dni == user_dni)
        
        if filters:
            query = query.where(and_(*filters))
        
        query = query.offset(skip).limit(limit).order_by(CompetitionRegistrationModel.created_at.desc())
        
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def get_by_competence(
        self,
        competence_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> List[CompetitionRegistrationModel]:
        """Gets all registrations for a specific competence"""
        return await self.get_all(skip=skip, limit=limit, competence_id=competence_id)

    async def count(
        self,
        competence_id: Optional[int] = None,
        user_dni: Optional[str] = None
    ) -> int:
        """Counts total registrations"""
        query = select(func.count(CompetitionRegistrationModel.id))
        
        filters = []
        if competence_id is not None:
            filters.append(CompetitionRegistrationModel.competence_id == competence_id)
        if user_dni is not None:
            filters.append(CompetitionRegistrationModel.user_dni == user_dni)
        
        if filters:
            query = query.where(and_(*filters))
        
        result = await self.session.execute(query)
        return result.scalar_one()

    async def update(
        self,
        registration_id: int,
        registration_data: CompetitionRegistrationUpdate
    ) -> Optional[CompetitionRegistrationModel]:
        """Updates an existing registration"""
        registration = await self.get_by_id(registration_id)
        if not registration:
            return None

        # Update only provided fields
        update_data = registration_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(registration, field, value)

        await self.session.flush()
        await self.session.refresh(registration)
        return registration

    async def delete(self, registration_id: int) -> bool:
        """Deletes a registration"""
        registration = await self.get_by_id(registration_id)
        if not registration:
            return False

        await self.session.delete(registration)
        await self.session.flush()
        return True

    async def check_user_registered(
        self,
        competence_id: int,
        user_dni: str
    ) -> bool:
        """Checks if a user is already registered in a competence"""
        result = await self.session.execute(
            select(func.count(CompetitionRegistrationModel.id)).where(
                and_(
                    CompetitionRegistrationModel.competence_id == competence_id,
                    CompetitionRegistrationModel.user_dni == user_dni
                )
            )
        )
        count = result.scalar_one()
        return count > 0

    async def get_by_user_and_competence(
        self,
        competence_id: int,
        user_dni: str
    ) -> Optional[CompetitionRegistrationModel]:
        """Gets a registration by user DNI and competence"""
        result = await self.session.execute(
            select(CompetitionRegistrationModel).where(
                and_(
                    CompetitionRegistrationModel.competence_id == competence_id,
                    CompetitionRegistrationModel.user_dni == user_dni
                )
            )
        )
        return result.scalar_one_or_none()
