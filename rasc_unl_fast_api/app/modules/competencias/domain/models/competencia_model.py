from sqlalchemy import Column, Integer, String, DateTime, Boolean, Date, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.db.database import Base


class CompetenceModel(Base):
    """
    Modelo de Competence
    Representa una competencia deportiva en el sistema.
    Relación 1:N con CompetitionRegistrationModel
    """
    __tablename__ = "competences"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    external_id = Column(String(255), unique=True, nullable=True, index=True)
    name = Column(String(255), nullable=False, index=True)
    competition_date = Column(DateTime(timezone=True), nullable=False)  # Fecha y hora de inicio de competencia
    competition_limit_for_registration_date = Column(DateTime(timezone=True), nullable=True)
    n_turns = Column(Integer, nullable=True)
    max_registrations = Column(Integer, nullable=True)  # Límite de registros de tiempo permitidos
    is_active = Column(Boolean, default=True, nullable=False)
    is_finished = Column(Boolean, default=False, nullable=False, server_default='false')  # Indica si la competencia finalizó
    
    # Timer fields
    timer_started = Column(Boolean, default=False, nullable=False)  # Indica si el cronómetro ha iniciado
    timer_start_time = Column(DateTime(timezone=True), nullable=True)  # Momento exacto de inicio del cronómetro
    
    created_by = Column(String(50), nullable=False)  # User.dni
    start_coordinates = Column(JSON, nullable=True)  # {"latitude": 0.0, "longitude": 0.0}
    finish_coordinates = Column(JSON, nullable=True)  # {"latitude": 0.0, "longitude": 0.0}
    proximity_radius_meters = Column(Integer, default=50, nullable=False)  # Radio de proximidad en metros para validar ubicación
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relación 1:N con CompetitionRegistration
    competition_registrations = relationship("CompetitionRegistrationModel", back_populates="competence", cascade="all, delete-orphan")
    
    # Relación 1:N con CompetitionTimeRecord
    time_records = relationship("CompetitionTimeRecordModel", back_populates="competence", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Competence(id={self.id}, name='{self.name}')>"
