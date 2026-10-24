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
BACKEND_DIR=backend/

# for docker build
APP_NAME := swallowarc/porker2
DOCKER_IMAGE := $(APP_NAME):latest
DOCKERFILE := Dockerfile

.DEFAULT_GOAL := help

.PHONY: help all setup/tools git/add_subtree protoc

help: ## make コマンドの一覧を表示する
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_\/-]+:.*## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

all: docker_build ## Docker イメージをビルドする (docker_build と同じ)

build_frontend: ## フロントエンド (Flutter web) をビルドする
	cd frontend && flutter build web --release

build_backend: ## バックエンド (Go server) をビルドする
	cd backend && go build -o ../server cmd/porker2/main.go

docker_build: ## Docker イメージをビルドする
	docker build --pull --platform linux/amd64 -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

clean: ## ビルド成果物を削除する
	flutter clean
	rm -rf build/
	rm -f server

docker_push: ## Docker イメージをレジストリに push する
	docker push $(DOCKER_IMAGE)

setup/tools: ## 開発ツール (mockgen, buf, protoc プラグイン) をインストールする
	$(GOINSTALL) go.uber.org/mock/mockgen@v0.6.0
	$(GOINSTALL) github.com/bufbuild/buf/cmd/buf@v1.57.0
	$(GOINSTALL) google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11
	$(GOINSTALL) google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
	$(GOINSTALL) connectrpc.com/connect/v2/cmd/protoc-gen-connect-go@v2.0.2
	$(FLUTTER_CMD) pub global activate protoc_plugin
	$(FLUTTER_CMD) pub global activate connectrpc 2.0.0

setup/redis: ## 開発用の Redis コンテナを起動する
ifeq ($(shell uname),Linux)
	$(DOCKER_COMPOSE_CMD) -f ./docker/docker-compose.yaml -f ./docker/docker-compose.override.yaml up -d
else
	$(DOCKER_COMPOSE_CMD) -f ./docker/docker-compose.yaml up -d
endif

protoc: ## proto からバックエンド・フロントエンドのコードを生成する
	buf generate

mock/clean: ## 生成済みのモックを削除する
	rm -Rf ./$(MOCK_DIR)
mock/gen: mock/clean ## バックエンドのテスト用モックを生成する
	cd $(BACKEND_DIR) && $(GOGENERATE) ./internal/interface/gateway/...
	cd $(BACKEND_DIR) && $(GOGENERATE) ./internal/usecase/interactor/...
	cd $(BACKEND_DIR) && $(GOGENERATE) ./internal/usecase/port/...

fe/lint: ## フロントエンドの静的解析を実行する
	cd $(FRONTEND_DIR) && dart analyze

fe/build-runner: ## フロントエンドのコード生成 (Router, Freezed) を実行する
	cd $(FRONTEND_DIR) && dart run build_runner build

fe/run-for-debug: ## フロントエンドをデバッグ起動する (Chrome, port 53676)
	cd $(FRONTEND_DIR) && flutter run -d chrome --web-port=$(FRONTEND_DEBUG_PORT) --dart-define-from-file=env_local.json

be/run-for-debug: ## バックエンドをデバッグ起動する
	cd $(BACKEND_DIR) && go run cmd/porker2/main.go
