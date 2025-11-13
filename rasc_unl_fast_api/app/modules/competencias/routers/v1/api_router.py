from fastapi import APIRouter, Depends, Query, status
from typing import Optional
from app.modules.competencias.dependencies import (
    get_competence_service, 
    get_competition_registration_service,
    get_competition_time_record_service
)
from app.modules.competencias.services.competencias_service import CompetenceService
from app.modules.competencias.services.registros_service import CompetitionRegistrationService
from app.modules.competencias.services.time_records_service import CompetitionTimeRecordService
from app.modules.competencias.domain.schemas.schemas import (
    CompetenceCreate,
    CompetenceUpdate,
    CompetenceResponse,
    CompetenceListResponse,
    CompetitionRegistrationCreate,
    CompetitionRegistrationUpdate,
    CompetitionRegistrationResponse,
    CompetitionRegistrationListResponse,
    CompetitionTimeRecordCreate,
    CompetitionTimeRecordUpdate,
    CompetitionTimeRecordResponse,
    CompetitionTimeRecordListResponse
)
from app.modules.modules import APP_TAGS_V1


# Router for competences
api_competencias_router_v1 = APIRouter(prefix="/competencias", tags=["Competencias V1"])


# ============================================
# ENDPOINTS DE COMPETENCIAS
# ============================================

@api_competencias_router_v1.post(
    "/",
    response_model=CompetenceResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new competence",
    description="Creates a new competence in the system"
)
async def create_competence(
    competence_data: CompetenceCreate,
    service: CompetenceService = Depends(get_competence_service)
):
    """
    Creates a new competence with the following information:
    - **external_id**: External identifier (optional)
    - **name**: Name of the competence (required)
    - **competition_date**: Date of the competition (required)
    - **competition_limit_for_registration_date**: Registration deadline (optional)
    - **n_turns**: Number of turns (optional)
    - **is_active**: Competence status (default: true)
    - **created_by**: DNI of creator user (required)
    - **start_coordinates**: Start location coordinates (optional)
    - **finish_coordinates**: Finish location coordinates (optional)
    """
    return await service.create_competence(competence_data)


@api_competencias_router_v1.get(
    "/",
    response_model=CompetenceListResponse,
    summary="Get all competences",
    description="Gets a paginated list of competences with optional filters"
)
async def get_competences(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of records to return"),
    is_active: Optional[bool] = Query(None, description="Filter by active/inactive status"),
    service: CompetenceService = Depends(get_competence_service)
):
    """
    Gets all competences with pagination and optional filters.
    
    - **skip**: Number of records to skip (for pagination)
    - **limit**: Maximum number of records to return
    - **is_active**: Filter only active or inactive competences
    """
    return await service.get_all_competences(skip=skip, limit=limit, is_active=is_active)


# ============================================
# ENDPOINTS DE REGISTROS
# ============================================

