from sqlalchemy import Column, Integer, BigInteger, ForeignKey, DateTime
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
    time = Column(BigInteger, nullable=False)  # Tiempo en milisegundos
    competition_registration_id = Column(Integer, ForeignKey("competition_registration.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)

    # Relación N:1 con CompetitionRegistration
    competition_registration = relationship("CompetitionRegistrationModel", back_populates="time_record")

    def __repr__(self):
        return f"<TimeRecord(id={self.id}, time={self.time})>"