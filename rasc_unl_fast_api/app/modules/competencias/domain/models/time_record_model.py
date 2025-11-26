from sqlalchemy import Column, Integer, BigInteger, ForeignKey, DateTime, Enum, Boolean, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base
from app.modules.competencias.domain.models.competence_model import SyncStatus
import uuid

class TimeRecordModel(Base):
    """
    Modelo de TimeRecord
    Representa un registro de tiempo cronometrado en una competencia.
    Utilizado por moderadores para registrar tiempos durante las carreras.
    Relación N:1 con CompetitionRegistrationModel
    """
    __tablename__ = "time_record"

    id = Column(String(36), primary_key=True, index=True, default=lambda: str(uuid.uuid4()))
    time = Column(BigInteger, nullable=False)  # Tiempo en milisegundos
    competition_registration_id = Column(String(36), ForeignKey("competition_registration.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Campos de sincronización
    sync_status = Column(Enum(SyncStatus), default=SyncStatus.PENDING, nullable=False)
    last_sync_at = Column(DateTime(timezone=True), nullable=True)
    version = Column(Integer, default=1, nullable=False)
    device_id = Column(String(255), nullable=True)
    is_deleted = Column(Boolean, default=False, nullable=False)

    # Relación N:1 con CompetitionRegistration
    competition_registration = relationship("CompetitionRegistrationModel", back_populates="time_record")

    def __repr__(self):
        return f"<TimeRecord(id={self.id}, time={self.time})>"