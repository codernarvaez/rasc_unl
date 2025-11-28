from pydantic import BaseModel, Field, ConfigDict, field_serializer, field_validator
from datetime import datetime, date, timezone
from typing import Optional, List


# ============================================
# SCHEMAS PARA COMPETENCE
# ============================================

class CompetenceBase(BaseModel):
    """Schema base para Competence - Todas las fechas en UTC"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: datetime = Field(..., description="Fecha y hora de inicio de la competencia en UTC")
    is_active: bool = Field(default=True, description="Estado activo/inactivo")
    is_finished: bool = Field(default=False, description="Indica si la competencia finalizó")
    
    @field_serializer('competition_date')
    def serialize_competition_date(self, dt: datetime) -> str:
        """Serializar fecha en UTC ISO 8601"""
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()


class CompetenceCreate(BaseModel):
    """Schema para crear una competencia - Solo admins"""
    name: str = Field(..., min_length=1, max_length=255, description="Nombre de la competencia")
    competition_date: datetime = Field(..., description="Fecha y hora de inicio de la competencia en UTC")
    
    @field_validator('competition_date', mode='before')
    @classmethod
    def parse_competition_date(cls, v):
        """Parsear string ISO 8601 a datetime si es necesario"""
        if isinstance(v, str):
            return datetime.fromisoformat(v.replace('Z', '+00:00'))
        return v


class CompetenceUpdate(BaseModel):
    """Schema para actualizar una competencia - Solo admins"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    competition_date: Optional[datetime] = None
    is_active: Optional[bool] = None
    is_finished: Optional[bool] = None


class CompetenceResponse(BaseModel):
    """Schema de respuesta para una competencia - Fechas en UTC"""
    model_config = ConfigDict(from_attributes=True)
    
    id: str
    name: str
    competition_date: datetime
    is_active: bool
    is_finished: bool
    created_by: str
    created_at: datetime
    created_at: datetime
    updated_at: datetime
    version: int
    sync_status: str
    last_sync_at: Optional[datetime] = None
    device_id: Optional[str] = None
    is_deleted: bool
    
    @field_serializer('competition_date', 'created_at', 'updated_at')
    def serialize_datetime(self, dt: datetime) -> str:
        """Serializar todas las fechas en UTC ISO 8601"""
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()


class CompetenceWithRegistrations(CompetenceResponse):
    """Schema de competencia con sus registros"""
    competition_registrations: List["CompetitionRegistrationResponse"] = Field(default_factory=list)


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
    competence_id: str = Field(..., min_length=1, description="ID de la competencia")
    user_dni: Optional[str] = Field(None, description="DNI del moderador responsable (opcional, por defecto el usuario actual)")


class CompetitionRegistrationUpdate(BaseModel):
    """Schema para actualizar un registro"""
    dorsal_number: Optional[str] = Field(None, min_length=1, max_length=100)
    name: Optional[str] = Field(None, min_length=1, max_length=500)
    n_participants: Optional[int] = Field(None, ge=1)
    user_dni: Optional[str] = Field(None, description="DNI del moderador responsable")


class CompetitionRegistrationResponse(BaseModel):
    """Schema de respuesta para un registro - Fechas en UTC"""
    model_config = ConfigDict(from_attributes=True)
    
    id: str
    dorsal_number: str
    name: str
    n_participants: int
    user_dni: str
    competence_id: str
    created_at: datetime
    created_at: datetime
    updated_at: datetime
    version: int
    sync_status: str
    last_sync_at: Optional[datetime] = None
    device_id: Optional[str] = None
    is_deleted: bool
    
    @field_serializer('created_at', 'updated_at')
    def serialize_datetime(self, dt: datetime) -> str:
        """Serializar todas las fechas en UTC ISO 8601"""
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()


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
    id: str = Field(..., min_length=1, description="ID único del registro")
    time: int = Field(..., ge=0, description="Tiempo en milisegundos")
    competition_registration_id: str = Field(..., min_length=1, description="ID del registro de competencia")
    sync_status: Optional[str] = Field(default="pending", description="Estado de sincronización")
    last_sync_at: Optional[datetime] = Field(default=None, description="Última sincronización")
    version: Optional[int] = Field(default=1, description="Versión del registro")
    device_id: Optional[str] = Field(default=None, description="ID del dispositivo")
    is_deleted: Optional[bool] = Field(default=False, description="Registro eliminado")
    
    @field_validator('last_sync_at', mode='before')
    @classmethod
    def parse_last_sync_at(cls, v):
        """Parsear string ISO 8601 a datetime si es necesario"""
        if v is None:
            return None
        if isinstance(v, str):
            return datetime.fromisoformat(v.replace('Z', '+00:00'))
        return v
    is_deleted: Optional[bool] = Field(default=False, description="Registro eliminado")
    


class TimeRecordUpdate(BaseModel):
    """Schema para actualizar un registro de tiempo"""
    time: Optional[int] = Field(None, ge=0)


class TimeRecordResponse(BaseModel):
    """Schema de respuesta para un registro de tiempo - Fechas en UTC"""
    model_config = ConfigDict(from_attributes=True)
    
    id: str
    time: int
    competition_registration_id: str
    created_at: datetime
    updated_at: datetime
    sync_status: str
    last_sync_at: Optional[datetime] = None
    version: int
    device_id: Optional[str] = None
    is_deleted: bool
    
    @field_serializer('created_at', 'updated_at', 'last_sync_at')
    def serialize_datetime(self, dt: Optional[datetime]) -> Optional[str]:
        """Serializar fechas en UTC ISO 8601"""
        if dt is None:
            return None
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()


class TimeRecordListResponse(BaseModel):
    """Schema para lista de registros de tiempo"""
    time_records: List[TimeRecordResponse]
    total: int
    updated_at: Optional[datetime] = None
    
    @field_serializer('updated_at')
    def serialize_datetime(self, dt: Optional[datetime]) -> Optional[str]:
        """Serializar fechas en UTC ISO 8601"""
        if dt is None:
            return None
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = dt.astimezone(timezone.utc)
        return dt.isoformat()
