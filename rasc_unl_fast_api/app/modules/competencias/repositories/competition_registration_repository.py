from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from sqlalchemy.orm import joinedload
from typing import List, Optional
from app.modules.competencias.domain.models import CompetitionRegistrationModel
from app.modules.competencias.domain.schemas.schemas import CompetitionRegistrationCreate, CompetitionRegistrationUpdate


class CompetitionRegistrationRepository:
    """
    Repository for database operations related to Competition Registrations
    """

    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(
        self, 
        registration_data: CompetitionRegistrationCreate,
        user_dni: str
    ) -> CompetitionRegistrationModel:
        """Crea un nuevo registro de equipo en competencia"""
        registration = CompetitionRegistrationModel(
            **registration_data.model_dump(exclude={'user_dni'}),
            user_dni=user_dni
        )
        self.session.add(registration)
        await self.session.flush()
        await self.session.refresh(registration)
        return registration

    async def get_by_id(self, registration_id: str) -> Optional[CompetitionRegistrationModel]:
        """Gets a registration by its ID with eager loading of competence"""
        result = await self.session.execute(
            select(CompetitionRegistrationModel)
            .options(joinedload(CompetitionRegistrationModel.competence))
            .where(CompetitionRegistrationModel.id == registration_id)
        )
        return result.scalar_one_or_none()

    async def get_all(
        self,
        skip: int = 0,
        limit: int = 100,
        competence_id: Optional[str] = None
    ) -> List[CompetitionRegistrationModel]:
        """Gets all registrations with pagination and optional filters"""
        query = select(CompetitionRegistrationModel)
        
        if competence_id is not None:
            query = query.where(CompetitionRegistrationModel.competence_id == competence_id)
        
        query = query.offset(skip).limit(limit).order_by(CompetitionRegistrationModel.created_at.desc())
        
        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def get_by_competence(
        self,
        competence_id: str,
        skip: int = 0,
        limit: int = 100
    ) -> List[CompetitionRegistrationModel]:
        """Gets all registrations for a specific competence"""
        return await self.get_all(skip=skip, limit=limit, competence_id=competence_id)

    async def count(self, competence_id: Optional[str] = None) -> int:
        """Counts total registrations"""
        query = select(func.count(CompetitionRegistrationModel.id))
        
        if competence_id is not None:
            query = query.where(CompetitionRegistrationModel.competence_id == competence_id)
        
        result = await self.session.execute(query)
        return result.scalar_one()

    async def update(
        self,
        registration_id: str,
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

    async def delete(self, registration_id: str) -> bool:
        """Deletes a registration"""
        registration = await self.get_by_id(registration_id)
        if not registration:
            return False

        await self.session.delete(registration)
        await self.session.flush()
        return True

    async def get_by_dorsal_and_competence(
        self,
        dorsal_number: str,
        competence_id: str,
        exclude_id: Optional[str] = None
    ) -> Optional[CompetitionRegistrationModel]:
        """Verifica si un número de dorsal ya está registrado en una competencia
        
        Args:
            dorsal_number: Número de dorsal a verificar
            competence_id: ID de la competencia
            exclude_id: ID del registro a excluir (útil al editar)
        """
        conditions = [
            CompetitionRegistrationModel.competence_id == competence_id,
            CompetitionRegistrationModel.dorsal_number == dorsal_number
        ]
        
        if exclude_id:
            conditions.append(CompetitionRegistrationModel.id != exclude_id)
        
        result = await self.session.execute(
            select(CompetitionRegistrationModel).where(and_(*conditions))
        )
        return result.scalar_one_or_none()

    async def get_by_user_and_competence(
        self,
        user_dni: str,
        competence_id: str,
        exclude_id: Optional[str] = None
    ) -> Optional[CompetitionRegistrationModel]:
        """Verifica si un usuario ya tiene un equipo registrado en una competencia
        
        Args:
            user_dni: DNI del usuario a verificar
            competence_id: ID de la competencia
            exclude_id: ID del registro a excluir (útil al editar)
        """
        conditions = [
            CompetitionRegistrationModel.competence_id == competence_id,
            CompetitionRegistrationModel.user_dni == user_dni
        ]
        
        if exclude_id:
            conditions.append(CompetitionRegistrationModel.id != exclude_id)
        
        result = await self.session.execute(
            select(CompetitionRegistrationModel).where(and_(*conditions))
        )
        return result.scalar_one_or_none()
