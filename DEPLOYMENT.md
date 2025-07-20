# CropSmart Deployment Guide

This guide covers various deployment options for the CropSmart application using Docker and CI/CD.

## 🚀 Deployment Options

### 1. Local Docker Deployment

#### Quick Start
```bash
# Clone the repository
git clone <your-repo-url>
cd cropsmart

# Build and run with Docker
docker build -t cropsmart .
docker run -p 5000:5000 cropsmart

# Access at http://localhost:5000
```

#### Using Docker Compose
```bash
# Development environment
docker-compose --profile dev up

# Production environment
docker-compose up

# Full production stack
docker-compose --profile production up
```

### 2. Cloud Deployment

#### Docker Hub + Cloud Platforms

**Step 1: Push to Docker Hub**
```bash
# Build and tag image
docker build -t yourusername/cropsmart:latest .

# Push to Docker Hub
docker push yourusername/cropsmart:latest
```

**Step 2: Deploy to Cloud**

##### AWS ECS
```bash
# Create ECS task definition
aws ecs register-task-definition --cli-input-json file://ecs-task-definition.json

# Create ECS service
aws ecs create-service --cluster your-cluster --service-name cropsmart --task-definition cropsmart:1 --desired-count 1
```

##### Google Cloud Run
```bash
# Deploy to Cloud Run
gcloud run deploy cropsmart \
  --image yourusername/cropsmart:latest \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

##### Azure Container Instances
```bash
# Deploy to Azure
az container create \
  --resource-group myResourceGroup \
  --name cropsmart \
  --image yourusername/cropsmart:latest \
  --dns-name-label cropsmart-app \
  --ports 5000
```

### 3. CI/CD Automated Deployment

The GitHub Actions workflow automatically:

1. **Builds** Docker images on every push
2. **Tests** the containerized application
3. **Pushes** images to Docker Hub
4. **Deploys** to staging/production environments

#### Required Secrets

Add these secrets to your GitHub repository:

```
DOCKER_USERNAME=your-dockerhub-username
DOCKER_PASSWORD=your-dockerhub-password
```

#### Branch Strategy

- `develop` → Staging deployment
- `main/master` → Production deployment
- Feature branches → Build and test only

## 🔧 Configuration

### Environment Variables

```bash
# Production
FLASK_ENV=production
PORT=5000
PYTHONPATH=/app

# Development
FLASK_ENV=development
FLASK_DEBUG=1
PORT=5000
```

### Volume Mounts

```bash
# Persistent data
./models:/app/models          # ML models
./uploads:/app/uploads        # User uploads
./data:/app/data             # Application data
```

### Health Checks

The application includes a health check endpoint:
- **URL**: `/health`
- **Method**: GET
- **Response**: JSON with service status

## 🛡️ Security Considerations

### Container Security
- ✅ Non-root user execution
- ✅ Multi-stage builds
- ✅ Minimal base images
- ✅ Security scanning in CI/CD

### Network Security
```bash
# Use custom networks
docker network create cropsmart-network

# Run with custom network
docker run --network cropsmart-network cropsmart
```

### Secrets Management
```bash
# Use Docker secrets for sensitive data
echo "your-secret" | docker secret create db-password -

# Mount secrets in container
docker service create \
  --name cropsmart \
  --secret db-password \
  yourusername/cropsmart:latest
```

## 📊 Monitoring

### Container Monitoring
```bash
# View container stats
docker stats cropsmart

# View logs
docker logs -f cropsmart

# Health check
curl http://localhost:5000/health
```

### Production Monitoring

#### Prometheus + Grafana
```yaml
# docker-compose.monitoring.yml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
  
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
```

## 🔄 Scaling

### Horizontal Scaling
```bash
# Scale with Docker Compose
docker-compose up --scale cropsmart=3

# Scale with Docker Swarm
docker service scale cropsmart=3
```

### Load Balancing
```nginx
# nginx.conf
upstream cropsmart {
    server cropsmart-1:5000;
    server cropsmart-2:5000;
    server cropsmart-3:5000;
}

server {
    listen 80;
    location / {
        proxy_pass http://cropsmart;
    }
}
```

## 🚨 Troubleshooting

### Common Issues

#### Container Won't Start
```bash
# Check logs
docker logs cropsmart

# Check container status
docker ps -a

# Inspect container
docker inspect cropsmart
```

#### Port Already in Use
```bash
# Find process using port
netstat -tulpn | grep :5000

# Kill process
kill -9 <PID>

# Or use different port
docker run -p 5001:5000 cropsmart
```

#### Volume Mount Issues
```bash
# Check volume mounts
docker inspect cropsmart | grep Mounts -A 10

# Fix permissions (Linux/Mac)
sudo chown -R $USER:$USER ./models ./uploads
```

### Performance Issues

#### Memory Usage
```bash
# Limit container memory
docker run -m 512m cropsmart

# Monitor memory usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

#### Disk Space
```bash
# Clean up Docker resources
docker system prune -a

# Remove unused volumes
docker volume prune
```

## 📝 Deployment Checklist

### Pre-deployment
- [ ] Environment variables configured
- [ ] Secrets properly managed
- [ ] Health checks working
- [ ] Tests passing
- [ ] Security scan clean

### Post-deployment
- [ ] Application accessible
- [ ] Health endpoint responding
- [ ] Logs being generated
- [ ] Monitoring configured
- [ ] Backup strategy in place

### Production Readiness
- [ ] Load balancer configured
- [ ] SSL certificates installed
- [ ] Database backups automated
- [ ] Monitoring alerts set up
- [ ] Disaster recovery plan documented

## 🔗 Useful Commands

```bash
# Development
./scripts/docker-dev.sh dev          # Start dev environment
./scripts/docker-dev.sh logs         # View logs
./scripts/docker-dev.sh test         # Run tests

# Production
docker-compose up -d                 # Start production
docker-compose logs -f cropsmart     # View logs
docker-compose restart cropsmart     # Restart service

# Maintenance
docker system prune                  # Clean up
docker-compose pull                  # Update images
docker-compose down && docker-compose up -d  # Full restart
```

For more detailed information, refer to the main README.md file.
