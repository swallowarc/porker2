# ===== Flutter Dependencies Stage =====
# Use official Flutter image for better performance and smaller size
FROM ghcr.io/cirruslabs/flutter:3.32.1 AS flutter_deps

# Create a non-root user for Flutter operations
RUN useradd -m -u 1001 flutteruser && \
    chown -R flutteruser:flutteruser /sdks/flutter

# Switch to non-root user
USER flutteruser
WORKDIR /home/flutteruser/app

# Configure Flutter
RUN flutter config --no-analytics && \
    flutter doctor -v

# Copy only dependency files first for better caching
COPY --chown=flutteruser:flutteruser frontend/pubspec.yaml frontend/pubspec.lock ./

# Get dependencies separately for better caching
RUN flutter pub get --no-example

# Pre-cache web SDK separately
RUN flutter precache --web --no-ios --no-android

# ===== Flutter Build Stage =====
FROM flutter_deps AS build_frontend

WORKDIR /home/flutteruser/app

# Copy the rest of frontend code
COPY --chown=flutteruser:flutteruser frontend/ ./

# Build with optimizations
# --tree-shake-icons: Remove unused icon glyphs
# --no-source-maps: Remove source maps for smaller size
# --dart2js-optimization: Maximum optimization level
RUN flutter build web --release --no-pub \
    --tree-shake-icons \
    --no-source-maps \
    --base-href=/ \
    --dart2js-optimization=O4

# ===== Go Dependencies Stage =====
# Cache Go modules separately
FROM golang:1.24-alpine AS go_deps

WORKDIR /app

# Install git for fetching dependencies
RUN apk add --no-cache git

# Copy only go.mod and go.sum for dependency caching
COPY backend/go.mod backend/go.sum ./
RUN go mod download && go mod verify

# ===== Go Build Stage =====
FROM go_deps AS build_backend

WORKDIR /app

# Copy the backend source code
COPY backend/ ./

# Build with optimizations
# - CGO_ENABLED=0 for static binary
# - ldflags -s -w to strip debug info and reduce binary size
# - trimpath to remove file system paths from binary
# - Use buildvcs=false to skip VCS stamping
ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -buildvcs=false -ldflags="-s -w" -trimpath -o server cmd/porker2/main.go

# ===== Final Stage =====
FROM nginx:alpine AS final

WORKDIR /app

# Install ca-certificates for HTTPS connections
RUN apk add --no-cache ca-certificates tzdata

# Copy built artifacts from previous stages
COPY --from=build_frontend /home/flutteruser/app/build/web /usr/share/nginx/html
COPY --from=build_backend /app/server .
COPY nginx.conf /etc/nginx/nginx.conf

# Create a non-root user for better security
RUN adduser -D -u 1001 appuser && \
    chown -R appuser:appuser /app && \
    chown -R appuser:appuser /usr/share/nginx/html && \
    chown -R appuser:appuser /var/cache/nginx && \
    chown -R appuser:appuser /var/log/nginx && \
    mkdir -p /tmp && \
    chown -R appuser:appuser /tmp

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8081/health || exit 1

# Expose ports
EXPOSE 8081 8080

# Switch to non-root user
USER appuser

# Start both services
CMD ["sh", "-c", "./server & nginx -g 'daemon off;'"]