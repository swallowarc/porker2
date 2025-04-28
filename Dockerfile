# build frontend
FROM swallowarc/flutter-builder AS build_frontend

WORKDIR /app
COPY ./frontend ./
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

# バックエンド（Go gRPCサーバ）をビルドするステージ
FROM golang:1.24-alpine AS build_backend

WORKDIR /app
COPY ./backend ./
RUN GOARCH=amd64 GOOS=linux go build -o server cmd/porker2/main.go

# 最終ステージ: Nginxを使ってフロントエンドを提供し、Goサーバを同じコンテナで実行
FROM nginx:alpine AS final

WORKDIR /app

# フロントエンドの静的ファイルをコピー
COPY --from=build_frontend /app/build/web /usr/share/nginx/html

# Nginxのデフォルト設定を上書きして、APIリクエストをGoサーバにプロキシする
COPY nginx.conf /etc/nginx/nginx.conf

# Goサーバのバイナリをコピー
COPY --from=build_backend /app/server .

# GoサーバとNginxを同時に起動
CMD ["sh", "-c", "./server & nginx -g 'daemon off;'"]
