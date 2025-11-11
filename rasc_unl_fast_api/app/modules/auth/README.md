# Auth Module - API Endpoints

## 🔐 Autenticación con Tokens

**Access Token:** Válido 15 minutos → Se envía en header `Authorization: Bearer <token>`  
**Refresh Token:** Válido 7 días → Se usa para renovar el access token

---

## 📍 Endpoints

### Públicos (sin autenticación)

#### Registrar Usuario

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "first_name": "Juan",
  "last_name": "Pérez",
  "dni": "1234567890",
  "email": "juan@example.com",
  "password": "Password123",
  "role": "COMPETITOR"  // o "ADMINISTRATOR"
}
```

#### Login

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "juan@example.com",
  "password": "Password123"
}

// Respuesta:
{
  "access_token": "eyJhbGci...",
  "refresh_token": "eyJhbGci...",
  "token_type": "bearer"
}
```

#### Renovar Token

```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJhbGci..."
}
```

---

### Autenticados (requiere access token)

> **Header requerido:** `Authorization: Bearer <access_token>`

#### Ver Mi Perfil

```http
GET /api/v1/auth/me
```

#### Actualizar Mi Perfil

```http
PUT /api/v1/auth/me
Content-Type: application/json

{
  "first_name": "Juan Actualizado",
  "email": "nuevo@example.com"
}
```

#### Cambiar Contraseña

```http
PUT /api/v1/auth/me/password
Content-Type: application/json

{
  "current_password": "Password123",
  "new_password": "NewPassword456"
}
```

#### Cerrar Sesión

```http
POST /api/v1/auth/logout
Content-Type: application/json

{
  "access_token": "tu_token_actual"
}
```

---

### Admin (requiere rol ADMINISTRATOR)

> **Headers requeridos:** `Authorization: Bearer <access_token>` + Rol ADMINISTRATOR

#### Listar Usuarios

```http
GET /api/v1/auth/users?skip=0&limit=100&search=juan&role=COMPETITOR
```

#### Ver Usuario

```http
GET /api/v1/auth/users/{user_id}
```

#### Actualizar Usuario

```http
PUT /api/v1/auth/users/{user_id}
Content-Type: application/json

{
  "first_name": "Nuevo Nombre",
  "role": "ADMINISTRATOR"
}
```

#### Eliminar Usuario

```http
DELETE /api/v1/auth/users/{user_id}
```

#### Activar/Desactivar Usuario

```http
POST /api/v1/auth/users/{user_id}/activate
POST /api/v1/auth/users/{user_id}/deactivate
```

---

## ⚠️ Errores Comunes

| Código | Error                     |
| ------ | ------------------------- |
| 401    | Token inválido o expirado |
| 403    | No eres administrador     |
| 409    | Email o DNI duplicado     |
| 422    | Datos inválidos           |

---

## 💡 Ejemplo Rápido

```bash
# 1. Login
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"juan@example.com","password":"Password123"}'

# 2. Usar token
curl -X GET http://localhost:8080/api/v1/auth/me \
  -H "Authorization: Bearer TU_ACCESS_TOKEN"
```
