#!/usr/bin/env bash

# dotnet-angular-experiment startup script
# This script manages starting the backend (and frontend in the future)

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
BACKEND_DIR="backend"
FRONTEND_DIR="frontend"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to start backend
start_backend() {
    print_info "Starting .NET backend..."
    
    if ! command_exists dotnet; then
        print_error ".NET SDK not found. Please install it first."
        print_info "Install via: brew install --cask dotnet-sdk"
        exit 1
    fi
    
    if [ ! -d "$BACKEND_DIR" ]; then
        print_error "Backend directory not found: $BACKEND_DIR"
        exit 1
    fi
    
    cd "$BACKEND_DIR"
    print_info "Building backend..."
    dotnet build --nologo --verbosity quiet
    
    print_success "Backend built successfully"
    print_info "Starting backend server..."
    print_warning "Press Ctrl+C to stop the server"
    echo ""
    
    dotnet run --no-build
}

# Function to start frontend (placeholder for future)
start_frontend() {
    print_info "Starting Angular frontend..."
    
    if ! command_exists npm; then
        print_error "npm not found. Please install Node.js first."
        exit 1
    fi
    
    if [ ! -d "$FRONTEND_DIR" ]; then
        print_warning "Frontend directory not found: $FRONTEND_DIR"
        print_info "Frontend setup not complete yet."
        exit 1
    fi
    
    cd "$FRONTEND_DIR"
    print_info "Installing dependencies if needed..."
    npm install
    
    print_success "Starting Angular dev server..."
    npm run start
}

# Function to start database (PostgreSQL via Docker Compose)
start_db() {
    print_info "Starting PostgreSQL database via Docker Compose..."
    if ! command_exists docker; then
        print_error "Docker not found. Please install Docker Desktop."
        exit 1
    fi
    docker-compose up -d db
    print_success "Database started (localhost:5432)"
}

# Function to start both
start_all() {
    print_info "Starting backend and frontend..."
    print_warning "This will open two terminal windows/tabs"
    
    # Start backend in background
    osascript -e 'tell application "Terminal" to do script "cd \"'"$(pwd)"'\" && ./start.sh backend"' >/dev/null 2>&1 || {
        print_warning "Could not open new terminal window for backend"
        print_info "Starting backend in current terminal..."
        start_backend
    }
    
    # Give backend time to start
    sleep 2
    
    # Start frontend in new terminal
    if [ -d "$FRONTEND_DIR" ]; then
        osascript -e 'tell application "Terminal" to do script "cd \"'"$(pwd)"'\" && ./start.sh frontend"' >/dev/null 2>&1 || {
            print_warning "Could not open new terminal window for frontend"
        }
    else
        print_warning "Frontend not set up yet. Only backend will start."
    fi
}

# Function to display help
show_help() {
    echo "Usage: ./start.sh [command]"
    echo ""
    echo "Commands:"
    echo "  backend    Start only the .NET backend server (default)"
    echo "  frontend   Start only the Angular frontend server"
    echo "  all        Start both backend and frontend in separate terminals"
    echo "  help       Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./start.sh              # Start backend only"
    echo "  ./start.sh backend      # Start backend only"
    echo "  ./start.sh frontend     # Start frontend only"
    echo "  ./start.sh all          # Start both in separate terminals"
}

# Main script logic
case "${1:-backend}" in
    db)
        start_db
        ;;
    backend)
        start_backend
        ;;
    frontend)
        start_frontend
        ;;
    all)
        start_db
        start_all
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
