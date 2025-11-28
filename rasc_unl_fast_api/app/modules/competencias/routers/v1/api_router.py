from fastapi import APIRouter, Depends, Query, status
from typing import Optional
from app.modules.auth.dependencies import (
    CurrentUser,
    AdminUser,
    AdminOrModeratorUser
)
from app.modules.competencias.dependencies import (
    get_competence_service, 
    get_competition_registration_service,
    get_time_record_service
)
from app.modules.competencias.services.competence_service import CompetenceService
from app.modules.competencias.services.competition_registration_service import CompetitionRegistrationService
from app.modules.competencias.services.time_records_service import TimeRecordService
from app.modules.competencias.domain.schemas.schemas import (
    CompetenceCreate,
    CompetenceUpdate,
    CompetenceResponse,
    CompetenceListResponse,
    CompetitionRegistrationCreate,
    CompetitionRegistrationUpdate,
    CompetitionRegistrationResponse,
    CompetitionRegistrationListResponse,
    TimeRecordCreate,
    TimeRecordUpdate,
    TimeRecordResponse,
    TimeRecordListResponse
)


# Router for competences
api_competencias_router_v1 = APIRouter(prefix="/competencias", tags=["Competencias V1"])


# ============================================
# ENDPOINTS DE COMPETENCIAS - SOLO ADMINISTRADORES
# ============================================

@api_competencias_router_v1.post(
    "/",
    response_model=CompetenceResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Crear una nueva competencia",
    description="Crea una nueva competencia en el sistema (Solo administradores)"
)
async def create_competence(
    competence_data: CompetenceCreate,
    current_user: AdminUser,
    service: CompetenceService = Depends(get_competence_service)
):
    """
    Crea una nueva competencia. Solo administradores.
    """
    return await service.create_competence(competence_data, current_user.dni)


@api_competencias_router_v1.get(
    "/",
    response_model=CompetenceListResponse,
    summary="Obtener todas las competencias",
    description="Obtiene una lista paginada de competencias"
)
async def get_competences(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    is_active: Optional[bool] = Query(None),
    service: CompetenceService = Depends(get_competence_service)
):
    """Obtiene todas las competencias con paginación y filtros opcionales."""
    return await service.get_all_competences(skip=skip, limit=limit, is_active=is_active)


@api_competencias_router_v1.get(
    "/{competence_id}",
    response_model=CompetenceResponse,
    summary="Obtener una competencia por ID"
)
async def get_competence(
    competence_id: str,
    service: CompetenceService = Depends(get_competence_service)
):
    """Obtiene una competencia específica por su ID."""
    return await service.get_competence(competence_id)


@api_competencias_router_v1.patch(
    "/{competence_id}",
    response_model=CompetenceResponse,
    summary="Actualizar una competencia",
    description="Actualiza una competencia existente (Solo administradores)"
)
async def update_competence(
    competence_id: str,
    competence_data: CompetenceUpdate,
    current_user: AdminUser,
    service: CompetenceService = Depends(get_competence_service)
):
    """Actualiza una competencia. Solo administradores."""
    return await service.update_competence(competence_id, competence_data)


@api_competencias_router_v1.delete(
    "/{competence_id}",
    summary="Eliminar una competencia",
    description="Elimina una competencia (Solo administradores)"
)
async def delete_competence(
    competence_id: str,
    current_user: AdminUser,
    service: CompetenceService = Depends(get_competence_service)
):
    """Elimina una competencia. Solo administradores."""
    return await service.delete_competence(competence_id)


# ============================================
# ENDPOINTS DE REGISTROS - MODERADORES/ADMINS
# ============================================

