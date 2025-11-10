# Authentication Module

Complete authentication and user management module for FastAPI application.

## Features

-   ✅ User registration with email validation
-   ✅ Login with JWT access and refresh tokens
-   ✅ Token refresh mechanism
-   ✅ Logout with token revocation
-   ✅ Password hashing with Argon2
-   ✅ Role-based access control (Administrator/Competitor)
-   ✅ User CRUD operations
-   ✅ User activation/deactivation
-   ✅ Search and filter users
-   ✅ Secure password update

## Structure

```
auth/
├── models/
│   ├── __init__.py
│   └── user.py              # User model with RoleEnum
├── repositories/
│   └── user_repository.py   # Data access layer
├── routers/
│   └── v1/
│       └── api_router.py    # API endpoints
├── schemas/
│   └── auth_schemas.py      # Pydantic schemas
└── services.py              # Business logic layer
```

## Models

### User

-   `id`: Integer (Primary Key)
-   `first_name`: String
-   `last_name`: String
-   `email`: String (Unique)
-   `password`: String (Hashed)
-   `role`: RoleEnum (administrator/competitor)
-   `is_active`: Boolean

### RoleEnum

-   `ADMINISTRATOR`: "administrator"
-   `COMPETITOR`: "competitor"

## API Endpoints

### Public Endpoints

#### Register User

```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "password": "securepassword123",
  "role": "competitor"
}
```

#### Login

```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "securepassword123"
}

Response:
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer"
}
```

#### Refresh Token

```http
POST /api/v1/auth/refresh
Content-Type: application/json

{
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Authenticated Endpoints

#### Get Current User

```http
GET /api/v1/auth/me
Authorization: Bearer {access_token}
```

#### Update Current User

```http
PUT /api/v1/auth/me
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "first_name": "Jane",
  "email": "newemail@example.com"
}
```

#### Update Password

```http
PUT /api/v1/auth/me/password
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "current_password": "oldpassword123",
  "new_password": "newpassword456"
}
```

#### Logout

```http
POST /api/v1/auth/logout
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Admin Only Endpoints

#### Get All Users

```http
GET /api/v1/auth/users?skip=0&limit=100&role=competitor&is_active=true&search=john
Authorization: Bearer {admin_access_token}
```

#### Get User by ID

```http
GET /api/v1/auth/users/{user_id}
Authorization: Bearer {admin_access_token}
```

#### Update User

```http
PUT /api/v1/auth/users/{user_id}
Authorization: Bearer {admin_access_token}
Content-Type: application/json

{
  "role": "administrator",
  "is_active": true
}
```

#### Delete User

```http
DELETE /api/v1/auth/users/{user_id}
Authorization: Bearer {admin_access_token}
```

#### Deactivate User

```http
PUT /api/v1/auth/users/{user_id}/deactivate
Authorization: Bearer {admin_access_token}
```

#### Activate User

```http
PUT /api/v1/auth/users/{user_id}/activate
Authorization: Bearer {admin_access_token}
```

## Repository Methods

### UserRepository

-   `create(user_data: UserCreate)` - Create new user
-   `get_by_id(user_id: int)` - Get user by ID
-   `get_by_email(email: str)` - Get user by email
-   `get_all(skip, limit, role, is_active, search)` - Get all users with filters
-   `update(user_id: int, user_data: UserUpdate)` - Update user
-   `update_password(user_id: int, new_password: str)` - Update password
-   `delete(user_id: int)` - Delete user
-   `deactivate(user_id: int)` - Deactivate user
-   `activate(user_id: int)` - Activate user
-   `exists(email: str)` - Check if email exists
-   `verify_password(user: User, password: str)` - Verify password
-   `count(role, is_active)` - Count users

## Services

### AuthService

Handles authentication operations:

-   User registration
-   Login
-   Token refresh
-   Logout

### UserService

Handles user management operations:

-   Get users
-   Update users
-   Delete users
-   Activate/deactivate users

## Dependencies

### get_current_user

Extracts and validates the current user from JWT token.

### require_admin

Ensures the current user has administrator role.

## Security Features

-   ✅ Password hashing with Argon2
-   ✅ JWT tokens with expiration
-   ✅ Refresh token rotation (one-time use)
-   ✅ Token revocation via Redis
-   ✅ Role-based access control
-   ✅ User activation status check
-   ✅ Secure password update with verification

## Usage Example

```python
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.db.database import get_session
from app.modules.auth.services import UserService, AuthService

# In your route
async def some_route(session: AsyncSession = Depends(get_session)):
    # Use auth service
    auth_service = AuthService(session)
    tokens = await auth_service.login(credentials)

    # Use user service
    user_service = UserService(session)
    users = await user_service.get_users(skip=0, limit=10)
```

## Error Responses

All endpoints return appropriate HTTP status codes:

-   `200 OK` - Successful request
-   `201 Created` - Resource created successfully
-   `400 Bad Request` - Invalid input
-   `401 Unauthorized` - Authentication failed
-   `403 Forbidden` - Insufficient permissions
-   `404 Not Found` - Resource not found

Error response format:

```json
{
    "detail": "Error message description"
}
```
