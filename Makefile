# basic parameters
NAME     := porker2
REVISION := $(shell git rev-parse --short HEAD)

GOCMD = go
GOINSTALL = $(GOCMD) install
FLUTTER_CMD = flutter

.PHONY: setup/tools git/add_subtree protoc

setup/tools:
	$(GOINSTALL) go.uber.org/mock/mockgen@v0.4.0
	$(GOINSTALL) github.com/bufbuild/buf/cmd/buf@v1.32.2
	$(GOINSTALL) google.golang.org/protobuf/cmd/protoc-gen-go@v1.33.0
	$(GOINSTALL) google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0
	$(GOINSTALL) connectrpc.com/connect/cmd/protoc-gen-connect-go@v1.16.2
	$(FLUTTER_CMD) pub global activate protoc_plugin

protoc:
	buf generate