@api_competencias_router_v1.post(
    "/{competence_id}/registrations",
    response_model=CompetitionRegistrationResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar equipo en competencia",
    description="Los moderadores registran equipos con dorsal, nombre y n_participantes"
)
async def create_registration(
    competence_id: str,
    registration_data: CompetitionRegistrationCreate,
    current_user: AdminOrModeratorUser,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """
    Registra un equipo en una competencia. Solo moderadores/admins.
    Se debe especificar: dorsal_number, name, n_participants
    """
    # Asegurar que el competence_id del path coincida
    registration_data.competence_id = competence_id
    return await service.create_registration(registration_data, current_user.dni)


@api_competencias_router_v1.get(
    "/{competence_id}/registrations",
    response_model=CompetitionRegistrationListResponse,
    summary="Obtener registros de una competencia"
)
async def get_registrations_by_competence(
    competence_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """Obtiene todos los registros de una competencia específica."""
    return await service.get_registrations_by_competence(competence_id, skip, limit)


@api_competencias_router_v1.get(
    "/registrations/{registration_id}",
    response_model=CompetitionRegistrationResponse,
    summary="Obtener un registro por ID"
)
async def get_registration(
    registration_id: str,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """Obtiene un registro específico por su ID."""
    return await service.get_registration(registration_id)


@api_competencias_router_v1.patch(
    "/registrations/{registration_id}",
    response_model=CompetitionRegistrationResponse,
    summary="Actualizar un registro"
)
async def update_registration(
    registration_id: str,
    registration_data: CompetitionRegistrationUpdate,
    current_user: AdminOrModeratorUser,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """Actualiza un registro. Solo moderadores/admins."""
    return await service.update_registration(registration_id, registration_data)


@api_competencias_router_v1.delete(
    "/registrations/{registration_id}",
    summary="Eliminar un registro"
)
async def delete_registration(
    registration_id: str,
    current_user: AdminOrModeratorUser,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """Elimina un registro. Solo moderadores/admins."""
    return await service.delete_registration(registration_id)


# ============================================
# ENDPOINTS DE TIME RECORDS - MODERADORES/ADMINS
# ============================================

@api_competencias_router_v1.post(
    "/registrations/{registration_id}/time-records",
    response_model=TimeRecordResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar tiempo",
    description="Los moderadores registran tiempos de participantes"
)
async def create_time_record(
    registration_id: str,
    time_record_data: TimeRecordCreate,
    current_user: AdminOrModeratorUser,
    service: TimeRecordService = Depends(get_time_record_service)
):
    """
    Registra un tiempo para un competition_registration. Solo moderadores/admins.
    """
    time_record_data.competition_registration_id = registration_id
    return await service.create_time_record(time_record_data, current_user.dni)


@api_competencias_router_v1.get(
    "/registrations/{registration_id}/time-records",
    response_model=TimeRecordListResponse,
    summary="Obtener registros de tiempo de un registration"
)
async def get_time_records_by_registration(
    registration_id: str,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    service: TimeRecordService = Depends(get_time_record_service)
):
    """Obtiene todos los registros de tiempo de un competition registration."""
    return await service.get_time_records_by_registration(registration_id, skip, limit)


@api_competencias_router_v1.get(
    "/time-records/{time_record_id}",
    response_model=TimeRecordResponse,
    summary="Obtener un registro de tiempo por ID"
)
async def get_time_record(
    time_record_id: str,
    service: TimeRecordService = Depends(get_time_record_service)
):
    """Obtiene un registro de tiempo específico."""
    return await service.get_time_record(time_record_id)


@api_competencias_router_v1.patch(
    "/time-records/{time_record_id}",
    response_model=TimeRecordResponse,
    summary="Actualizar un registro de tiempo"
)
async def update_time_record(
    time_record_id: str,
    time_record_data: TimeRecordUpdate,
    current_user: AdminOrModeratorUser,
    service: TimeRecordService = Depends(get_time_record_service)
):
    """Actualiza un registro de tiempo. Solo moderadores/admins."""
    return await service.update_time_record(time_record_id, time_record_data)


@api_competencias_router_v1.delete(
    "/time-records/{time_record_id}",
    summary="Eliminar un registro de tiempo"
)
async def delete_time_record(
    time_record_id: str,
    current_user: AdminOrModeratorUser,
    service: TimeRecordService = Depends(get_time_record_service)
):
    """Elimina un registro de tiempo. Solo moderadores/admins."""
    return await service.delete_time_record(time_record_id)
