from sqlalchemy import Column, Integer, String, BigInteger, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base


class CompetitionTimeRecordModel(Base):
    """
    Modelo de CompetitionTimeRecord
    Representa un registro de tiempo cronometrado en una competencia.
    Utilizado por moderadores para registrar tiempos durante las carreras.
    Relación N:1 con CompetenceModel
    """
    __tablename__ = "competition_time_records"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    registration_number = Column(String(100), nullable=True, index=True)  # Número de registro/dorsal
    time = Column(BigInteger, nullable=False)  # Tiempo en milisegundos
    competence_id = Column(Integer, ForeignKey("competences.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relación N:1 con Competence
    competence = relationship("CompetenceModel", back_populates="time_records")

    def __repr__(self):
        return f"<CompetitionTimeRecord(id={self.id}, registration_number='{self.registration_number}', time={self.time})>"
