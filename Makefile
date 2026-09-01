# ============================================
# Makefile for Laravel CI/CD Project
# ============================================

.PHONY: help install up down test build deploy

# Default target
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Development commands
install: ## Install dependencies
	composer install
	npm install
	php artisan key:generate

up: ## Start Docker containers
	docker compose up -d

down: ## Stop Docker containers
	docker compose down

build: ## Build Docker image
	docker compose build --no-cache

logs: ## View container logs
	docker compose logs -f

# Testing commands
test: ## Run tests
	php artisan test

test-docker: ## Run tests in Docker
	docker compose exec app php artisan test

lint: ## Run code quality checks
	vendor/bin/pint --test

# Database commands
migrate: ## Run migrations
	php artisan migrate

migrate-fresh: ## Fresh migration with seeding
	php artisan migrate:fresh --seed

# Deployment commands
deploy: ## Deploy to production
	@echo "Deployment would run here in CI/CD pipeline"

# Cache commands
cache-clear: ## Clear all caches
	php artisan cache:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear

cache-optimize: ## Optimize for production
	php artisan config:cache
	php artisan route:cache
	php artisan view:cache
