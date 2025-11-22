# ExcaliDash Docker Setup

This Docker setup containerizes the ExcaliDash application with a multi-container architecture.

## Architecture

- **Frontend**: React/Vite app served by Nginx
- **Backend**: Express.js API with Socket.IO
- **Database**: SQLite (persisted in Docker volume)

## Single Port Exposure

The application exposes only **port 6767** externally, which serves the frontend. The frontend's Nginx acts as a reverse proxy to route:

- `/api/*` requests to the backend container
- `/socket.io/*` WebSocket connections to the backend container

All inter-container communication happens on an internal Docker network.

## Quick Start

### Option 1: Use Pre-built Images from Docker Hub (Recommended)

Pull and run the latest multi-platform images:

```bash
docker compose -f docker-compose.prod.yml up -d
```

### Option 2: Build Locally

Build and run all services locally:

```bash
docker compose up -d --build
```

### Access the application:

Open your browser to `http://localhost:6767`

## Publishing to Docker Hub

### Build and Push Multi-Platform Images

The `publish-docker.sh` script builds images for multiple platforms (amd64, arm64) and pushes them to Docker Hub:

```bash
# Build and push with 'latest' tag
./publish-docker.sh

# Build and push with a specific version
./publish-docker.sh v1.0.0
```

**Prerequisites:**

- Docker Buildx enabled
- Logged in to Docker Hub: `docker login`

**Platforms supported:**

- `linux/amd64` (Intel/AMD x86_64)
- `linux/arm64` (Apple Silicon, ARM servers)

The script will:

1. Create a buildx builder if needed
2. Build both frontend and backend images for all platforms
3. Push to `zimengxiong/excalidash-backend` and `zimengxiong/excalidash-frontend`
4. Tag with both the specified version and `latest`

## Management Commands

### View logs:

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
```

### Stop services:

```bash
docker compose down
```

### Stop and remove volumes (clean slate):

```bash
docker compose down -v
```

### Restart services:

```bash
docker compose restart
```

### Check service status:

```bash
docker compose ps
```

## Development

For local development outside Docker, use the existing npm scripts:

**Backend:**

```bash
cd backend
npm install
npm run dev
```

**Frontend:**

```bash
cd frontend
npm install
npm run dev
```

## Database

The SQLite database is stored in a Docker volume named `backend-data` which persists data across container restarts. Database migrations run automatically when the backend container starts.

## Environment Variables

Default configuration works out of the box. To customize:

Create `.env` files in `backend/` or `frontend/` directories:

**Backend `.env`:**

```
PORT=8000
NODE_ENV=production
```

**Frontend `.env`:**

```
VITE_API_URL=/api
```

## Troubleshooting

### Check health status:

```bash
docker-compose ps
```

Both services should show "healthy" status.

### Reset database:

```bash
docker-compose down -v
docker-compose up -d
```

### View detailed backend logs:

```bash
docker-compose logs backend
```

### Rebuild specific service:

```bash
docker-compose up -d --build backend
```

## Production Deployment

For production deployment:

1. Use proper environment variables
2. Configure proper CORS settings in the backend
3. Add HTTPS/TLS termination (e.g., via reverse proxy like Traefik or nginx)
4. Consider using PostgreSQL instead of SQLite for better concurrency
5. Set up proper backup strategy for the `backend-data` volume

## Port Mapping

- **6767** (external) → **80** (frontend nginx) → Routes to backend on internal network
- **8000** (internal only) - Backend API server

Only port 6767 is accessible from outside the Docker network.
