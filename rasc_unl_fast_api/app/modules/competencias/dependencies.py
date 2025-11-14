from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db.database import get_session
from app.modules.competencias.services.competencias_service import CompetenceService
from app.modules.competencias.services.registros_service import CompetitionRegistrationService
from app.modules.competencias.services.time_records_service import CompetitionTimeRecordService
from app.modules.competencias.services.timer_service import TimerService
from app.modules.competencias.repositories.time_records_repository import CompetitionTimeRecordRepository
from app.modules.competencias.repositories.competencias_repository import CompetenceRepository


async def get_competence_service(
    session: AsyncSession = Depends(get_session)
) -> CompetenceService:
    """
    Dependency to get the Competence service
    """
    return CompetenceService(session)


async def get_competition_registration_service(
    session: AsyncSession = Depends(get_session)
) -> CompetitionRegistrationService:
    """
    Dependency to get the Competition Registration service
    """
    return CompetitionRegistrationService(session)


async def get_competition_time_record_service(
    session: AsyncSession = Depends(get_session)
) -> CompetitionTimeRecordService:
    """
    Dependency to get the Competition Time Record service
    """
    time_record_repository = CompetitionTimeRecordRepository(session)
    competence_repository = CompetenceRepository(session)
    return CompetitionTimeRecordService(time_record_repository, competence_repository, session)


async def get_timer_service(
    session: AsyncSession = Depends(get_session)
) -> TimerService:
    """
    Dependency to get the Timer service
    """
    return TimerService(session)
