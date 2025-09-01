# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Porker2 is a Scrum Poker application with a Go backend using Connect RPC and a Flutter web frontend. The application uses Redis for session management and real-time room state synchronization.

## Development Commands

### Backend Commands
```bash
# Run backend development server
make be/run-for-debug

# Generate mocks for testing
make mock/gen

# Run backend tests
cd backend && go test ./...

# Run backend tests with coverage
cd backend && go test -cover ./...
```

### Frontend Commands
```bash
# Run frontend development server (port 53676)
make fe/run-for-debug

# Generate Flutter code (Router, Freezed models)
make fe/build-runner

# Run Flutter linting
make fe/lint

# Flutter build for production
cd frontend && flutter build web --release

# Run Flutter analyzer
cd frontend && flutter analyze
```

### Protocol Buffer Commands
```bash
# Generate protobuf code for both backend and frontend
make protoc
```

### Infrastructure Commands
```bash
# Start Redis container for development
make setup/redis

# Install development tools
make setup/tools
```

### Docker Commands
```bash
# Build Docker image
make docker_build

# Push Docker image
make docker_push
```

## Architecture

### Backend Architecture (Hexagonal/Clean Architecture)

The backend follows a hexagonal architecture with clear separation of concerns:

- **`internal/core/`** - Core utilities (environment, logging, error handling)
- **`internal/domain/`** - Business entities and domain logic
  - `poker/` - Poker room domain models
  - `user/` - User domain models
  - `validator/` - Domain validation logic
- **`internal/infrastructure/`** - External service integrations
  - `config/` - Configuration management
  - `connect/` - Connect RPC server setup
  - `redis/` - Redis client and operations
- **`internal/interface/`** - External interfaces
  - `controller/` - RPC handlers
  - `gateway/` - External service gateways
  - `interceptor/` - RPC interceptors (auth, logging)
  - `repository/` - Data persistence layer
  - `session/` - Session management
  - `pb/` - Generated protobuf code
- **`internal/usecase/`** - Application business logic
  - `interactor/` - Use case implementations
  - `port/` - Interface definitions
- **`internal/test/mock/`** - Generated mocks for testing

Dependency injection is managed using Uber FX framework.

### Frontend Architecture (Clean Architecture with Riverpod)

The frontend follows clean architecture principles with state management via Riverpod:

- **`lib/core/`** - Core utilities
  - `env/` - Environment configuration
  - `error/` - Error handling
  - `logger/` - Logging utilities
- **`lib/data/`** - Data layer
  - `datasource/` - Remote data sources (gRPC clients)
  - `repository/` - Repository implementations
- **`lib/domain/`** - Domain layer
  - `entity/` - Business entities
  - `port/` - Repository interfaces
  - `usecase/` - Business use cases with Riverpod state management
- **`lib/presentation/`** - Presentation layer
  - `page/` - UI pages
  - `widget/` - Reusable widgets
  - `router/` - GoRouter navigation configuration
  - `provider/` - Riverpod providers

### Data Flow

1. **Authentication**: Token-based authentication with 60-minute session timeout
2. **Room Management**: Redis streams for real-time room state synchronization
3. **Voting State**: Two states - hidden (1) and open (2)
4. **Session Storage**: Redis with automatic TTL management

### Features

#### Observer Mode
Users can join a room as observers to watch the voting process without participating:
- **User Roles**: `USER_ROLE_VOTER` (1) for participants, `USER_ROLE_OBSERVER` (2) for observers
- Observers can see all votes and results but cannot cast votes
- Observer count is tracked separately in `RoomCondition.observer_count`
- Observers are excluded from vote calculations and averages

#### T-shirt Sizing Mode
Rooms can switch between numeric points and T-shirt sizes for estimation:
- **Display Modes**: `DISPLAY_MODE_POINT` (1) for numbers, `DISPLAY_MODE_TSHIRT` (2) for T-shirt sizes
- T-shirt size mapping:
  - XS: 0-0.5 points
  - S: 1-2 points
  - M: 3-5 points
  - L: 8 points
  - XL: 13 points
  - XXL: 21+ points
- Display mode is configurable per room and affects how points are shown to all participants
- Averages are calculated numerically but displayed according to the selected mode

### Redis Key Schema

- **User Sessions**:
  - `token:(token)` → user_id
  - `user_id:(user_id)` → user data
  - `user_name:(user_name)` → user_id (for duplicate checking)
- **Room State**:
  - `room_condition:(room_id)` → room state stream
  - `room_lock:(room_id)` → distributed lock for vote operations

## Common Development Patterns

### Adding New RPC Endpoints

1. Define the service and messages in `proto/porker/*.proto`
2. Run `make protoc` to generate code
3. Implement the handler in `backend/internal/interface/controller/`
4. Add the use case in `backend/internal/usecase/interactor/`
5. Update frontend datasource in `frontend/lib/data/datasource/`
6. Create/update frontend use case in `frontend/lib/domain/usecase/`

### Testing Patterns

Backend tests follow the standard Go testing pattern with mocked dependencies. Generate mocks using `make mock/gen` after modifying interfaces.

### State Management

Frontend uses Riverpod with Freezed for immutable state. Run `make fe/build-runner` after modifying state classes or adding new routes.

## Environment Configuration

Backend configuration is managed via environment variables (see `.envrc.example`). Frontend configuration uses `env_local.json` for development settings.