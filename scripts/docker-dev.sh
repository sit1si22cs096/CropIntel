#!/bin/bash
# Docker Development Helper Script for CropSmart

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to build the Docker image
build_image() {
    print_status "Building CropSmart Docker image..."
    docker build -t cropsmart:latest .
    print_success "Docker image built successfully!"
}

# Function to run development container
run_dev() {
    print_status "Starting CropSmart development container..."
    
    # Stop existing dev container if running
    docker stop cropsmart-dev 2>/dev/null || true
    docker rm cropsmart-dev 2>/dev/null || true
    
    # Create necessary directories
    mkdir -p models uploads data
    
    # Run development container
    docker run -d \
        --name cropsmart-dev \
        -p 5000:5000 \
        -v "$(pwd):/app" \
        -v "$(pwd)/models:/app/models" \
        -v "$(pwd)/uploads:/app/uploads" \
        -e FLASK_ENV=development \
        -e FLASK_DEBUG=1 \
        cropsmart:latest
    
    print_success "Development container started!"
    print_status "Application available at: http://localhost:5000"
    print_status "Health check: http://localhost:5000/health"
}

# Function to run production container
run_prod() {
    print_status "Starting CropSmart production container..."
    
    # Stop existing prod container if running
    docker stop cropsmart-prod 2>/dev/null || true
    docker rm cropsmart-prod 2>/dev/null || true
    
    # Create necessary directories
    mkdir -p models uploads data
    
    # Run production container
    docker run -d \
        --name cropsmart-prod \
        --restart unless-stopped \
        -p 5000:5000 \
        -v "$(pwd)/models:/app/models" \
        -v "$(pwd)/uploads:/app/uploads" \
        -e FLASK_ENV=production \
        cropsmart:latest
    
    print_success "Production container started!"
    print_status "Application available at: http://localhost:5000"
}

# Function to show logs
show_logs() {
    local container_name=${1:-cropsmart-dev}
    print_status "Showing logs for container: $container_name"
    docker logs -f "$container_name"
}

# Function to stop containers
stop_containers() {
    print_status "Stopping CropSmart containers..."
    docker stop cropsmart-dev cropsmart-prod 2>/dev/null || true
    docker rm cropsmart-dev cropsmart-prod 2>/dev/null || true
    print_success "Containers stopped and removed!"
}

# Function to clean up Docker resources
cleanup() {
    print_status "Cleaning up Docker resources..."
    
    # Remove stopped containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    print_success "Docker cleanup completed!"
}

# Function to run tests in Docker
test_docker() {
    print_status "Running tests in Docker container..."
    
    docker run --rm \
        -v "$(pwd):/app" \
        cropsmart:latest \
        sh -c "cd /app && python -m pytest tests/ -v"
    
    print_success "Docker tests completed!"
}

# Function to show help
show_help() {
    echo "CropSmart Docker Development Helper"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  dev         Run development container with hot reload"
    echo "  prod        Run production container"
    echo "  logs        Show container logs (default: cropsmart-dev)"
    echo "  stop        Stop and remove all containers"
    echo "  test        Run tests in Docker container"
    echo "  cleanup     Clean up Docker resources"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build"
    echo "  $0 dev"
    echo "  $0 logs cropsmart-prod"
    echo "  $0 stop"
}

# Main script logic
main() {
    check_docker
    
    case "${1:-help}" in
        build)
            build_image
            ;;
        dev)
            build_image
            run_dev
            ;;
        prod)
            build_image
            run_prod
            ;;
        logs)
            show_logs "$2"
            ;;
        stop)
            stop_containers
            ;;
        test)
            build_image
            test_docker
            ;;
        cleanup)
            cleanup
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
