#!/bin/bash

# Function to detect OS
detect_os() {
    OS="$(uname -s)"
    case "$OS" in
        Linux*)     echo "linux";;
        Darwin*)    echo "mac";;
        CYGWIN*|MINGW32*|MSYS*|MINGW*) echo "windows";;
        *)          echo "unknown";;
    esac
}

OS_TYPE=$(detect_os)

# Ask for project name
read -p "📦 Enter your project name (default: go-app): " PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-go-app}

# Ask for Git repository URL
read -p "🔗 Enter your Git repository URL (leave empty to skip cloning): " REPO_URL

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "🚀 Go is not installed. Installing now..."
    case "$OS_TYPE" in
        linux)  curl -OL https://golang.org/dl/go1.21.0.linux-amd64.tar.gz && \
                sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz && \
                export PATH=$PATH:/usr/local/go/bin ;;
        mac)    brew install go ;;
        windows) echo "🔴 Please install Go manually from https://go.dev/dl/"; exit 1 ;;
    esac
    echo "✅ Go installed successfully!"
else
    echo "✅ Go is already installed."
fi

# Set up Go environment
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Clone project repository if provided
if [ -n "$REPO_URL" ]; then
    if [ -d "$PROJECT_NAME" ]; then
        echo "📂 Project already exists. Pulling latest changes..."
        cd "$PROJECT_NAME" && git pull
    else
        echo "📦 Cloning project..."
        git clone "$REPO_URL" "$PROJECT_NAME"
        cd "$PROJECT_NAME"
    fi
else
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    echo "📁 Created project directory: $PROJECT_NAME"
fi

# Initialize Go module
if [ ! -f "go.mod" ]; then
    echo "🚀 Initializing Go module..."
    go mod init "$PROJECT_NAME"
fi

# Load environment variables if .env exists
if [ -f ".env" ]; then
    echo "🌍 Loading environment variables..."
    export $(grep -v '^#' .env | xargs)
else
    echo "⚠️ .env file not found! Using default settings."
fi

# Install dependencies
echo "📦 Installing dependencies..."
go mod tidy

# Create a basic main.go file if not exists
if [ ! -f "main.go" ]; then
    cat <<EOF > main.go
package main

import (
    "fmt"
    "net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello, Go App!")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("🚀 Server is running on port 8080")
    http.ListenAndServe(":8080", nil)
}
EOF
    echo "✅ Created a basic main.go file"
fi

# Build the project
echo "🔨 Building project..."
go build -o app main.go

# Run the project
echo "🚀 Starting application..."
./app &

# Docker Support
read -p "🐳 Do you want to build and run the project in Docker? (y/n): " RUN_DOCKER
if [[ "$RUN_DOCKER" == "y" ]]; then
    # Create a basic Dockerfile if not exists
    if [ ! -f "Dockerfile" ]; then
        cat <<EOF > Dockerfile
# Use official Golang image
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN go build -o app

# Run the app
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]
EOF
        echo "✅ Created a basic Dockerfile"
    fi

    echo "🐳 Building Docker image..."
    docker build -t "$PROJECT_NAME" .
    
    echo "🐳 Running Docker container..."
    docker run -p 8080:8080 "$PROJECT_NAME"
fi

echo "🎉 Setup complete! Access the app at http://localhost:8080"
