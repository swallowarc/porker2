# ===== Flutter Dependencies Stage =====
# Use official Dart image and install Flutter SDK for better caching
FROM dart:stable AS flutter_deps

# Install Flutter SDK
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Download and install Flutter SDK
ENV FLUTTER_VERSION=3.24.5
RUN git clone https://github.com/flutter/flutter.git /flutter -b ${FLUTTER_VERSION} --depth 1 \
    && /flutter/bin/flutter --version

ENV PATH="/flutter/bin:${PATH}"

WORKDIR /app

# Copy only dependency files first for better caching
COPY frontend/pubspec.yaml frontend/pubspec.lock ./

# Pre-download Flutter web SDK and dependencies
RUN flutter config --no-analytics \
    && flutter precache --web \
    && flutter pub get

# ===== Flutter Build Stage =====
FROM flutter_deps AS build_frontend

WORKDIR /app

# Copy the rest of frontend code
COPY frontend/ ./

# Build with optimizations
# --tree-shake-icons: Remove unused icon glyphs
# --no-source-maps: Remove source maps for smaller size
RUN flutter build web --release --no-pub \
    --tree-shake-icons \
    --no-source-maps

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
RUN CGO_ENABLED=0 GOARCH=amd64 GOOS=linux \
    go build -ldflags="-s -w" -trimpath -o server cmd/porker2/main.go

# ===== Final Stage =====
FROM nginx:alpine AS final

WORKDIR /app

# Install ca-certificates for HTTPS connections
RUN apk add --no-cache ca-certificates tzdata

# Copy built artifacts from previous stages
COPY --from=build_frontend /app/build/web /usr/share/nginx/html
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