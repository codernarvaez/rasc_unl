from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db.database import get_session
from app.modules.competencias.services.competence_service import CompetenceService
from app.modules.competencias.services.competition_registration_service import CompetitionRegistrationService
from app.modules.competencias.services.time_records_service import TimeRecordService


async def get_competence_service(
    session: AsyncSession = Depends(get_session)
) -> CompetenceService:
    """Dependency to get the Competence service"""
    return CompetenceService(session)


async def get_competition_registration_service(
    session: AsyncSession = Depends(get_session)
) -> CompetitionRegistrationService:
    """Dependency to get the Competition Registration service"""
    return CompetitionRegistrationService(session)


async def get_time_record_service(
    session: AsyncSession = Depends(get_session)
) -> TimeRecordService:
    """Dependency to get the Time Record service"""
    return TimeRecordService(session)
