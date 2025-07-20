@echo off
REM Docker Development Helper Script for CropSmart (Windows)

setlocal enabledelayedexpansion

REM Function to print colored output (Windows doesn't support colors easily, so we'll use simple text)
set "INFO=[INFO]"
set "SUCCESS=[SUCCESS]"
set "WARNING=[WARNING]"
set "ERROR=[ERROR]"

REM Function to check if Docker is running
:check_docker
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo %ERROR% Docker is not running. Please start Docker Desktop and try again.
    exit /b 1
)
goto :eof

REM Function to build the Docker image
:build_image
echo %INFO% Building CropSmart Docker image...
docker build -t cropsmart:latest .
if %errorlevel% equ 0 (
    echo %SUCCESS% Docker image built successfully!
) else (
    echo %ERROR% Failed to build Docker image!
    exit /b 1
)
goto :eof

REM Function to run development container
:run_dev
echo %INFO% Starting CropSmart development container...

REM Stop existing dev container if running
docker stop cropsmart-dev >nul 2>&1
docker rm cropsmart-dev >nul 2>&1

REM Create necessary directories
if not exist "models" mkdir models
if not exist "uploads" mkdir uploads
if not exist "data" mkdir data

REM Run development container
docker run -d ^
    --name cropsmart-dev ^
    -p 5000:5000 ^
    -v "%cd%:/app" ^
    -v "%cd%/models:/app/models" ^
    -v "%cd%/uploads:/app/uploads" ^
    -e FLASK_ENV=development ^
    -e FLASK_DEBUG=1 ^
    cropsmart:latest

if %errorlevel% equ 0 (
    echo %SUCCESS% Development container started!
    echo %INFO% Application available at: http://localhost:5000
    echo %INFO% Health check: http://localhost:5000/health
) else (
    echo %ERROR% Failed to start development container!
    exit /b 1
)
goto :eof

REM Function to run production container
:run_prod
echo %INFO% Starting CropSmart production container...

REM Stop existing prod container if running
docker stop cropsmart-prod >nul 2>&1
docker rm cropsmart-prod >nul 2>&1

REM Create necessary directories
if not exist "models" mkdir models
if not exist "uploads" mkdir uploads
if not exist "data" mkdir data

REM Run production container
docker run -d ^
    --name cropsmart-prod ^
    --restart unless-stopped ^
    -p 5000:5000 ^
    -v "%cd%/models:/app/models" ^
    -v "%cd%/uploads:/app/uploads" ^
    -e FLASK_ENV=production ^
    cropsmart:latest

if %errorlevel% equ 0 (
    echo %SUCCESS% Production container started!
    echo %INFO% Application available at: http://localhost:5000
) else (
    echo %ERROR% Failed to start production container!
    exit /b 1
)
goto :eof

REM Function to show logs
:show_logs
set container_name=%1
if "%container_name%"=="" set container_name=cropsmart-dev
echo %INFO% Showing logs for container: %container_name%
docker logs -f %container_name%
goto :eof

REM Function to stop containers
:stop_containers
echo %INFO% Stopping CropSmart containers...
docker stop cropsmart-dev cropsmart-prod >nul 2>&1
docker rm cropsmart-dev cropsmart-prod >nul 2>&1
echo %SUCCESS% Containers stopped and removed!
goto :eof

REM Function to clean up Docker resources
:cleanup
echo %INFO% Cleaning up Docker resources...

REM Remove stopped containers
docker container prune -f

REM Remove unused images
docker image prune -f

REM Remove unused volumes
docker volume prune -f

echo %SUCCESS% Docker cleanup completed!
goto :eof

REM Function to run tests in Docker
:test_docker
echo %INFO% Running tests in Docker container...

docker run --rm ^
    -v "%cd%:/app" ^
    cropsmart:latest ^
    sh -c "cd /app && python -m pytest tests/ -v"

if %errorlevel% equ 0 (
    echo %SUCCESS% Docker tests completed!
) else (
    echo %ERROR% Docker tests failed!
    exit /b 1
)
goto :eof

REM Function to show help
:show_help
echo CropSmart Docker Development Helper (Windows)
echo.
echo Usage: %~nx0 [COMMAND]
echo.
echo Commands:
echo   build       Build the Docker image
echo   dev         Run development container with hot reload
echo   prod        Run production container
echo   logs        Show container logs (default: cropsmart-dev)
echo   stop        Stop and remove all containers
echo   test        Run tests in Docker container
echo   cleanup     Clean up Docker resources
echo   help        Show this help message
echo.
echo Examples:
echo   %~nx0 build
echo   %~nx0 dev
echo   %~nx0 logs cropsmart-prod
echo   %~nx0 stop
goto :eof

REM Main script logic
call :check_docker

if "%1"=="" goto show_help
if "%1"=="help" goto show_help
if "%1"=="--help" goto show_help
if "%1"=="-h" goto show_help

if "%1"=="build" (
    call :build_image
) else if "%1"=="dev" (
    call :build_image
    call :run_dev
) else if "%1"=="prod" (
    call :build_image
    call :run_prod
) else if "%1"=="logs" (
    call :show_logs %2
) else if "%1"=="stop" (
    call :stop_containers
) else if "%1"=="test" (
    call :build_image
    call :test_docker
) else if "%1"=="cleanup" (
    call :cleanup
) else (
    echo %ERROR% Unknown command: %1
    call :show_help
    exit /b 1
)

endlocal
