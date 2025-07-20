# CropSmart - Crop Yield Prediction System

[![CI/CD Pipeline](https://github.com/sit1si22cs096/CropIntel/actions/workflows/python-package.yml/badge.svg)](https://github.com/sit1si22cs096/CropIntel/actions/workflows/python-package.yml)
[![Python 3.9+](https://img.shields.io/badge/python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Flask](https://img.shields.io/badge/flask-3.0+-green.svg)](https://flask.palletsprojects.com/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A machine learning-based web application for predicting crop yields based on various environmental and agricultural factors. Built with Flask and powered by advanced ML algorithms for accurate agricultural predictions.

## Features

- Crop yield prediction based on location, soil, and weather data
- Interactive web interface for data input and visualization
- Support for multiple crops and regions
- Data analysis and visualization tools
- Plant disease identification using CNN

## Technologies Used

- **Backend**: Flask, Python
- **Frontend**: HTML, CSS, JavaScript
- **Machine Learning**: Scikit-learn, TensorFlow, Keras
- **Data Processing**: Pandas, NumPy
- **Visualization**: Matplotlib

## Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/crop-yield-prediction.git
   cd crop-yield-prediction
   ```

2. Create and activate a virtual environment
   ```
   python -m venv venv
   venv\Scripts\activate  # On Windows
   source venv/bin/activate  # On Unix or MacOS
   ```

3. Install the required packages
   ```
   pip install -r requirements.txt
   ```

4. Run the application
   ```
   python app.py
   ```

5. Open your browser and navigate to `http://localhost:5000`

## Project Structure

- `app.py`: Main Flask application file
- `train_model.py`: Script for training the crop yield prediction model
- `data/`: Directory containing data processing scripts and datasets
- `models/`: Directory for storing trained models
- `static/`: Static files (CSS, JavaScript, images)
- `templates/`: HTML templates for the web interface
- `uploads/`: Directory for user-uploaded files

## Usage

1. Navigate to the home page
2. Enter the required information (location, soil type, etc.)
3. Click on "Predict Yield" to get the predicted crop yield
4. Explore other features like disease identification and yield analysis

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment. The pipeline includes:

### Automated Checks
- **Code Quality**: Black formatting, isort import sorting, flake8 linting
- **Security Scanning**: Bandit security analysis, Safety vulnerability checks
- **Testing**: Automated testing across Python 3.9, 3.10, and 3.11
- **Coverage**: Code coverage reporting with pytest-cov

### Pipeline Stages
1. **Quality Checks**: Code formatting, linting, and security scanning
2. **Testing**: Multi-version Python testing with coverage reports
3. **Build**: Application packaging and artifact creation
4. **Deploy**: Staging and production deployment preparation

### Development Workflow

#### Setting up Development Environment
```bash
# Install development dependencies
pip install black isort flake8 bandit safety pytest pytest-cov pytest-mock

# Format code
black .

# Sort imports
isort .

# Run linting
flake8 .

# Run security checks
bandit -r .
safety check

# Run tests
pytest tests/ --cov=. --cov-report=html
```

#### Branch Strategy
- `master/main`: Production-ready code
- `develop`: Development branch for staging
- Feature branches: `feature/your-feature-name`

#### Pull Request Process
1. Create a feature branch from `develop`
2. Make your changes and ensure all CI checks pass
3. Submit a pull request to `develop`
4. After review and approval, merge to `develop`
5. Deploy to staging for testing
6. Merge `develop` to `master/main` for production

### Configuration Files
- `.github/workflows/python-package.yml`: Main CI/CD pipeline
- `.flake8`: Linting configuration
- `pyproject.toml`: Black, isort, pytest, and coverage configuration
- `.bandit`: Security scanning configuration

## Docker Deployment

CropSmart is fully containerized with Docker for easy deployment and development.

### Quick Start with Docker

```bash
# Build and run the application
docker build -t cropsmart .
docker run -p 5000:5000 cropsmart

# Access the application
open http://localhost:5000
```

### Docker Compose (Recommended)

```bash
# Development environment with hot reload
docker-compose --profile dev up cropsmart-dev

# Production environment
docker-compose up cropsmart

# Full production stack with Nginx and Redis
docker-compose --profile production up
```

### Development Helper Script

Use the provided helper script for common Docker operations:

```bash
# Make script executable (Linux/Mac)
chmod +x scripts/docker-dev.sh

# Build and run development container
./scripts/docker-dev.sh dev

# Run production container
./scripts/docker-dev.sh prod

# View logs
./scripts/docker-dev.sh logs

# Stop all containers
./scripts/docker-dev.sh stop

# Run tests in Docker
./scripts/docker-dev.sh test

# Clean up Docker resources
./scripts/docker-dev.sh cleanup
```

### Docker Features

- **Multi-stage builds** for optimized production images
- **Health checks** for container monitoring
- **Non-root user** for enhanced security
- **Volume mounts** for persistent data (models, uploads)
- **Environment-specific configurations**
- **Automatic restarts** for production reliability

### Container Endpoints

- **Application**: `http://localhost:5000`
- **Health Check**: `http://localhost:5000/health`
- **Development**: `http://localhost:5001` (when using dev profile)

### Environment Variables

```bash
# Production
FLASK_ENV=production
PORT=5000

# Development
FLASK_ENV=development
FLASK_DEBUG=1
PORT=5000
```

## Testing

Run the test suite locally:
```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html

# Run specific test categories
pytest -m unit          # Unit tests only
pytest -m integration   # Integration tests only

# Run tests in Docker
./scripts/docker-dev.sh test
```

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes and ensure all CI checks pass locally
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Code Standards
- Follow PEP 8 style guidelines
- Use Black for code formatting (line length: 127)
- Write tests for new functionality
- Ensure security best practices
- Add docstrings for public functions and classes

## License

This project is licensed under the MIT License - see the LICENSE file for details.
