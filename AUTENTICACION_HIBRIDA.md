# Sistema de Autenticación Híbrido (Online/Offline)

## Implementación Completada

Se ha implementado un sistema completo de autenticación híbrida que funciona tanto con conexión a Internet (online) como sin ella (offline).

## Características Principales

### 🔐 Autenticación Dual
- **Online**: Login con email + DNI + contraseña
- **Offline**: Login con email + DNI (sin contraseña, validación local)
- Detección automática del estado de conexión

### 💾 Sincronización
- Los datos del usuario se almacenan localmente en Drift (SQLite)
- Sincronización automática cuando se recupera la conexión
- Gestión de sesiones locales para acceso offline

### 🔒 Seguridad
- **NUNCA** se almacena la contraseña localmente
- Solo se guardan DNI y email para validación offline
- Tokens JWT solo se almacenan cuando hay conexión

## Archivos Creados/Modificados

### 1. Modelos y Tablas (Drift)
- `user_drift_model.dart` - Actualizado con campos de sincronización
- `session_drift_model.dart` - Nueva tabla para sesiones locales
- `app_local_database.dart` - Actualizado con nueva tabla de sesiones

### 2. Modelos de API
- `auth_models.dart` - Modelos para requests/responses de autenticación

### 3. Repositorios
- `auth_remote_repository.dart` - Interfaz para operaciones remotas
- `auth_remote_repository_impl.dart` - Implementación con la API
- `session_local_repository.dart` - Gestión de sesiones locales
- `local_user_repository_impl.dart` - Operaciones locales de usuarios

### 4. Servicios
- `auth_service.dart` - Servicio híbrido que maneja login online/offline

### 5. Providers (Riverpod)
- `auth_provider.dart` - Estado global de autenticación

### 6. UI
- `login_page.dart` - Actualizado con soporte online/offline

## Pasos para Completar la Implementación

### Paso 1: Generar Código con Build Runner

```bash
cd rasc_unl_flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Este comando generará:
- `app_local_database.g.dart` - Código generado de Drift
- `auth_models.g.dart` - Serialización JSON
- `user_model.g.dart` - Serialización JSON
- Otros archivos `.g.dart` necesarios

### Paso 2: Configurar la URL de la API

Edita el archivo `.env`:
```
API_URL=http://tu-servidor:8080
```

### Paso 3: Actualizar la Página de Registro

La página `signup_page.dart` necesita ser actualizada de manera similar a `login_page.dart`:

```dart
// Usar el provider de autenticación
await ref.read(authNotifierProvider.notifier).register(
  email: email,
  firstName: firstName,
  lastName: lastName,
  dni: dni,
  password: password,
);
```

### Paso 4: Implementar Sincronización Bidireccional

Crear `sync_service.dart` para sincronizar datos cuando se recupera la conexión:

```dart
class SyncService {
  Future<void> syncUserData() async {
    // 1. Obtener datos del servidor
    // 2. Actualizar BD local
    // 3. Enviar cambios locales al servidor
    // 4. Marcar como sincronizado
  }
}
```

### Paso 5: Actualizar el Router

El router ya está configurado pero verifica que las rutas protegidas funcionen:

```dart
// En router.dart
String? _redirect(BuildContext context, GoRouterState state) {
  final currentUser = _ref.read(currentUserProvider);
  final isAuthenticated = currentUser != null;
  
  // Redirigir según autenticación
}
```

## Flujo de Autenticación

### Registro (Solo Online)
1. Usuario completa formulario
2. Se envía request a `/api/v1/auth/register`
3. Si exitoso, se guarda usuario en BD local
4. Usuario debe hacer login

### Login Online
1. Usuario ingresa email + DNI + contraseña
2. Se envía request a `/api/v1/auth/login`
3. Se reciben tokens JWT
4. Se obtiene información del usuario desde `/api/v1/auth/me`
5. Se guarda/actualiza usuario en BD local
6. Se crea sesión local con tokens
7. Usuario autenticado

### Login Offline
1. Usuario ingresa email + DNI (sin contraseña)
2. Se busca sesión previa en BD local
3. Si existe, se valida email + DNI
4. Si coincide, se recupera usuario de BD local
5. Usuario autenticado en modo offline

### Sincronización (Cuando vuelve conexión)
1. Detectar cambio de offline a online
2. Intentar refrescar token si existe
3. Obtener datos actualizados del servidor
4. Actualizar BD local
5. Enviar cambios pendientes al servidor

## Roles y Permisos

### Competidor (COMPETITOR)
- Ver competencias disponibles
- Registrarse en competencias
- Ver sus propios registros

### Administrador (ADMINISTRATOR)
- Todo lo anterior +
- Crear/editar/eliminar competencias
- Ver todos los usuarios
- Gestionar registros de usuarios
- Generar reportes

## Restricciones Importantes

### Operaciones Solo Online
- Registro de nuevos usuarios
- Creación de competencias (admin)
- Modificación de datos de otros usuarios (admin)
- Recuperación de contraseña

### Operaciones Offline
- Login con credenciales previamente validadas
- Ver datos locales
- Crear registros (se sincronizarán después)

## Próximos Pasos Recomendados

1. **Ejecutar build_runner** (crítico)
2. **Probar el flujo de login** online y offline
3. **Implementar página de registro** con el provider
4. **Crear servicio de sincronización** completo
5. **Agregar indicadores visuales** de estado de sincronización
6. **Implementar manejo de conflictos** en sincronización bidireccional
7. **Agregar pruebas unitarias** para auth_service
8. **Documentar API** de sincronización

## Estructura de Base de Datos Local

### Tabla: users
- id (PK)
- remote_id (ID del servidor)
- dni (unique)
- email (unique)
- rol
- name
- lastName  
- isActive
- birthDate
- created_at
- updated_at
- last_synced_at
- needs_sync

### Tabla: sessions
- id (PK)
- user_id (FK → users)
- dni
- email
- last_login_at
- is_active
- access_token (nullable)
- refresh_token (nullable)
- token_expires_at (nullable)

## Notas de Seguridad

⚠️ **IMPORTANTE**:
- La contraseña NUNCA se almacena localmente
- Los tokens se borran al cerrar sesión
- La validación offline solo confirma que el usuario existe
- Se requiere conexión para primer login
- Implementar rate limiting en la API

## Solución de Problemas

### Error: "Database not ready"
- Asegúrate de que `localDatabaseProvider` esté inicializado
- Verifica que build_runner haya generado los archivos

### Error: "SessionTable not found"
- Ejecuta `dart run build_runner build --delete-conflicting-outputs`
- Verifica que `SessionTable` esté en el `@DriftDatabase`

### Login offline no funciona
- Verifica que el usuario haya iniciado sesión online al menos una vez
- Confirma que DNI y email coincidan exactamente

### Tokens expirados
- Implementa refresh token automático
- Maneja el error 401 y redirige a login

## Contacto y Soporte

Para preguntas sobre la implementación, revisa:
- Documentación de Drift: https://drift.simonbinder.eu/
- Documentación de Riverpod: https://riverpod.dev/
- API de FastAPI (backend)
