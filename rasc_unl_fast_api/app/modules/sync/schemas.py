from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class CompetenceSyncData(BaseModel):
    id: str
    name: str
    competition_date: Optional[datetime] = None
    is_active: bool = True
    is_finished: bool = False
    created_by: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    sync_status: str = "pending"
    last_sync_at: Optional[datetime] = None
    version: int = 1
    device_id: Optional[str] = None
    is_deleted: bool = False

    class Config:
        from_attributes = True

class RegistrationSyncData(BaseModel):
    id: str
    dorsal_number: str
    name: str
    n_participants: int
    user_dni: str
    competence_id: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    sync_status: str = "pending"
    last_sync_at: Optional[datetime] = None
    version: int = 1
    device_id: Optional[str] = None
    is_deleted: bool = False

    class Config:
        from_attributes = True

class TimeRecordSyncData(BaseModel):
    id: str
    time: int
    competition_registration_id: str
    created_at: datetime
    updated_at: datetime
    sync_status: str = "pending"
    last_sync_at: Optional[datetime] = None
    version: int = 1
    device_id: Optional[str] = None
    is_deleted: bool = False

    class Config:
        from_attributes = True

class SyncPullResponse(BaseModel):
    competences: List[CompetenceSyncData]
    registrations: List[RegistrationSyncData]
    time_records: List[TimeRecordSyncData]
    sync_timestamp: datetime

class SyncPushRequest(BaseModel):
    competences: List[CompetenceSyncData] = []
    registrations: List[RegistrationSyncData] = []
    time_records: List[TimeRecordSyncData] = []
    device_id: Optional[str] = None

class SyncPushResponse(BaseModel):
    success: bool
    message: str
    synced_count: dict
