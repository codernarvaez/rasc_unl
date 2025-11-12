import enum
from sqlalchemy import Column, Integer, String, Boolean, Enum, Date
from app.core.db.database import Base


class RoleEnum(str, enum.Enum):
    ADMINISTRATOR = "administrator"
    COMPETITOR = "competitor"


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    first_name = Column(String, nullable=False)
    last_name = Column(String, nullable=False)
    dni = Column(String, unique=True, index=True, nullable=False)
    date_of_birth = Column(Date, nullable=False)
    role = Column(Enum(RoleEnum), nullable=False, default=RoleEnum.COMPETITOR)
    is_active = Column(Boolean, default=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    password = Column(String, nullable=False)
    
