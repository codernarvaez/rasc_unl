from pydantic import BaseModel, Field, ConfigDict
from datetime import datetime, date
from typing import Optional, List, Dict


# ============================================
# SCHEMAS PARA COMPETENCE
# ============================================

class CompetenceBase(BaseModel):
    """Schema base para Competence"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: date = Field(..., description="Fecha de la competencia")
    created_by: str = Field(..., min_length=1, max_length=50, description="DNI del creador")
    external_id: Optional[str] = Field(None, min_length=1, max_length=255, description="ID externo único")
    competition_limit_for_registration_date: Optional[date] = Field(None, description="Fecha límite de registro")
    n_turns: Optional[int] = Field(None, gt=0, description="Número de vueltas")
    is_active: bool = Field(default=True, description="Estado activo/inactivo")
    start_coordinates: Optional[Dict] = Field(None, description="Coordenadas de inicio")
    finish_coordinates: Optional[Dict] = Field(None, description="Coordenadas de fin")


class CompetenceCreate(CompetenceBase):
    """Schema para crear una competencia"""
    pass


class CompetenceUpdate(BaseModel):
    """Schema para actualizar una competencia"""
    external_id: Optional[str] = Field(None, min_length=1, max_length=255)
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    competition_date: Optional[date] = None
    competition_limit_for_registration_date: Optional[date] = None
    n_turns: Optional[int] = Field(None, gt=0)
    is_active: Optional[bool] = None
    created_by: Optional[str] = Field(None, min_length=1, max_length=50)
    start_coordinates: Optional[Dict] = None
    finish_coordinates: Optional[Dict] = None


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
