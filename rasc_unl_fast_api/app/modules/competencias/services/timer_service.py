"""
Timer Service
Servicio para gestionar el cronómetro automático de las competencias.
"""
from datetime import datetime, timezone
from typing import Optional
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import HTTPException, status

from app.modules.competencias.repositories.competence_repository import CompetenceRepository
from app.modules.competencias.domain.models.competence_model import CompetenceModel
from app.core.utils.geolocation import (
    is_near_location,
    are_coordinates_same_location,
    validate_coordinates
)


class TimerService:
    """Servicio para gestionar el cronómetro de competencias"""
    
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = CompetenceRepository(session)
    
    async def check_and_start_timer(self, competence_id: int) -> Optional[CompetenceModel]:
        """
        Verifica si el cronómetro debe iniciar automáticamente basado en competition_date.
        Si la fecha/hora actual >= competition_date, inicia el cronómetro.
        
        Args:
            competence_id: ID de la competencia
            
        Returns:
            Competencia actualizada si se inició el cronómetro, None si no
        """
        competence = await self.repository.get_by_id(competence_id)
        
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )
        
        # Si ya está iniciado, no hacer nada
        if competence.timer_started:
            return competence
        
        # Si la competencia está finalizada, no iniciar
        if competence.is_finished:
            return None
        
        # Verificar si la fecha/hora actual >= competition_date
        now = datetime.now(timezone.utc)
        
        if now >= competence.competition_date:
            # Iniciar cronómetro
            competence.timer_started = True
            competence.timer_start_time = now
            
            await self.session.commit()
            await self.session.refresh(competence)
            
            return competence
        
        return None
    
    async def get_elapsed_time_ms(self, competence_id: int) -> Optional[int]:
        """
        Obtiene el tiempo transcurrido desde el inicio del cronómetro en milisegundos.
        
        Args:
            competence_id: ID de la competencia
            
        Returns:
            Tiempo en milisegundos desde el inicio, None si no ha iniciado
        """
        competence = await self.repository.get_by_id(competence_id)
        
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )
        
        if not competence.timer_started or not competence.timer_start_time:
            return None
        
        now = datetime.now(timezone.utc)
        elapsed = now - competence.timer_start_time
        elapsed_ms = int(elapsed.total_seconds() * 1000)
        
        return elapsed_ms
    
    def validate_minimum_time(
        self,
        elapsed_time_ms: int,
        start_coords: dict,
        finish_coords: dict,
        minimum_time_ms: int = 120000  # 2 minutos por defecto
    ) -> bool:
        """
        Valida si ha pasado el tiempo mínimo requerido antes de poder detener el cronómetro.
        Si la salida y la meta están en el mismo lugar, NO aplica el tiempo mínimo.
        
        Args:
            elapsed_time_ms: Tiempo transcurrido en milisegundos
            start_coords: Coordenadas de salida
            finish_coords: Coordenadas de meta
            minimum_time_ms: Tiempo mínimo en milisegundos (default: 2 minutos)
            
        Returns:
            True si se puede detener el cronómetro, False si no
        """
        # Si salida y meta están en el mismo lugar, permitir detener inmediatamente
        if start_coords and finish_coords:
            if validate_coordinates(start_coords) and validate_coordinates(finish_coords):
                if are_coordinates_same_location(start_coords, finish_coords):
                    return True  # Permitir detener sin esperar
        
        # Si no están en el mismo lugar, validar tiempo mínimo
        return elapsed_time_ms >= minimum_time_ms
    
    def validate_proximity_to_finish(
        self,
        current_latitude: float,
        current_longitude: float,
        finish_coords: dict,
        radius_meters: int = 50
    ) -> tuple[bool, float]:
        """
        Valida si el competidor está lo suficientemente cerca de la meta.
        
        Args:
            current_latitude: Latitud actual del competidor
            current_longitude: Longitud actual del competidor
            finish_coords: Coordenadas de la meta
            radius_meters: Radio de proximidad en metros
            
        Returns:
            Tupla (is_near, distance) donde:
            - is_near: True si está dentro del radio
            - distance: Distancia en metros a la meta
        """
        if not finish_coords or not validate_coordinates(finish_coords):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Finish coordinates not configured for this competition"
            )
        
        finish_lat = finish_coords.get('latitude')
        finish_lon = finish_coords.get('longitude')
        
        is_near, distance = is_near_location(
            current_latitude,
            current_longitude,
            finish_lat,
            finish_lon,
            radius_meters
        )
        
        return is_near, distance
    
    async def finish_competition(self, competence_id: int) -> CompetenceModel:
        """
        Marca una competencia como finalizada.
        
        Args:
            competence_id: ID de la competencia
            
        Returns:
            Competencia actualizada
        """
        competence = await self.repository.get_by_id(competence_id)
        
        if not competence:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Competence with ID {competence_id} not found"
            )
        
        competence.is_finished = True
        
        await self.session.commit()
        await self.session.refresh(competence)
        
        return competence
