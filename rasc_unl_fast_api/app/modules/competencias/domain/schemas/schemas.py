from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime, date
from typing import Optional, List, Dict


# ============================================
# SCHEMAS PARA COMPETENCE
# ============================================

class CompetenceBase(BaseModel):
    """Schema base para Competence"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: datetime = Field(..., description="Fecha y hora de inicio de la competencia")
    created_by: str = Field(..., min_length=1, max_length=50, description="DNI del creador")
    external_id: Optional[str] = Field(None, min_length=1, max_length=255, description="ID externo único")
    competition_limit_for_registration_date: Optional[datetime] = Field(None, description="Fecha límite de registro")
    n_turns: Optional[int] = Field(None, gt=0, description="Número de vueltas")
    max_registrations: Optional[int] = Field(None, gt=0, description="Límite de registros de tiempo permitidos")
    is_active: bool = Field(default=True, description="Estado activo/inactivo")
    is_finished: bool = Field(default=False, description="Indica si la competencia finalizó")
    timer_started: bool = Field(default=False, description="Indica si el cronómetro ha iniciado")
    timer_start_time: Optional[datetime] = Field(None, description="Momento exacto de inicio del cronómetro")
    start_coordinates: Optional[Dict] = Field(None, description="Coordenadas de inicio {latitude, longitude}")
    finish_coordinates: Optional[Dict] = Field(None, description="Coordenadas de meta {latitude, longitude}")
    proximity_radius_meters: int = Field(default=50, ge=1, le=1000, description="Radio de proximidad en metros")


class CompetenceCreate(CompetenceBase):
    """Schema para crear una competencia"""
    pass


class CompetenceUpdate(BaseModel):
    """Schema para actualizar una competencia"""
    external_id: Optional[str] = Field(None, min_length=1, max_length=255)
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    competition_date: Optional[datetime] = None
    competition_limit_for_registration_date: Optional[datetime] = None
    n_turns: Optional[int] = Field(None, gt=0)
    max_registrations: Optional[int] = Field(None, gt=0)
    is_active: Optional[bool] = None
    is_finished: Optional[bool] = None
    timer_started: Optional[bool] = None
    timer_start_time: Optional[datetime] = None
    created_by: Optional[str] = Field(None, min_length=1, max_length=50)
    start_coordinates: Optional[Dict] = None
    finish_coordinates: Optional[Dict] = None
    proximity_radius_meters: Optional[int] = Field(None, ge=1, le=1000)


class CompetenceResponse(CompetenceBase):
    """Schema de respuesta para una competencia"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    created_at: datetime
    updated_at: datetime


class CompetenceWithRegistrations(CompetenceResponse):
    """Schema de competencia con sus registros"""
    competition_registrations: List["CompetitionRegistrationResponse"] = Field(default_factory=list)


# ============================================
# SCHEMAS PARA COMPETITION REGISTRATION
# ============================================

class CompetitionRegistrationBase(BaseModel):
    """Schema base para CompetitionRegistration"""
    user_dni: str = Field(..., min_length=1, max_length=50, description="DNI del usuario")
    external_id: Optional[str] = Field(None, min_length=1, max_length=255, description="ID externo único")
    registration_number: Optional[str] = Field(None, min_length=1, max_length=100, description="Número de registro único")
    time: Optional[int] = Field(None, ge=0, description="Tiempo en milisegundos")
    n_turns: Optional[int] = Field(default=0, ge=0, description="Número de vueltas completadas")


class CompetitionRegistrationCreate(CompetitionRegistrationBase):
    """Schema para crear un registro"""
    competence_id: int = Field(..., gt=0, description="ID de la competencia")


class CompetitionRegistrationUpdate(BaseModel):
    """Schema para actualizar un registro"""
    external_id: Optional[str] = Field(None, min_length=1, max_length=255)
    registration_number: Optional[str] = Field(None, min_length=1, max_length=100)
    time: Optional[int] = Field(None, ge=0)
    n_turns: Optional[int] = Field(None, ge=0)
    user_dni: Optional[str] = Field(None, min_length=1, max_length=50)


