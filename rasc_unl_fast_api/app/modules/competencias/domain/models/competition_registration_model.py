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
    dorsal_number = Column(String(100), unique=True, nullable=True, index=True)
    name = Column(String(500), unique=True, nullable=True, index=True)
    n_participants = Column(Integer, default=1, nullable=True)
    competence_id = Column(Integer, ForeignKey("competence.id", ondelete="CASCADE"), nullable=False, index=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)


    # Relacion N:1 con UserModel (a través del DNI)
    user_dni = relationship("UserModel", primaryjoin="CompetitionRegistrationModel.user_dni == foreign(UserModel.dni)", uselist=False)

    # Relación N:1 con Competence
    competence = relationship("CompetenceModel", back_populates="competition_registrations")
    # Relación 1:N con TimeRecord
    time_record = relationship("TimeRecordModel", back_populates="competition_registration", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<CompetitionRegistration(id={self.id}, registration_number='{self.registration_number}')>"
