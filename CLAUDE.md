# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Porker2 is a Scrum Poker application with a Go backend using Connect RPC and a Flutter web frontend. The application uses Redis for session management and real-time room state synchronization.

## Development Commands

### Backend Commands
```bash
# Run backend development server
make be/run-for-debug

# Generate mocks for testing (mockgen must be on PATH: `go install go.uber.org/mock/mockgen@v0.6.0`
# or `make setup/tools`; asdf users may need `export PATH="$(go env GOPATH)/bin:$PATH"`)
make mock/gen

# Run backend tests (unit tests only; Redis integration tests are skipped)
cd backend && go test -race ./...

# Run Redis integration tests against a local Redis (uses DB 15)
cd backend && REDIS_TEST_ADDR=localhost:6379 go test -race ./internal/infrastructure/redis/

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

The backend follows a hexagonal architecture. Dependency direction is strictly
`interface` / `infrastructure` → `usecase` → `domain` → `core`. The `domain` package has no
third-party dependencies (standard library and `core` only), and nothing below `interface` imports
connect-go or protobuf types.

- **`internal/core/`** - Framework-independent utilities
  - `merror/` - Application error type. Errors carry a `Kind` (NotFound, InvalidArgument, Internal, ...)
    and optional `FieldViolations`. Use `merror.NewXxx` / `merror.IsXxx`. **Never import connect here.**
    `merror.Wrap*` makes the outer Kind win, so do not wrap a NotFound you want callers to detect.
  - `environment/`, `logger/` (slog in context), `random/`
- **`internal/domain/`** - Business entities and value objects
  - `poker/` - `Room` aggregate (`room.go`), `Ballot`, and value objects `RoomID`, `Point`, `DisplayMode`,
    `VoteState`, `UserRole`. `snapshot.go` holds `RoomSnapshot` / `RestoreRoom` for persistence.
  - `user/` - `ID` (UUID), `Name`, token generation
- **`internal/usecase/`** - Application business logic
  - `interactor/` - Use case implementations (`User`, `Poker`)
  - `port/` - Repository interfaces (`UserRepository`, `PokerRepository`)
- **`internal/interface/`** - Adapters around the use cases
  - `controller/` - Connect RPC handlers (v2 style: plain request/response messages, no `connect.Request`
    wrapper; the session cookie is written through `connect.CallInfoForServerContext`). `convert.go` has
    `requestFields`, which converts proto fields
    into domain types via the domain constructors and collects violations into one InvalidArgument.
  - `rpcerr/` - The only place that converts `merror` into `connect.Error` (`rpcerr.ToConnect`)
  - `interceptor/` - `ErrorInterceptor` (outermost, applies `rpcerr.ToConnect`) and `LogInterceptor`
    (logs with a level derived from the error Kind: client errors WARN, server errors ERROR, cancel INFO)
  - `repository/` - Redis-backed repositories. `model.go` holds the persistence models (JSON tags live
    here, not in the domain) and converts to/from `RoomSnapshot` and the domain constructors.
  - `session/` - Cookie session manager used by the `authn` middleware (runs outside the interceptor
    chain, so it converts errors itself)
  - `gateway/` - `MemDBClient` port for the key-value store
  - `pb/` - Generated protobuf / connect code
- **`internal/infrastructure/`** - External service integrations
  - `config/` - `config.Load()` reads env vars (provided via fx; there is no `init()`)
  - `connect/` - HTTP server (connect-go **v2**: `connect.NewServer(interceptors...)` +
    `RegisterPorker2ServiceHandler` + `connecthttp.Mount`; the first interceptor is the outermost).
    `Server.Start` listens synchronously so a bad port fails startup.
  - `redis/` - `MemDBClient` implementation. Atomic multi-key operations use Lua scripts.
- **`internal/test/mock/`** - Generated mocks (`make mock/gen`)

Dependency injection is managed using Uber FX framework.

#### Backend Design Rules

- **Value objects are constructed, never cast.** All VOs are structs with unexported fields. Build them
  with `poker.NewRoomID(raw)`, `poker.NewPoint(raw)`, `user.NewName(raw)`, `user.ParseID(raw)` etc.,
  which return InvalidArgument on precondition failure. Use `MustXxx` only in tests. Zero values mean
  "absent" (`IsZero()`), e.g. a user not in any room has a zero `RoomID`.
- **Aggregate state changes go through methods.** `Room` fields are unexported; read with getters
  (`Ballots()` returns a copy). Persistence uses `room.Snapshot()` and `poker.RestoreRoom(snapshot)`,
  which re-validates every value so corrupted storage surfaces as Internal.
- **Errors are `merror` until the edge.** Domain, usecase, repository and redis return `merror` values.
  Controllers return them unchanged; `ErrorInterceptor` converts them. Check kinds with
  `merror.IsNotFound(err)` etc. Repositories must pass NotFound through (not wrap it) because use cases
  branch on it. "Session exists but user data is gone" is converted to Unauthenticated in the interactor.
- **Validation lives in the domain.** There is no validator library. Controllers only map proto fields to
  constructors through `requestFields` and name the proto field for the BadRequest detail.
- **Observer count is derived**, not stored: `Room.ObserverCount()` counts observer ballots.

### Frontend Architecture (Clean Architecture with Riverpod)

The frontend follows clean architecture principles with state management via Riverpod:

- **`lib/core/`** - Core utilities
  - `env/` - Environment configuration
  - `error/` - Error handling
  - `logger/` - Logging utilities
- **`lib/infrastructure/`** - Infrastructure layer
  - `generated/` - Protocol Buffer generated code (protoc)
  - `adapter/` - Port implementations (Connect RPC client, local storage)
- **`lib/domain/`** - Domain layer (framework-independent)
  - `entity/` - Business entities
  - `port/` - Port interfaces (abstract service definitions)
- **`lib/application/`** - Application layer
  - Riverpod Notifiers for state management and use case orchestration
- **`lib/presentation/`** - Presentation layer
  - `page/` - UI pages
  - `widget/` - Reusable widgets
  - `router/` - GoRouter navigation configuration
  - `provider/` - Riverpod providers

### Data Flow

1. **Authentication**: Cookie (`psc`, HttpOnly) carrying a token; 180-minute session lifetime, refreshed on every authenticated request
2. **Room Management**: Redis streams for real-time room state synchronization
3. **Voting State**: Two states - hidden (1) and open (2)
4. **Session Storage**: Redis with automatic TTL management

### Features

#### Observer Mode
Users can join a room as observers to watch the voting process without participating:
- **User Roles**: `USER_ROLE_VOTER` (1) for participants, `USER_ROLE_OBSERVER` (2) for observers
- Observers can see all votes and results but cannot cast votes
- `RoomCondition.observer_count` in the proto is derived from the ballots (`Room.ObserverCount()`), not stored
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

All keys are prefixed with `porker2_`. TTL is 180 minutes for user keys (refreshed on each request)
and for rooms (refreshed on each update).

- **User Sessions** (written atomically in one Lua script, guarded by the name key):
  - `porker2_token:(token)` → user_id
  - `porker2_user_id:(user_id)` → user JSON (`id`, `name`, `token`, `room_id`)
  - `porker2_user_name:(user_name)` → user_id (uniqueness guard)
- **Room State**:
  - `porker2_room_condition:(room_id)` → Redis Stream (MaxLen 1) whose latest entry holds the room JSON;
    subscribers block on XREAD
  - `porker2_room_Lock:(room_id)` → distributed lock (value = owner token, TTL 3s, released with
    compare-and-delete)

## Common Development Patterns

### Adding New RPC Endpoints

1. Define the service and messages in `proto/porker/*.proto`
2. Run `make protoc` to generate code
3. Add the use case to the `interactor` interface and implement it in `backend/internal/usecase/interactor/`
   (return `merror` values; use `checkUserRoomJoin` for room-scoped operations)
4. Implement the handler in `backend/internal/interface/controller/porker2.go`: convert request fields with
   `requestFields` (add a method in `convert.go` if a new field type appears), call the interactor, call
   `p.session.RefreshCookie` on success
5. If a repository method is added, update `usecase/port` and run `make mock/gen`
6. Create/update the frontend use case in `frontend/lib/application/`

### Error Handling

- Return `merror.NewXxx(...)` from domain / usecase / repository. Do not construct `connect.Error`
  outside `interface/rpcerr` and `interface/session`.
- Client-visible codes: InvalidArgument (with BadRequest field details), NotFound, AlreadyExists,
  PermissionDenied, Unauthenticated, FailedPrecondition, Unavailable, Internal, Canceled.
- Logs: client-caused errors are WARN, server-caused ERROR; filter by the `kind` attribute.

### Testing Patterns

- Domain tests use real objects (`poker.NewRoom()`, `user.NewID()`, `poker.MustRoomID("12345")`).
- Usecase and repository tests use the generated gomock mocks in `internal/test/mock/`. To run a
  `RoomModifier` passed to `UpdateRoomWithLock`, use `DoAndReturn` and apply it to a real `*poker.Room`.
- Fixed-ID rooms for tests: `poker.RestoreRoom(poker.RoomSnapshot{RoomID: "12345", VoteState: 1, DisplayMode: 1, AutoOpen: true})`.
- `internal/infrastructure/redis` has integration tests that run only when `REDIS_TEST_ADDR` is set.
- Regenerate mocks with `make mock/gen` after modifying interfaces in `usecase/port` or `interface/gateway`.

### State Management

Frontend uses Riverpod with Freezed for immutable state. Run `make fe/build-runner` after modifying state classes or adding new routes.

## Environment Configuration

Backend configuration is managed via environment variables (see `.envrc.example`). Frontend configuration uses `env_local.json` for development settings.