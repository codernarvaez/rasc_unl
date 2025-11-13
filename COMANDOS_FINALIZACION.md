# Script de Comandos para Finalizar la Implementación

## 1. Generar Código (CRÍTICO - EJECUTAR PRIMERO)

```bash
cd rasc_unl_flutter_app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

**Nota**: Esto generará todos los archivos `.g.dart` necesarios.

## 2. Verificar Compilación

```bash
flutter analyze
```

## 3. Limpiar Build (Si hay problemas)

```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

## 4. Ejecutar en Modo Debug

```bash
# Android
flutter run -d android

# iOS  
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

## 5. Probar en Modo Release

```bash
flutter run --release
```

## 6. Ver Logs de Drift

En tu código, asegúrate de tener logging activado:

```dart
// En app_local_database.dart
logging.i('Mensaje de log');
```

## 7. Resetear Base de Datos Local (Para Testing)

Desinstalar y reinstalar la app, o usar:

```dart
// En código
await database.close();
// Eliminar archivo de BD manualmente
```

## 8. Generar APK para Pruebas

```bash
flutter build apk --release
```

## 9. Comandos de Git

```bash
git add .
git commit -m "feat: implementar autenticación híbrida online/offline"
git push origin develop_esteban
```

## 10. Verificar Conectividad

En el emulador/dispositivo:
- Modo Avión ON/OFF
- WiFi ON/OFF
- Verificar banner de estado en UI

## Comandos Útiles de Drift

### Ver Schema Actual
```bash
cd rasc_unl_flutter_app
dart run drift_dev schema dump lib/database/local_database/app_local_database.dart
```

### Generar Migración
```bash
dart run drift_dev schema generate drift_schemas lib/database/local_database/app_local_database.dart
```

### Validar Schema
```bash
dart run drift_dev schema validate lib/database/local_database/app_local_database.dart
```

## Testing Manual

### Test 1: Registro Online
1. Conectar internet
2. Ir a /signup
3. Completar formulario
4. Verificar creación en API
5. Verificar guardado en BD local

### Test 2: Login Online
1. Conectar internet
2. Ir a /login
3. Ingresar email + DNI + password
4. Verificar tokens en BD local
5. Verificar navegación a /home

### Test 3: Login Offline
1. Desconectar internet
2. Ir a /login
3. Ingresar mismo email + DNI (sin password)
4. Verificar login exitoso
5. Verificar banner "Modo Offline"

### Test 4: Sincronización
1. Hacer login offline
2. Conectar internet
3. Verificar sincronización automática
4. Verificar logs de sincronización

### Test 5: Sesión Persistente
1. Hacer login
2. Cerrar app
3. Abrir app
4. Verificar sesión activa

### Test 6: Logout
1. Hacer login
2. Hacer logout
3. Verificar redirección a /login
4. Verificar sesión cerrada en BD

## Verificar Funcionalidad por Rol

### Como Competidor
- [ ] Login online/offline
- [ ] Ver competencias disponibles
- [ ] Registrarse en competencia
- [ ] Ver mis registros
- [ ] No puede acceder a rutas de admin

### Como Administrador
- [ ] Todo lo anterior
- [ ] Ver /manage-users
- [ ] Ver /manage-competences
- [ ] Ver /generate-reports
- [ ] Sincronización completa de usuarios

## Debugging

### Ver Estado de Providers
```dart
// En cualquier widget Consumer
final authState = ref.watch(authNotifierProvider);
print('Is authenticated: ${authState.isAuthenticated}');
print('User: ${authState.user?.email}');
print('Is offline: ${authState.isOffline}');
```

### Ver Sesión Activa
```dart
final session = await ref.read(sessionLocalRepositoryProvider).getActiveSession();
print('Session: $session');
```

### Ver Usuarios Locales
```dart
final users = await ref.read(userLocalRepositoryProvider).getAllUsers();
print('Local users: ${users.length}');
```

## Configuración Recomendada

### Android (android/app/build.gradle.kts)
```kotlin
android {
    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }
}
```

### iOS (ios/Podfile)
```ruby
platform :ios, '12.0'
```

### Permisos de Internet

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Troubleshooting Común

### Error: "Target of URI hasn't been generated"
**Solución**: Ejecutar build_runner

### Error: "Undefined class 'SessionTable'"
**Solución**: Verificar import en app_local_database.dart, ejecutar build_runner

### Error: "Database is loading..."
**Solución**: Asegurarse de usar `ref.watch(localDatabaseProvider).value`

### Error: HTTP Connection Failed
**Solución**: 
- Verificar API_URL en .env
- Verificar que el servidor esté corriendo
- Verificar permisos de internet

### App se congela en login
**Solución**:
- Verificar logs
- Agregar try-catch con más detalle
- Verificar que build_runner se ejecutó correctamente

## Monitoreo en Producción

### Logs Importantes
```dart
logging.i('Login attempt: $email');
logging.e('Login failed: $error');
logging.i('Sync started');
logging.i('Sync completed: $usersDownloaded users');
```

### Métricas a Monitorear
- Tiempo de login online vs offline
- Tasa de éxito de sincronización
- Número de usuarios offline
- Frecuencia de cambios de conexión

---

**Último Actualización**: 2025-11-12
**Versión**: 1.0.0
