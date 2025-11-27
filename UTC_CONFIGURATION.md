# Configuración UTC - Sistema de Cronometraje RASC UNL

## ⏰ Zona Horaria y Sincronización

Todo el sistema maneja fechas y horas en **UTC (Coordinated Universal Time)** para garantizar consistencia y precisión, independientemente de los relojes locales de los dispositivos.

### 🎯 ¿Por qué UTC?

1. **Sincronización precisa**: Los relojes locales de los celulares pueden estar desincronizados (atrasados o adelantados en segundos/minutos)
2. **Consistencia**: Todos los dispositivos (móviles y servidor) usan la misma referencia de tiempo
3. **Ecuador timezone (UTC-5)**: Se maneja en la capa de presentación, no en almacenamiento
4. **Precisión en competencias**: Los tiempos cronometrados son exactos sin depender del dispositivo

## 🔧 Backend (FastAPI)

### Configuración

1. **PostgreSQL** debe estar configurado en UTC:
   ```sql
   ALTER DATABASE rasc_unl SET timezone TO 'UTC';
   ```

2. **Modelos SQLAlchemy** usan `DateTime(timezone=True)`:
   ```python
   created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
   ```

3. **Utilidades de timezone** (`app/core/utils/timezone.py`):
   ```python
   from app.core.utils.timezone import utc_now
   
   # ✅ CORRECTO
   timestamp = utc_now()
   
   # ❌ INCORRECTO - NO USAR
   timestamp = datetime.now()
   ```

### Funciones Útiles

- `utc_now()`: Retorna DateTime actual en UTC
- `to_utc(dt)`: Convierte cualquier DateTime a UTC
- `to_ecuador_tz(dt)`: Convierte UTC a hora de Ecuador (solo para display)

### Serialización

Todos los schemas de Pydantic serializan fechas en formato **ISO 8601 UTC**:
```python
@field_serializer('created_at', 'updated_at')
def serialize_datetime(self, dt: datetime) -> str:
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    else:
        dt = dt.astimezone(timezone.utc)
    return dt.isoformat()
```

## 📱 Frontend (Flutter)

### Configuración

**Utilidades de timezone** (`lib/core/utils/timezone_utils.dart`):

```dart
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

// ✅ CORRECTO - Usar UTC
final now = utcNow();

// ❌ INCORRECTO - NO USAR
final now = DateTime.now();
```

### Funciones Principales

#### Para Obtener Tiempo Actual
```dart
// Tiempo actual en UTC
final now = utcNow();

// Timestamp en milisegundos UTC
final timestamp = getUtcTimestampMillis();
```

#### Para Cálculos de Tiempo
```dart
// Calcular diferencia entre dos fechas
final diff = getMillisecondsDifference(startTime, endTime);

// Convertir a UTC
final utcDate = toUtc(localDate);
```

#### Para Parsear desde API
```dart
// El servidor envía ISO 8601 UTC: "2024-11-26T15:30:00Z"
final date = parseUtcDateTime(isoString);
```

#### Para Enviar al API
```dart
final isoString = formatUtcDateTime(dateTime);
```

#### Solo para Display UI
```dart
// Convertir a hora de Ecuador para mostrar al usuario
// ⚠️ NUNCA usar para almacenamiento o cálculos
final ecuadorTime = toEcuadorTime(utcDateTime);

// Mostrar en hora local del dispositivo
final localTime = toLocal(utcDateTime);
```

### Ejemplos de Uso

#### ✅ CORRECTO: Cronometrar una carrera
```dart
class TimerService {
  static int? getElapsedTime(CompetenceModel competence) {
    final now = utcNow(); // UTC
    final competitionDateUtc = toUtc(competence.competitionDate!);
    
    final elapsed = now.difference(competitionDateUtc);
    return elapsed.inMilliseconds;
  }
}
```

#### ✅ CORRECTO: Crear registro de tiempo
```dart
final timeRecord = TimeRecordModel(
  id: uuid.v4(),
  time: Duration(milliseconds: elapsedTime),
  competitionRegistrationId: registrationId,
  createdAt: utcNow(), // ✅ UTC
  updatedAt: utcNow(), // ✅ UTC
);
```

#### ❌ INCORRECTO: NO hacer esto
```dart
// ❌ NO usar hora local
final now = DateTime.now(); 

// ❌ NO crear fechas sin UTC
final date = DateTime(2024, 11, 26);

// ❌ NO usar toLocal() para cálculos
final diff = localTime.difference(otherLocalTime);
```

## 🔄 Sincronización

### Backend → Frontend
- El servidor SIEMPRE envía fechas en formato **ISO 8601 UTC**: `"2024-11-26T15:30:00Z"`
- Flutter parsea automáticamente a UTC usando `parseUtcDateTime()`

### Frontend → Backend
- Flutter SIEMPRE envía fechas en formato **ISO 8601 UTC** usando `formatUtcDateTime()`
- El servidor recibe y almacena en UTC

## 📊 Base de Datos

Todas las columnas de tipo fecha/hora:
```sql
CREATE TABLE competence (
    ...
    created_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'UTC'),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE 'UTC'),
    competition_date TIMESTAMP WITH TIME ZONE
);
```

## 🧪 Testing

### Verificar configuración UTC en Backend
```python
from app.core.utils.timezone import utc_now

# Debe retornar DateTime con tzinfo=UTC
now = utc_now()
assert now.tzinfo is not None
print(now)  # 2024-11-26 15:30:00+00:00
```

### Verificar configuración UTC en Flutter
```dart
import 'package:rasc_unl_flutter_app/core/utils/timezone_utils.dart';

// Debe retornar DateTime en UTC
final now = utcNow();
assert(now.isUtc);
print(now);  // 2024-11-26 15:30:00.000Z
```

## ⚠️ Reglas Importantes

### ✅ HACER
- Siempre usar `utcNow()` en lugar de `DateTime.now()`
- Almacenar todas las fechas en UTC
- Convertir a UTC antes de hacer cálculos
- Usar `toLocal()` o `toEcuadorTime()` solo para mostrar en UI
- Parsear fechas del API con `parseUtcDateTime()`

### ❌ NO HACER
- Usar `DateTime.now()` directamente
- Almacenar fechas en hora local
- Hacer cálculos con fechas en diferentes timezones
- Usar `toLocal()` para almacenamiento o cálculos
- Confiar en el reloj local del dispositivo para cronometraje

## 🌍 Ecuador Timezone

Ecuador está en **UTC-5** (sin horario de verano):
- UTC: 15:30
- Ecuador: 10:30 (UTC-5)

La conversión a hora de Ecuador se hace **solo para display**:
```dart
// Para mostrar al usuario
final display = toEcuadorTime(utcDateTime);
Text('Hora: ${display.hour}:${display.minute}');

// Pero ALMACENAR en UTC
await save(utcDateTime);
```

## 🔍 Debugging

Si hay problemas de sincronización:

1. Verificar que PostgreSQL esté en UTC: `SHOW timezone;`
2. Verificar que los modelos usen `DateTime(timezone=True)`
3. Verificar que Flutter use `utcNow()` no `DateTime.now()`
4. Verificar que las fechas del API sean ISO 8601 con 'Z': `2024-11-26T15:30:00Z`
5. Verificar logs de sincronización en ambos lados

## 📝 Migración

Si hay datos existentes en hora local, correr migración:
```bash
# Backend
cd rasc_unl_fast_api
alembic upgrade head
```

---

**Última actualización**: 26 de Noviembre, 2025
**Autor**: Sistema de Cronometraje RASC UNL
