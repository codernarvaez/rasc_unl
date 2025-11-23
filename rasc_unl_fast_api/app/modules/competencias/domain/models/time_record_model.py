from sqlalchemy import Column, Integer, String, BigInteger, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base


class TimeRecordModel(Base):
    """
    Modelo de TimeRecord
    Representa un registro de tiempo cronometrado en una competencia.
    Utilizado por moderadores para registrar tiempos durante las carreras.
    Relación N:1 con CompetitionRegistrationModel
    """
    __tablename__ = "time_record"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    registration_number = Column(String(100), nullable=True, index=True)  # Número de registro/dorsal asignado por moderador
    time = Column(BigInteger, nullable=False)  # Tiempo en milisegundos desde el inicio de la carrera
    position = Column(Integer, nullable=True, index=True)  # Position/rank of the arrival (1st, 2nd, 3rd, etc.)
    recorded_by_dni = Column(String(50), nullable=False, index=True)  # DNI of moderator/admin who recorded
    is_early = Column(Boolean, default=False, nullable=False)  # If time was recorded before first moderator record
    is_reference = Column(Boolean, default=False, nullable=False)  # If this is the first/reference time record
    competence_id = Column(Integer, ForeignKey("competences.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relación N:1 con CompetitionRegistration
    competition_registration = relationship("CompetitionRegistrationModel", back_populates="time_record")

    def __repr__(self):
        return f"<TimeRecord(id={self.id}, registration_number='{self.registration_number}', time={self.time})>"