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
    competition_date = Column(Date, nullable=False)
    competition_limit_for_registration_date = Column(Date, nullable=True)
    n_turns = Column(Integer, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    created_by = Column(String(50), nullable=False)  # User.dni
    start_coordinates = Column(JSON, nullable=True)  # {"point_x": [0.0, 0.0], "point_y": [0.0, 0.0]}
    finish_coordinates = Column(JSON, nullable=True)  # {"point_x": [0.0, 0.0], "point_y": [0.0, 0.0]}
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

    # Relación 1:N con CompetitionRegistration
    competition_registrations = relationship("CompetitionRegistrationModel", back_populates="competence", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Competence(id={self.id}, name='{self.name}')>"
