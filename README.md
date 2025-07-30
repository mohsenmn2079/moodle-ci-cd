# Moodle CI/CD Pipeline

This repository contains a complete CI/CD pipeline for deploying Moodle using Docker and GitHub Actions.

## Project Structure

- `Dockerfile` - Docker image configuration for Moodle
- `docker-compose.yml` - Multi-container orchestration
- `.github/workflows/deploy.yml` - GitHub Actions CI/CD pipeline
- `setup_server.sh` - Server setup script

## Setup Steps

1. **Server Preparation**
   ```bash
   chmod +x setup_server.sh
   ./setup_server.sh
   ```

2. **GitHub Secrets Configuration**
   - `DOCKER_USERNAME`: Your Docker Hub username
   - `DOCKER_PASSWORD`: Your Docker Hub Personal Access Token
   - `SERVER_HOST`: Your server IP address
   - `SERVER_USERNAME`: SSH username (usually 'root')
   - `SERVER_SSH_KEY`: Your SSH private key

3. **CI/CD Workflow**
   - Push to `main` branch triggers automatic deployment
   - Docker image is built and pushed to Docker Hub
   - Server pulls latest image and restarts containers

## Useful Commands

### Local Development
```bash
# Build and run locally
docker-compose up -d

# View logs
docker-compose logs -f moodle

# Stop containers
docker-compose down
```

### Server Management
```bash
# SSH to server
ssh root@62.60.210.162

# Check container status
docker ps

# View logs
docker-compose logs moodle

# Restart services
docker-compose restart
```

## Workflow Details

The CI/CD pipeline performs the following steps:

1. **Build**: Creates Docker image with Moodle
2. **Push**: Uploads image to Docker Hub
3. **Deploy**: Connects to server via SSH
4. **Update**: Pulls latest image and restarts containers
5. **Cleanup**: Removes old images to save space

## Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   - Verify SSH key is correctly added to server
   - Check GitHub Secrets configuration
   - Ensure server allows SSH key authentication

2. **Docker Authentication Error**
   - Verify Docker Hub credentials in GitHub Secrets
   - Check Personal Access Token permissions
   - Ensure username matches Docker Hub account

3. **Container Startup Issues**
   - Check logs: `docker-compose logs moodle`
   - Verify database connection
   - Ensure required files exist (config.php)

## Status

- ✅ Docker configuration complete
- ✅ GitHub Actions workflow configured
- ✅ SSH key authentication fixed
- ✅ PHP 8.2 update for Moodle 5.0 compatibility
- ✅ SSH permissions fixed
- 🔄 CI/CD pipeline ready for deployment

Last updated: 2025-07-30 - SSH permissions fix completed 