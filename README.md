# Laravel CI/CD Project

A complete CI/CD pipeline for a Laravel application using Docker and GitHub Actions.

## 📚 What you'll learn

- **CI** (Continuous Integration): Git push triggers automated tests and code quality checks
- **CD** (Continuous Delivery): Passing tests build a Docker image automatically
- **Continuous Deployment**: Docker image deployed to your production server

## 🏗️ Pipeline Overview

```
Git Push → GitHub Actions → Tests → Docker Build → Docker Hub → Deploy to Server
```

Three stages in `.github/workflows/ci-cd.yml`:

| Job | Runs when | Purpose |
|-----|-----------|---------|
| `test` | every push/PR | Run migrations + PHPUnit tests + Pint code style |
| `docker-build` | push to `main` (after tests pass) | Build & push Docker image to Docker Hub |
| `deploy` | push to `main` (after build) | SSH to server & `docker compose up` |

## 🚀 Local Development

### 1. Clone & install
```bash
git clone https://github.com/SandeepX/CICD.git
cd CICD
cp .env.example .env
php artisan key:generate
composer install
npm install
```

### 2. Run with Docker
```bash
docker compose up -d         # starts app + nginx + mysql + redis
docker compose exec app php artisan migrate
```
Open http://localhost:8080

### 3. Useful endpoints
- `GET /` — Welcome page
- `GET /api/health` — Simple health check
- `GET /api/health/detailed` — DB / cache / storage checks
- `GET /api/posts` — Sample API resource

### 4. Run tests locally
```bash
php artisan test
make test     # or via Makefile
```

## 🔧 Project Structure

```
CICD/
├── .github/workflows/
│   └── ci-cd.yml          # CI/CD pipeline
├── docker/
│   └── nginx.conf         # Nginx server block
├── app/Http/Controllers/
│   ├── HealthCheckController.php
│   └── Api/PostController.php
├── routes/
│   ├── web.php
│   └── api.php
├── tests/Feature/
│   └── HealthCheckTest.php
├── Dockerfile             # Multi-stage image
├── docker-compose.yml     # Services (app, nginx, mysql, redis)
└── Makefile               # Shortcut commands
```

## 🔐 GitHub Secrets (required)

Add these in **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub access token |
| `SERVER_HOST` | Production server IP/domain |
| `SERVER_USER` | SSH username on server |
| `SSH_PRIVATE_KEY` | Private key to SSH into server |

## 🚢 Setting up Docker Hub

1. Create account at [hub.docker.com](https://hub.docker.com)
2. Create a repository named `sandeepx/cicd-laravel`
3. Generate an **Access Token** (Account Settings → Security)
4. Add `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets in GitHub

## 📡 Setting up the production server

On the server, `cd /var/www && git clone https://github.com/SandeepX/CICD.git cicd-laravel`, ensure Docker is installed, and the SSH key from `SSH_PRIVATE_KEY` is authorized.

## 🧰 Makefile Commands

```bash
make up          # start containers
make down        # stop containers
make test        # run tests
make build       # rebuild docker image
make logs        # tail container logs
make migrate     # run db migrations
make cache-clear # clear all caches
```

## 📚 Resources

- [GitHub Actions docs](https://docs.github.com/en/actions)
- [Docker docs](https://docs.docker.com/)
- [Laravel docs](https://laravel.com/docs)
