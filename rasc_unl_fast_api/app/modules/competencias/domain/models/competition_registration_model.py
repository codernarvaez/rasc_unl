from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base
from app.modules.competencias.domain.models.competence_model import SyncStatus
import uuid

class CompetitionRegistrationModel(Base):
    """
    Modelo de CompetitionRegistration
    Representa el registro de un moderador/equipo en una competencia.
    Los moderadores se registran con número de dorsal, nombre del equipo y número de participantes.
    Relación N:1 con CompetenceModel
    Relación 1:N con TimeRecordModel
    """
    __tablename__ = "competition_registration"

    id = Column(String(36), primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    dorsal_number = Column(String(100), nullable=False, index=True)  # Número de dorsal del equipo
    name = Column(String(500), nullable=False, index=True)  # Nombre del equipo
    n_participants = Column(Integer, default=1, nullable=False, server_default="1")  # Número de participantes del equipo
    user_dni = Column(String(50), nullable=False, index=True)  # DNI del moderador que registró el equipo
    competence_id = Column(String(36), ForeignKey("competence.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Campos de sincronización
    sync_status = Column(Enum(SyncStatus), default=SyncStatus.PENDING, nullable=False)
    last_sync_at = Column(DateTime(timezone=True), nullable=True)
    version = Column(Integer, default=1, nullable=False)
    device_id = Column(String(255), nullable=True)
    is_deleted = Column(Boolean, default=False, nullable=False)

    # Relación N:1 con Competence
    competence = relationship("CompetenceModel", back_populates="competition_registration")
    
    # Relación 1:N con TimeRecord
    time_record = relationship("TimeRecordModel", back_populates="competition_registration", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<CompetitionRegistration(id={self.id}, dorsal_number='{self.dorsal_number}', name='{self.name}')>"
