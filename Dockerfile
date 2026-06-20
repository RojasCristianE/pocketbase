# Build stage
FROM golang:1.26-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git

WORKDIR /app

# Copy dependency files first for layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application statically
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o main main.go

# Production stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates tzdata

WORKDIR /app/

# Copy the binary from the builder
COPY --from=builder /app/main .

# Expose the default PocketBase port
EXPOSE 8080

# PocketBase data directory (needs to be persisted in production)
VOLUME ["/app/pb_data"]

# Run the server
ENTRYPOINT ["./main", "serve", "--http=0.0.0.0:8080"]
