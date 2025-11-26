from sqlalchemy import Column, Integer, String, DateTime, Boolean, Date, JSON, Enum
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base
import enum
import uuid

class SyncStatus(str, enum.Enum):
    SYNCED = "synced"
    PENDING = "pending"
    CONFLICT = "conflict"

class CompetenceModel(Base):
    """
    Modelo de Competence
    Representa una competencia deportiva en el sistema.
    Relación 1:N con CompetitionRegistrationModel
    """
    __tablename__ = "competence"

    id = Column(String(36), primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    name = Column(String(255), nullable=False, index=True)
    competition_date = Column(DateTime(timezone=True), nullable=False)  # Fecha y hora de inicio de competencia
    is_active = Column(Boolean, default=True, nullable=False)
    is_finished = Column(Boolean, default=False, nullable=False, server_default='false')  # Indica si la competencia finalizó
    
    created_by = Column(String(50), nullable=False)  # UserModel.dni
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Campos de sincronización
    sync_status = Column(Enum(SyncStatus), default=SyncStatus.PENDING, nullable=False)
    last_sync_at = Column(DateTime(timezone=True), nullable=True)
    version = Column(Integer, default=1, nullable=False)
    device_id = Column(String(255), nullable=True)
    is_deleted = Column(Boolean, default=False, nullable=False)

    # Relación 1:N con CompetitionRegistration
    competition_registration = relationship("CompetitionRegistrationModel", back_populates="competence", cascade="all, delete-orphan")
    
    
    def __repr__(self):
        return f"<Competence(id={self.id}, name='{self.name}')>"