class CompetitionRegistrationResponse(CompetitionRegistrationBase):
    """Schema de respuesta para un registro"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    competence_id: int
    created_at: datetime
    updated_at: datetime


class CompetitionRegistrationWithCompetence(CompetitionRegistrationResponse):
    """Schema de registro con datos de la competencia"""
    competence: CompetenceResponse


# ============================================
# SCHEMAS DE RESPUESTA GENÉRICAS
# ============================================

class CompetenceListResponse(BaseModel):
    """Schema para lista de competencias"""
    competences: List[CompetenceResponse]
    total: int


class CompetitionRegistrationListResponse(BaseModel):
    """Schema para lista de registros"""
    competition_registrations: List[CompetitionRegistrationResponse]
    total: int


# ============================================
# SCHEMAS PARA COMPETITION TIME RECORD
# ============================================

class CompetitionTimeRecordBase(BaseModel):
    """Schema base para CompetitionTimeRecord"""
    registration_number: Optional[str] = Field(None, min_length=1, max_length=100, description="Número de registro/dorsal asignado por moderador")
    position: Optional[int] = Field(None, ge=1, description="Position/rank of the arrival")
    time: int = Field(..., ge=0, description="Tiempo en milisegundos desde el inicio")
    recorded_by_dni: str = Field(..., min_length=1, max_length=50, description="DNI del moderador/admin que registró")
    is_early: bool = Field(default=False, description="Si el tiempo fue registrado antes del primer registro del moderador")
    is_reference: bool = Field(default=False, description="Si este es el tiempo de referencia (primer registro)")


class CompetitionTimeRecordCreate(CompetitionTimeRecordBase):
    """Schema para crear un registro de tiempo"""
    competence_id: int = Field(..., gt=0, description="ID de la competencia")


class CompetitionTimeRecordUpdate(BaseModel):
    """Schema para actualizar un registro de tiempo"""
    registration_number: Optional[str] = Field(None, min_length=1, max_length=100, description="Número de registro/dorsal")
    position: Optional[int] = Field(None, ge=1)
    time: Optional[int] = Field(None, ge=0)
    is_early: Optional[bool] = None


class CompetitionTimeRecordResponse(CompetitionTimeRecordBase):
    """Schema de respuesta para un registro de tiempo"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    competence_id: int
    created_at: datetime
    updated_at: datetime


class CompetitionTimeRecordListResponse(BaseModel):
    """Schema para lista de registros de tiempo"""
    time_record: List[CompetitionTimeRecordResponse]
    total: int


# ============================================
# SCHEMAS PARA STOP TIME (COMPETIDOR)
# ============================================

class StopTimeRequest(BaseModel):
    """Schema para que un competidor detenga su cronómetro"""
    latitude: float = Field(..., ge=-90, le=90, description="Latitud actual del competidor")
    longitude: float = Field(..., ge=-180, le=180, description="Longitud actual del competidor")


class StopTimeResponse(BaseModel):
    """Schema de respuesta al detener el cronómetro"""
    registration_id: int = Field(..., description="ID del registro actualizado")
    time: int = Field(..., description="Tiempo final en milisegundos")
    distance_to_finish: float = Field(..., description="Distancia a la meta en metros")
    is_valid: bool = Field(..., description="Si el registro es válido (cerca de la meta)")
    message: str = Field(..., description="Mensaje descriptivo")


# ============================================
# SCHEMAS PARA LEADERBOARD
# ============================================

class LeaderboardEntry(BaseModel):
    """Entrada individual en la tabla de posiciones"""
    position: int = Field(..., description="Posición en la competencia")
    registration_number: Optional[str] = Field(None, description="Número de dorsal")
    user_dni: str = Field(..., description="DNI del competidor")
    time: int = Field(..., description="Tiempo en milisegundos")
    n_turns: int = Field(default=0, description="Número de vueltas completadas")
    is_early: bool = Field(default=False, description="Si detuvo el tiempo antes de tiempo")


class LeaderboardResponse(BaseModel):
    """Schema para tabla de posiciones de una competencia"""
    competence_id: int
    competence_name: str
    entries: List[LeaderboardEntry]
    total_participants: int


# ============================================
# SCHEMAS PARA CONSULTAS
# ============================================

class AvailableCompetenceResponse(CompetenceResponse):
    """Schema para competencias disponibles para inscripción"""
    registered_count: int = Field(..., description="Número de participantes registrados")
    is_registration_open: bool = Field(..., description="Si la inscripción está abierta")
    can_register: bool = Field(..., description="Si el usuario puede registrarse")


class MyParticipationResponse(BaseModel):
    """Schema para las participaciones del usuario actual"""
    registration_id: int
    competence_id: int
    competence_name: str
    competition_date: datetime
    registration_number: Optional[str]
    my_time: Optional[int] = Field(None, description="Mi tiempo en milisegundos")
    my_position: Optional[int] = Field(None, description="Mi posición")
    n_turns: int = Field(default=0)
    is_finished: bool
    timer_started: bool
