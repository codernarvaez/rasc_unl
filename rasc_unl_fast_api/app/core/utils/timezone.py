"""
Utilidades para manejo de zona horaria UTC.
Todas las fechas en el sistema se manejan en UTC (Ecuador UTC-5).
"""
from datetime import datetime, timezone, timedelta

# Ecuador está en UTC-5 (sin horario de verano)
# Usamos offset manual para compatibilidad con Windows
ECUADOR_UTC_OFFSET = timedelta(hours=-5)
ECUADOR_TZ = timezone(ECUADOR_UTC_OFFSET, name="America/Guayaquil")


def utc_now() -> datetime:
    """
    Retorna la fecha y hora actual en UTC.
    Usar esta función en lugar de datetime.now() para consistencia.
    
    Returns:
        datetime: Fecha y hora actual en UTC con timezone aware
    """
    return datetime.now(timezone.utc)


def ecuador_now() -> datetime:
    """
    Retorna la fecha y hora actual en timezone de Ecuador (UTC-5).
    
    Returns:
        datetime: Fecha y hora actual en timezone de Ecuador
    """
    return datetime.now(ECUADOR_TZ)


def to_utc(dt: datetime) -> datetime:
    """
    Convierte un datetime a UTC.
    
    Args:
        dt: datetime a convertir (puede ser naive o aware)
        
    Returns:
        datetime: datetime en UTC timezone aware
    """
    if dt.tzinfo is None:
        # Si es naive, asumimos que está en UTC
        return dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(timezone.utc)


def to_ecuador_tz(dt: datetime) -> datetime:
    """
    Convierte un datetime UTC a timezone de Ecuador.
    Útil solo para display, no para almacenamiento.
    
    Args:
        dt: datetime en UTC
        
    Returns:
        datetime: datetime en timezone de Ecuador
    """
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(ECUADOR_TZ)
