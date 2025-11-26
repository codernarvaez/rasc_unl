from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from datetime import datetime
from typing import Optional

from app.core.db.database import get_session
from app.modules.sync.schemas import (
    SyncPullResponse,
    SyncPushRequest,
    SyncPushResponse,
    CompetenceSyncData,
    RegistrationSyncData,
    TimeRecordSyncData
)
from app.modules.competencias.domain.models.competence_model import CompetenceModel, SyncStatus
from app.modules.competencias.domain.models.competition_registration_model import CompetitionRegistrationModel
from app.modules.competencias.domain.models.time_record_model import TimeRecordModel

router = APIRouter(prefix="/sync", tags=["sync"])

@router.get("/pull", response_model=SyncPullResponse)
async def pull_sync_data(
    since: Optional[datetime] = None,
    user_dni: Optional[str] = None,
    db: AsyncSession = Depends(get_session)
):
    """
    Pull all data from server for synchronization.
    Optionally filter by timestamp (since) or user (user_dni).
    """
    # Query competences
    competence_query = db.query(CompetenceModel).filter(CompetenceModel.is_deleted == False)
    if since:
        competence_query = competence_query.filter(CompetenceModel.updated_at > since)
    if user_dni:
        competence_query = competence_query.filter(CompetenceModel.created_by == user_dni)
    competences = competence_query.all()

    # Query registrations
    registration_query = db.query(CompetitionRegistrationModel).filter(CompetitionRegistrationModel.is_deleted == False)
    if since:
        registration_query = registration_query.filter(CompetitionRegistrationModel.updated_at > since)
    if user_dni:
        registration_query = registration_query.filter(CompetitionRegistrationModel.user_dni == user_dni)
    registrations = registration_query.all()

    # Query time records
    time_record_query = db.query(TimeRecordModel).filter(TimeRecordModel.is_deleted == False)
    if since:
        time_record_query = time_record_query.filter(TimeRecordModel.updated_at > since)
    time_records = time_record_query.all()

    return SyncPullResponse(
        competences=[CompetenceSyncData.from_orm(c) for c in competences],
        registrations=[RegistrationSyncData.from_orm(r) for r in registrations],
        time_records=[TimeRecordSyncData.from_orm(t) for t in time_records],
        sync_timestamp=datetime.now()
    )

@router.post("/push", response_model=SyncPushResponse)
async def push_sync_data(
    sync_data: SyncPushRequest,
    db: AsyncSession = Depends(get_session)
):
    """
    Push data from client to server.
    Creates or updates records based on ID.
    """
    synced_count = {"competences": 0, "registrations": 0, "time_records": 0}

    try:
        # Process competences
        for comp_data in sync_data.competences:
            existing = db.query(CompetenceModel).filter(CompetenceModel.id == comp_data.id).first()
            
            if existing:
                # Update existing
                for key, value in comp_data.dict(exclude={'id'}).items():
                    setattr(existing, key, value)
                existing.sync_status = SyncStatus.SYNCED
                existing.last_sync_at = datetime.now()
            else:
                # Create new
                new_comp = CompetenceModel(**comp_data.dict())
                new_comp.sync_status = SyncStatus.SYNCED
                new_comp.last_sync_at = datetime.now()
                db.add(new_comp)
            
            synced_count["competences"] += 1

        # Process registrations
        for reg_data in sync_data.registrations:
            existing = db.query(CompetitionRegistrationModel).filter(
                CompetitionRegistrationModel.id == reg_data.id
            ).first()
            
            if existing:
                for key, value in reg_data.dict(exclude={'id'}).items():
                    setattr(existing, key, value)
                existing.sync_status = SyncStatus.SYNCED
                existing.last_sync_at = datetime.now()
            else:
                new_reg = CompetitionRegistrationModel(**reg_data.dict())
                new_reg.sync_status = SyncStatus.SYNCED
                new_reg.last_sync_at = datetime.now()
                db.add(new_reg)
            
            synced_count["registrations"] += 1

        # Process time records
        for tr_data in sync_data.time_records:
            existing = db.query(TimeRecordModel).filter(TimeRecordModel.id == tr_data.id).first()
            
            if existing:
                for key, value in tr_data.dict(exclude={'id'}).items():
                    setattr(existing, key, value)
                existing.sync_status = SyncStatus.SYNCED
                existing.last_sync_at = datetime.now()
            else:
                new_tr = TimeRecordModel(**tr_data.dict())
                new_tr.sync_status = SyncStatus.SYNCED
                new_tr.last_sync_at = datetime.now()
                db.add(new_tr)
            
            synced_count["time_records"] += 1

        db.commit()

        return SyncPushResponse(
            success=True,
            message="Data synchronized successfully",
            synced_count=synced_count
        )

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Sync failed: {str(e)}")
