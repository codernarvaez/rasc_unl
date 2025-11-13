from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base


class CompetitionRegistrationModel(Base):
    """
    Modelo de CompetitionRegistration
    Representa el registro de un usuario en una competencia.
    Relación N:1 con CompetenceModel
    """
    __tablename__ = "competition_registrations"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    external_id = Column(String(255), unique=True, nullable=True, index=True)
    registration_number = Column(String(100), unique=True, nullable=True, index=True)
    time = Column(BigInteger, nullable=True)  # Tiempo en milisegundos
    n_turns = Column(Integer, default=0, nullable=True)
    user_dni = Column(String(50), nullable=False, index=True)
    competence_id = Column(Integer, ForeignKey("competences.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relación N:1 con Competence
    competence = relationship("CompetenceModel", back_populates="competition_registrations")

    def __repr__(self):
        return f"<CompetitionRegistration(id={self.id}, registration_number='{self.registration_number}')>"
