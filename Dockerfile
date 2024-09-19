FROM golang:1.21 as builder

WORKDIR /app

# Copy Go module files
COPY go.* ./

# Download dependencies
RUN go mod download

# Copy source files
COPY ./main.go ./main.go

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o ./bin/rinha ./main.go

# -------------- End builder --------------

FROM alpine:3.14.10

EXPOSE 8080

# Copy files from builder stage
COPY --from=builder /app/bin/rinha .

# Run binary
CMD ["/rinha"]