"""change_competence_dates_to_timestamp

Revision ID: 80566de0fb28
Revises: d0b2d728a2a2
Create Date: 2025-11-13 10:15:36.972023

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '80566de0fb28'
down_revision: Union[str, Sequence[str], None] = 'd0b2d728a2a2'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass