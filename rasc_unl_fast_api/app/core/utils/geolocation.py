"""
Geolocation Utilities
Funciones para validar proximidad geográfica usando coordenadas GPS.
"""
import math
from typing import Dict, Tuple


def haversine_distance(
    lat1: float,
    lon1: float,
    lat2: float,
    lon2: float
) -> float:
    """
    Calcula la distancia entre dos puntos geográficos usando la fórmula de Haversine.
    
    Args:
        lat1: Latitud del primer punto
        lon1: Longitud del primer punto
        lat2: Latitud del segundo punto
        lon2: Longitud del segundo punto
        
    Returns:
        Distancia en metros entre los dos puntos
        
    Formula de Haversine:
    a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
    c = 2 ⋅ atan2( √a, √(1−a) )
    d = R ⋅ c
    
    donde φ es latitud, λ es longitud, R es el radio de la Tierra (6371 km)
    """
    # Radio de la Tierra en metros
    R = 6371000
    
    # Convertir grados a radianes
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)
    
    # Fórmula de Haversine
    a = (
        math.sin(delta_phi / 2.0) ** 2 +
        math.cos(phi1) * math.cos(phi2) *
        math.sin(delta_lambda / 2.0) ** 2
    )
    
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    
    # Distancia en metros
    distance = R * c
    
    return distance


def is_near_location(
    current_latitude: float,
    current_longitude: float,
    target_latitude: float,
    target_longitude: float,
    radius_meters: float = 50.0
) -> Tuple[bool, float]:
    """
    Verifica si una ubicación actual está cerca de una ubicación objetivo.
    
    Args:
        current_latitude: Latitud actual del usuario
        current_longitude: Longitud actual del usuario
        target_latitude: Latitud objetivo (meta)
        target_longitude: Longitud objetivo (meta)
        radius_meters: Radio de proximidad en metros (default: 50)
        
    Returns:
        Tupla (is_near, distance) donde:
        - is_near: True si está dentro del radio, False si no
        - distance: Distancia en metros entre las dos ubicaciones
    """
    distance = haversine_distance(
        current_latitude,
        current_longitude,
        target_latitude,
        target_longitude
    )
    
    is_near = distance <= radius_meters
    
    return is_near, distance


def are_coordinates_same_location(
    coords1: Dict[str, float],
    coords2: Dict[str, float],
    tolerance_meters: float = 10.0
) -> bool:
    """
    Verifica si dos coordenadas representan la misma ubicación.
    Útil para determinar si la salida y la meta están en el mismo lugar.
    
    Args:
        coords1: Diccionario con 'latitude' y 'longitude'
        coords2: Diccionario con 'latitude' y 'longitude'
        tolerance_meters: Tolerancia en metros (default: 10)
        
    Returns:
        True si las coordenadas están dentro de la tolerancia
    """
    distance = haversine_distance(
        coords1.get('latitude', 0.0),
        coords1.get('longitude', 0.0),
        coords2.get('latitude', 0.0),
        coords2.get('longitude', 0.0)
    )
    
    return distance <= tolerance_meters


def validate_coordinates(coords: Dict) -> bool:
    """
    Valida que un diccionario de coordenadas tenga los campos requeridos.
    
    Args:
        coords: Diccionario que debe contener 'latitude' y 'longitude'
        
    Returns:
        True si las coordenadas son válidas
    """
    if not coords or not isinstance(coords, dict):
        return False
    
    if 'latitude' not in coords or 'longitude' not in coords:
        return False
    
    try:
        lat = float(coords['latitude'])
        lon = float(coords['longitude'])
        
        # Validar rangos válidos
        if not (-90 <= lat <= 90):
            return False
        if not (-180 <= lon <= 180):
            return False
        
        return True
    except (ValueError, TypeError):
        return False
