# Publishing Docker Images

This document explains how to build and publish multi-platform Docker images for ExcaliDash.

## Quick Start

```bash
# Login to Docker Hub (if not already logged in)
docker login

# Build and push images
./publish-docker.sh
```

## Usage

```bash
./publish-docker.sh [VERSION]
```

**Arguments:**

- `VERSION` (optional): The version tag for the images. Defaults to `latest`.

**Examples:**

```bash
# Build and push with 'latest' tag
./publish-docker.sh

# Build and push with version tag
./publish-docker.sh v1.0.0
./publish-docker.sh 2024.11.21
```

## What It Does

1. **Checks Docker Hub authentication** - Ensures you're logged in
2. **Sets up buildx builder** - Creates or uses existing multi-platform builder
3. **Builds backend image** - For linux/amd64 and linux/arm64 platforms
4. **Builds frontend image** - For linux/amd64 and linux/arm64 platforms
5. **Pushes to Docker Hub** - Uploads to `zimengxiong/excalidash-backend` and `zimengxiong/excalidash-frontend`

## Supported Platforms

- **linux/amd64** - Intel/AMD x86_64 processors (most servers, PCs)
- **linux/arm64** - ARM 64-bit processors (Apple Silicon, ARM servers, Raspberry Pi 4+)

## Requirements

- Docker with buildx support (Docker Desktop or Docker Engine 19.03+)
- Docker Hub account credentials
- Internet connection for pushing images

## Troubleshooting

### "buildx" is not a docker command

Update Docker to a newer version that includes buildx, or install the buildx plugin.

### Authentication error

Run `docker login` and enter your Docker Hub credentials.

### Build fails on specific platform

You can modify the script to build for only one platform:

```bash
# In publish-docker.sh, change:
--platform linux/amd64,linux/arm64
# to:
--platform linux/amd64
```

## Using Published Images

After publishing, users can run ExcaliDash using the pre-built images:

```bash
# Using production compose file (no build step needed)
docker compose -f docker-compose.prod.yml up -d

# Or using regular compose file (will pull if not building)
docker compose pull
docker compose up -d
```

## CI/CD Integration

You can integrate this script into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Build and Push Docker Images
  env:
    DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
    DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
  run: |
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    ./publish-docker.sh ${{ github.ref_name }}
```
