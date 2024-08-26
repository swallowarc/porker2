# basic parameters
NAME     := porker2
REVISION := $(shell git rev-parse --short HEAD)

GOCMD = go
GOINSTALL = $(GOCMD) install
GOGENERATE = $(GOCMD) generate
FLUTTER_CMD = flutter
DOCKER_COMPOSE_CMD = docker compose

MOCK_DIR=backend/internal/test/mock/
FRONTEND_DIR=frontend/
FRONTEND_DEBUG_PORT=53676

# for docker build
APP_NAME := swallowarc/porker2
DOCKER_IMAGE := $(APP_NAME):latest
DOCKERFILE := Dockerfile

.PHONY: all setup/tools git/add_subtree protoc

all: docker_build

# Build the frontend (Flutter web)
build_frontend:
	cd frontend && flutter build web --release

# Build the backend (Go server)
build_backend:
	cd backend && go build -o ../server cmd/porker2/main.go

# Build the Docker image
docker_build:
	docker build --platform linux/amd64 -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

# Clean up the build artifacts
clean:
	flutter clean
	rm -rf build/
	rm -f server

# Push the Docker image to a registry (Optional)
docker_push:
	docker push $(DOCKER_IMAGE)

setup/tools:
	$(GOINSTALL) go.uber.org/mock/mockgen@v0.4.0
	$(GOINSTALL) github.com/bufbuild/buf/cmd/buf@v1.32.2
	$(GOINSTALL) google.golang.org/protobuf/cmd/protoc-gen-go@v1.33.0
	$(GOINSTALL) google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
	$(GOINSTALL) connectrpc.com/connect/cmd/protoc-gen-connect-go@v1.16.2
	$(FLUTTER_CMD) pub global activate protoc_plugin

setup/redis:
ifeq ($(shell uname),Linux)
	$(DOCKER_COMPOSE_CMD) -f ./docker/docker-compose.yaml -f ./docker/docker-compose.override.yaml up -d
else
	$(DOCKER_COMPOSE_CMD) -f ./docker/docker-compose.yaml up -d
endif

protoc:
	buf generate

mock/clean:
	rm -Rf ./$(MOCK_DIR)
mock/gen: mock/clean
	$(GOGENERATE) ./backend/internal/interface/gateway/...
	$(GOGENERATE) ./backend/internal/usecase/interactor/...
	$(GOGENERATE) ./backend/internal/usecase/port/...

fe/lint:
	cd $(FRONTEND_DIR) && dart run custom_lint

fe/build-runner:
	cd $(FRONTEND_DIR) && flutter pub run build_runner build --delete-conflicting-outputs

fe/run-for-debug:
	cd $(FRONTEND_DIR) && flutter run -d chrome --web-port=$(FRONTEND_DEBUG_PORT)
