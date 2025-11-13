from sqlalchemy.ext.asyncio import AsyncSession
from typing import List, Optional
from app.modules.competencias.repositories.competencias_repository import CompetenceRepository
from app.modules.competencias.domain.schemas.schemas import (
    CompetenceCreate,
    CompetenceUpdate,
    CompetenceResponse,
    CompetenceListResponse
)
from fastapi import HTTPException, status


class CompetenceService:
    """
    Service for Competence business logic
    """

    def __init__(self, session: AsyncSession):
        self.repository = CompetenceRepository(session)
        self.session = session

    async def create_competence(self, competence_data: CompetenceCreate) -> CompetenceResponse:
        """Creates a new competence"""
        competence = await self.repository.create(competence_data)
        await self.session.commit()
        
        return CompetenceResponse.model_validate(competence)

    async def get_competence(self, competence_id: int) -> CompetenceResponse:
        """Gets a competence by ID"""
        competence = await self.repository.get_by_id(competence_id)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )
        return CompetenceResponse.model_validate(competence)

    async def get_all_competences(
        self,
        skip: int = 0,
        limit: int = 100,
        is_active: Optional[bool] = None
    ) -> CompetenceListResponse:
        """Gets all competences with pagination"""
        competences = await self.repository.get_all(skip=skip, limit=limit, is_active=is_active)
        total = await self.repository.count(is_active=is_active)
        
        return CompetenceListResponse(
            competences=[CompetenceResponse.model_validate(comp) for comp in competences],
            total=total
        )

    async def update_competence(
        self,
        competence_id: int,
        competence_data: CompetenceUpdate
    ) -> CompetenceResponse:
        """Updates a competence"""
        competence = await self.repository.update(competence_id, competence_data)
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )

        await self.session.commit()
        return CompetenceResponse.model_validate(competence)

    async def delete_competence(self, competence_id: int) -> dict:
        """Deletes a competence"""
        success = await self.repository.delete(competence_id)
        if not success:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )

        await self.session.commit()
        return {"message": "Competence deleted successfully"}
