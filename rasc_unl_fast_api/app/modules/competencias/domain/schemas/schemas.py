from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime, date
from typing import Optional, List


# ============================================
# SCHEMAS PARA COMPETENCE
# ============================================

class CompetenceBase(BaseModel):
    """Schema base para Competence"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: datetime = Field(..., description="Fecha y hora de inicio de la competencia")
    is_active: bool = Field(default=True, description="Estado activo/inactivo")
    is_finished: bool = Field(default=False, description="Indica si la competencia finalizó")


class CompetenceCreate(BaseModel):
    """Schema para crear una competencia - Solo admins"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: datetime = Field(..., description="Fecha y hora de inicio de la competencia")


class CompetenceUpdate(BaseModel):
    """Schema para actualizar una competencia - Solo admins"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    competition_date: Optional[datetime] = None
    is_active: Optional[bool] = None
    is_finished: Optional[bool] = None


class CompetenceResponse(BaseModel):
    """Schema de respuesta para una competencia"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    name: str
    competition_date: datetime
    is_active: bool
    is_finished: bool
    created_by: str
    created_at: datetime
    updated_at: datetime


class CompetenceWithRegistrations(CompetenceResponse):
    """Schema de competencia con sus registros"""
    competition_registration: List["CompetitionRegistrationResponse"] = Field(default_factory=list)


# ============================================
# SCHEMAS PARA COMPETITION REGISTRATION
# ============================================

class CompetitionRegistrationBase(BaseModel):
    """Schema base para CompetitionRegistration"""
    dorsal_number: str = Field(..., min_length=1, max_length=100, description="Número de dorsal del equipo")
    name: str = Field(..., min_length=1, max_length=500, description="Nombre del equipo")
    n_participants: int = Field(default=1, ge=1, description="Número de participantes del equipo")


class CompetitionRegistrationCreate(CompetitionRegistrationBase):
    """Schema para crear un registro de equipo en competencia - Moderadores"""
    competence_id: int = Field(..., gt=0, description="ID de la competencia")


class CompetitionRegistrationUpdate(BaseModel):
    """Schema para actualizar un registro"""
    dorsal_number: Optional[str] = Field(None, min_length=1, max_length=100)
    name: Optional[str] = Field(None, min_length=1, max_length=500)
    n_participants: Optional[int] = Field(None, ge=1)


class CompetitionRegistrationResponse(BaseModel):
    """Schema de respuesta para un registro"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    dorsal_number: str
    name: str
    n_participants: int
    user_dni: str
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
# SCHEMAS PARA TIME RECORD
# ============================================

class TimeRecordBase(BaseModel):
    """Schema base para TimeRecord"""
    time: int = Field(..., ge=0, description="Tiempo en milisegundos")


class TimeRecordCreate(BaseModel):
    """Schema para crear un registro de tiempo - Moderadores"""
    time: int = Field(..., ge=0, description="Tiempo en milisegundos")
    competition_registration_id: int = Field(..., gt=0, description="ID del registro de competencia")


class TimeRecordUpdate(BaseModel):
    """Schema para actualizar un registro de tiempo"""
    time: Optional[int] = Field(None, ge=0)


class TimeRecordResponse(BaseModel):
    """Schema de respuesta para un registro de tiempo"""
    model_config = ConfigDict(from_attributes=True)
    
    id: int
    time: int
    competition_registration_id: int
    created_at: datetime


class TimeRecordListResponse(BaseModel):
    """Schema para lista de registros de tiempo"""
    time_records: List[TimeRecordResponse]
    total: int
    updated_at: datetime


class TimeRecordListResponse(BaseModel):
    """Schema para lista de registros de tiempo"""
    time_records: List[TimeRecordResponse]
    total: int
