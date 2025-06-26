# Stage 1: Build stage
FROM golang:1.24.4-alpine AS build

# Install build dependencies
#RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /usr/src/app

# Copy go mod files first for better layer caching
COPY ./src/go.mod .
RUN go mod download

# Copy source code
COPY ./src .

# Build with security flags
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -a -installsuffix cgo \
    -ldflags="-w -s" \
    -o whatIsMyIP .

# Stage 2: Runtime stage
FROM gcr.io/distroless/static-debian12:nonroot

# Add security: Create non-root user if we wouldn't use a distroless nonroot image
#RUN addgroup -g 1001 -S appgroup && \
#    adduser -u 1001 -S appuser -G appgroup

# Install security updates and runtime dependencies if we wouldn't use a distroless nonroot image
#RUN apk update && apk upgrade && \
#    apk add --no-cache ca-certificates tzdata && \
#    rm -rf /var/cache/apk/*

# Set working directory
WORKDIR /usr/src/app

# Copy binary from build stage
COPY --from=build /usr/src/app/whatIsMyIP .

# Add security: Set proper ownership and permissions if we wouldn't use a distroless nonroot image
#RUN chown appuser:appgroup whatIsMyIP && \
#    chmod 755 whatIsMyIP

# Add security: Switch to non-root user if we wouldn't use a distroless nonroot image
#USER appuser

# Add security: Health check if we wouldn't use a distroless nonroot image
#HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
#    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Add security: Expose only necessary port (if your app needs it)
# EXPOSE 8080

# Add security: Set proper labels
LABEL maintainer="your-email@example.com" \
      version="1.0.0" \
      description="WhatIsMyIP service"

# Add security: Use exec form for CMD
CMD ["./whatIsMyIP"]