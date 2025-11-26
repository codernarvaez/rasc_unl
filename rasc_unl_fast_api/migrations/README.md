## Generic single-database configuration.

# Uso de alembic
### Para gestionar las migraciones de la base de datos
``` bash
alembic revision --autogenerate -m "Primera migracion"
```
### Subir cambios a la base de datos
``` bash
alembic upgrade head
```