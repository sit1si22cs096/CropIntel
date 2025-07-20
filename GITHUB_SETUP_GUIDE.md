# 🚀 Complete GitHub & Docker CI/CD Setup Guide

This guide will help you push your CropIntel application to GitHub and set up the complete Docker CI/CD pipeline.

## 📋 Prerequisites

Before starting, make sure you have:
- ✅ Git installed on your computer
- ✅ GitHub account created
- ✅ Docker Hub account created (free at https://hub.docker.com)
- ✅ Your GitHub repository ready: https://github.com/sit1si22cs096/CropIntel

## 🎯 Step-by-Step Setup

### **Step 1: Push Your Code to GitHub**

#### Option A: Using the Setup Script (Recommended)
```bash
# Run the provided setup script
setup-github.bat
```

#### Option B: Manual Commands
```bash
# Navigate to your project directory
cd "c:\Users\Manohara M M\Downloads\cropsmart-master\cropsmart-master"

# Initialize Git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: CropIntel with Docker CI/CD pipeline"

# Add GitHub remote
git remote add origin https://github.com/sit1si22cs096/CropIntel.git

# Create main branch and push
git branch -M main
git push -u origin main
```

### **Step 2: Set Up Docker Hub Secrets**

1. **Go to your GitHub repository**: https://github.com/sit1si22cs096/CropIntel

2. **Navigate to Settings**:
   - Click on "Settings" tab in your repository
   - Click on "Secrets and variables" → "Actions"

3. **Add Docker Hub Secrets**:
   
   **Secret 1: DOCKER_USERNAME**
   - Click "New repository secret"
   - Name: `DOCKER_USERNAME`
   - Value: Your Docker Hub username
   - Click "Add secret"
   
   **Secret 2: DOCKER_PASSWORD**
   - Click "New repository secret"
   - Name: `DOCKER_PASSWORD`
   - Value: Your Docker Hub password (or access token)
   - Click "Add secret"

### **Step 3: Verify CI/CD Pipeline**

1. **Check GitHub Actions**:
   - Go to your repository
   - Click on "Actions" tab
   - You should see your CI/CD pipeline running automatically

2. **Pipeline Stages**:
   - ✅ **Quality Checks**: Code formatting, linting, security scanning
   - ✅ **Testing**: Multi-version Python testing
   - ✅ **Docker Build**: Container building and testing
   - ✅ **Docker Push**: Push to Docker Hub
   - ✅ **Deployment**: Ready for staging/production

### **Step 4: Monitor Your Docker Images**

1. **Check Docker Hub**:
   - Go to https://hub.docker.com
   - Look for your `cropintel` repository
   - You should see your Docker images being pushed automatically

2. **Image Tags**:
   - `latest` - Latest main branch build
   - `main-<sha>` - Specific commit builds
   - `develop` - Development branch builds

## 🎯 What Happens Automatically

### **On Every Push to Main Branch**:
1. **Code Quality Checks** run (Black, flake8, bandit, safety)
2. **Tests** run across Python 3.9, 3.10, 3.11
3. **Docker Image** is built and tested
4. **Image is Pushed** to Docker Hub as `latest`
5. **Production Deployment** is prepared

### **On Every Push to Develop Branch**:
1. Same quality checks and tests
2. Docker image built and pushed as `develop`
3. **Staging Deployment** is prepared

### **On Pull Requests**:
1. All quality checks and tests run
2. Docker image is built and tested
3. **No deployment** (safe for code review)

## 🚀 Deployment Options

### **Option 1: Local Docker Deployment**
```bash
# Pull and run your image
docker pull yourusername/cropintel:latest
docker run -p 5000:5000 yourusername/cropintel:latest

# Access at http://localhost:5000
```

### **Option 2: Cloud Platform Deployment**

#### **AWS ECS**
```bash
# Use your Docker image in ECS task definition
"image": "yourusername/cropintel:latest"
```

#### **Google Cloud Run**
```bash
gcloud run deploy cropintel \
  --image yourusername/cropintel:latest \
  --platform managed \
  --allow-unauthenticated
```

#### **Azure Container Instances**
```bash
az container create \
  --resource-group myResourceGroup \
  --name cropintel \
  --image yourusername/cropintel:latest \
  --ports 5000
```

### **Option 3: Docker Compose**
```bash
# Use the provided docker-compose.yml
docker-compose up
```

## 🔧 Development Workflow

### **Feature Development**
```bash
# Create feature branch
git checkout -b feature/new-feature

# Make your changes
# ... code changes ...

# Commit and push
git add .
git commit -m "Add new feature"
git push origin feature/new-feature

# Create Pull Request on GitHub
# CI/CD will run automatically for testing
```

### **Release to Production**
```bash
# Merge to main branch
git checkout main
git merge feature/new-feature
git push origin main

# CI/CD automatically:
# 1. Runs all tests
# 2. Builds Docker image
# 3. Pushes to Docker Hub
# 4. Deploys to production
```

## 📊 Monitoring Your Application

### **GitHub Actions Dashboard**
- View pipeline status: https://github.com/sit1si22cs096/CropIntel/actions
- Download artifacts (coverage reports, security scans)
- Monitor build times and success rates

### **Docker Hub Dashboard**
- View image pulls and downloads
- Monitor image sizes and layers
- Check automated build status

### **Application Health**
- Health endpoint: `http://your-app-url/health`
- Returns JSON with service status
- Used by Docker health checks

## 🛠️ Troubleshooting

### **Common Issues**

#### **Pipeline Fails on First Run**
- ✅ Check Docker Hub secrets are set correctly
- ✅ Verify Docker Hub username/password
- ✅ Ensure repository is public or Docker Hub account has access

#### **Docker Build Fails**
- ✅ Check Dockerfile syntax
- ✅ Verify requirements.txt is present
- ✅ Check for missing dependencies

#### **Tests Fail**
- ✅ Run tests locally first: `pytest tests/`
- ✅ Check Python version compatibility
- ✅ Verify all imports work correctly

### **Getting Help**
- Check GitHub Actions logs for detailed error messages
- Review Docker build logs in the Actions tab
- Test locally using the provided helper scripts

## 🎉 Success Indicators

You'll know everything is working when:
- ✅ GitHub Actions shows green checkmarks
- ✅ Docker images appear in your Docker Hub repository
- ✅ Application runs successfully from Docker image
- ✅ Health endpoint returns healthy status
- ✅ CI/CD badge in README shows "passing"

## 🔄 Next Steps

1. **Monitor your first pipeline run**
2. **Test pulling and running your Docker image**
3. **Set up production deployment** (cloud platform of choice)
4. **Configure monitoring and alerts**
5. **Add more comprehensive tests** as your application grows

Your CropIntel application is now ready for professional deployment with enterprise-grade CI/CD! 🚀