@api_competencias_router_v1.post(
    "/registro",
    response_model=CompetitionRegistrationResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register user in a competence",
    description="Creates a new user registration in a competence"
)
async def create_registration(
    registration_data: CompetitionRegistrationCreate,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """
    Registers a user in a competence with the following information:
    - **external_id**: External identifier (optional)
    - **registration_number**: Unique registration number (optional)
    - **time**: Time in milliseconds (optional)
    - **n_turns**: Number of turns (optional)
    - **user_dni**: User DNI (required)
    - **competence_id**: ID of the competence (required)
    
    Validations:
    - The competence must exist and be active
    - The user cannot be already registered in the same competence
    """
    return await service.create_registration(registration_data)


@api_competencias_router_v1.get(
    "/registro",
    response_model=CompetitionRegistrationListResponse,
    summary="Get all registrations",
    description="Gets a paginated list of registrations with optional filters"
)
async def get_registrations(
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of records to return"),
    competence_id: Optional[int] = Query(None, description="Filter by competence ID"),
    user_dni: Optional[str] = Query(None, description="Filter by user DNI"),
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """
    Gets all registrations with pagination and optional filters.
    
    - **skip**: Number of records to skip (for pagination)
    - **limit**: Maximum number of records to return
    - **competence_id**: Filter registrations of a specific competence
    - **user_dni**: Filter by user DNI
    """
    return await service.get_all_registrations(
        skip=skip,
        limit=limit,
        competence_id=competence_id,
        user_dni=user_dni
    )


@api_competencias_router_v1.patch(
    "/registro/{registration_id}",
    response_model=CompetitionRegistrationResponse,
    summary="Update a registration",
    description="Partially updates the data of a registration"
)
async def update_registration(
    registration_id: int,
    registration_data: CompetitionRegistrationUpdate,
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """
    Updates the data of an existing registration.
    Only provided fields are updated.
    
    - **registration_id**: ID of the registration to update
    """
    return await service.update_registration(registration_id, registration_data)


# ============================================
# ENDPOINTS DE TIME RECORDS
# ============================================

@api_competencias_router_v1.post(
    "/time-records",
    status_code=status.HTTP_201_CREATED,
    response_model=CompetitionTimeRecordResponse,
    summary="Create a time record",
    description="Create a new time record for a competition"
)
async def create_time_record(
    time_record_data: CompetitionTimeRecordCreate,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Create a new time record for a competition.
    Validates that the competition exists and hasn't exceeded max_registrations.
    
    - **registration_number**: Optional identifier for the participant/team
    - **time**: Time in milliseconds
    - **competence_id**: ID of the competition
    """
    return await service.create_time_record(time_record_data)


@api_competencias_router_v1.get(
    "/time-records",
    response_model=CompetitionTimeRecordListResponse,
    summary="Get all time records",
    description="Get all time records with pagination"
)
async def get_all_time_records(
    skip: int = 0,
    limit: int = 100,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Get all time records with pagination.
    
    - **skip**: Number of records to skip (default: 0)
    - **limit**: Maximum number of records to return (default: 100)
    """
    return await service.get_all_time_records(skip, limit)


@api_competencias_router_v1.get(
    "/time-records/{time_record_id}",
    response_model=CompetitionTimeRecordResponse,
    summary="Get a time record by ID",
    description="Get a specific time record by its ID"
)
async def get_time_record(
    time_record_id: int,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Get a time record by its ID.
    
    - **time_record_id**: ID of the time record to retrieve
    """
    return await service.get_time_record(time_record_id)


@api_competencias_router_v1.patch(
    "/time-records/{time_record_id}",
    response_model=CompetitionTimeRecordResponse,
    summary="Update a time record",
    description="Partially updates the data of a time record"
)
async def update_time_record(
    time_record_id: int,
    time_record_data: CompetitionTimeRecordUpdate,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Updates the data of an existing time record.
    Only provided fields are updated.
    
    - **time_record_id**: ID of the time record to update
    """
    return await service.update_time_record(time_record_id, time_record_data)


@api_competencias_router_v1.delete(
    "/time-records/{time_record_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="Delete a time record",
    description="Delete a time record by its ID"
)
async def delete_time_record(
    time_record_id: int,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Delete a time record by its ID.
    
    - **time_record_id**: ID of the time record to delete
    """
    await service.delete_time_record(time_record_id)


# ============================================
# ENDPOINTS DE COMPETENCIAS CON PARÁMETROS DINÁMICOS
# (Deben ir al final para evitar conflictos de rutas)
# ============================================

@api_competencias_router_v1.get(
    "/{competence_id}",
    response_model=CompetenceResponse,
    summary="Get a competence by ID",
    description="Gets the details of a specific competence"
)
async def get_competence(
    competence_id: int,
    service: CompetenceService = Depends(get_competence_service)
):
    """
    Gets a specific competence by its ID.
    
    - **competence_id**: ID of the competence to get
    """
    return await service.get_competence(competence_id)


@api_competencias_router_v1.patch(
    "/{competence_id}",
    response_model=CompetenceResponse,
    summary="Update a competence",
    description="Partially updates the data of a competence"
)
async def update_competence(
    competence_id: int,
    competence_data: CompetenceUpdate,
    service: CompetenceService = Depends(get_competence_service)
):
    """
    Updates the data of an existing competence.
    Only provided fields are updated.
    
    - **competence_id**: ID of the competence to update
    """
    return await service.update_competence(competence_id, competence_data)


@api_competencias_router_v1.get(
    "/{competence_id}/registros",
    response_model=CompetitionRegistrationListResponse,
    summary="Get registrations of a competence",
    description="Gets all registrations associated with a specific competence"
)
async def get_registrations_by_competence(
    competence_id: int,
    skip: int = Query(0, ge=0, description="Number of records to skip"),
    limit: int = Query(100, ge=1, le=1000, description="Maximum number of records to return"),
    service: CompetitionRegistrationService = Depends(get_competition_registration_service)
):
    """
    Gets all registrations of a specific competence.
    
    - **competence_id**: ID of the competence
    - **skip**: Number of records to skip (for pagination)
    - **limit**: Maximum number of records to return
    """
    return await service.get_registrations_by_competence(
        competence_id=competence_id,
        skip=skip,
        limit=limit
    )


@api_competencias_router_v1.get(
    "/{competence_id}/time-records",
    response_model=CompetitionTimeRecordListResponse,
    summary="Get time records for a competition",
    description="Get all time records for a specific competition, optionally filtered by registration number"
)
async def get_time_records_by_competence(
    competence_id: int,
    registration_number: str | None = None,
    service: CompetitionTimeRecordService = Depends(get_competition_time_record_service)
):
    """
    Get all time records for a specific competition.
    
    - **competence_id**: ID of the competition
    - **registration_number**: Optional filter by registration number
    """
    return await service.get_time_records_by_competence(competence_id, registration_number)
