"""
Configuración de timezone UTC para PostgreSQL.

IMPORTANTE: Todas las fechas y horas en el sistema se manejan en UTC.
PostgreSQL debe estar configurado con timezone = 'UTC' para garantizar
consistencia en todas las operaciones de fecha/hora.

Para verificar la configuración actual:
    SHOW timezone;

Para cambiar la configuración (requiere permisos de superusuario):
    ALTER DATABASE your_database_name SET timezone TO 'UTC';

O configurar en postgresql.conf:
    timezone = 'UTC'
"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'timezone_utc_config'
down_revision = 'f6436f01b0ec'  # Cambiar esto a la última migración
branch_labels = None
depends_on = None


def upgrade() -> None:
    """
    Asegurar que todas las columnas DateTime usen timezone.
    PostgreSQL debe estar configurado en UTC.
    """
    # Ejecutar comando SQL para verificar/configurar timezone
    op.execute("SET timezone TO 'UTC';")
    
    # Agregar comentario a la base de datos documentando el estándar UTC
    op.execute("""
        COMMENT ON DATABASE current_database() IS 
        'Todas las fechas/horas se almacenan en UTC. 
        La conversión a hora local (Ecuador UTC-5) debe hacerse en la capa de aplicación o presentación.';
    """)


def downgrade() -> None:
    """
    No hay downgrade necesario - UTC es el estándar.
    """
    pass
