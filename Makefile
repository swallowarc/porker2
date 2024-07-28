# basic parameters
NAME     := porker2
REVISION := $(shell git rev-parse --short HEAD)

GOCMD = go
GOINSTALL = $(GOCMD) install
GOGENERATE = $(GOCMD) generate
FLUTTER_CMD = flutter
DOCKER_COMPOSE_CMD = docker-compose

MOCK_DIR=backend/internal/test/mock/
FRONTEND_DIR=frontend/
FRONTEND_DEBUG_PORT=53676

.PHONY: setup/tools git/add_subtree protoc

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
