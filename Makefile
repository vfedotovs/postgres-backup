# Variables
IMAGE_NAME=mydockerhubuser/postgres-backup
GIT_COMMIT_SHA=$(shell git rev-parse --short HEAD)
VERSION_TAG=$(shell git describe --tags --abbrev=0 2>/dev/null || echo "latest")

# Default target
.PHONY: all
all: test lint build

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	pytest

# Run linter
.PHONY: lint
lint:
	@echo "Running linter..."
	flake8 .

# Build Docker image
.PHONY: build
build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME):$(GIT_COMMIT_SHA) .
	docker tag $(IMAGE_NAME):$(GIT_COMMIT_SHA) $(IMAGE_NAME):$(VERSION_TAG)

# Push Docker image
.PHONY: push
push: build
	@echo "Pushing Docker image..."
	docker push $(IMAGE_NAME):$(GIT_COMMIT_SHA)
	docker push $(IMAGE_NAME):$(VERSION_TAG)
