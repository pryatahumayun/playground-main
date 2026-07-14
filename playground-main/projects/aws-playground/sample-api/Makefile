# ── Variables ────────────────────────────────────────────────────────────────
PROJECT_PATH    := src/sample-api.csproj
CONFIGURATION   := Release
DOCKER_IMAGE    := sample-api

# Version: date + short git SHA  (matches mfa-api pattern)
VERSION_DATE    := $(shell date +'%Y.%m.%d.%H%M')
VERSION_GIT_SHA := $(shell git rev-parse --short=7 HEAD)
VERSION         := $(VERSION_DATE)-$(VERSION_GIT_SHA)

# ECR — filled in at CI time via environment variables
# AWS_ECR_REGISTRY  is output by the `amazon-ecr-login` action
# ECR_REPOSITORY    is set as a GitHub Actions variable (e.g. sample-api)
AWS_ECR_IMAGE   := $(AWS_ECR_REGISTRY)/$(ECR_REPOSITORY)

# ── Phony targets ─────────────────────────────────────────────────────────────
.PHONY: version restore build test clean run \
        docker-build docker-push \
        docker-tag-staging-ecr docker-tag-latest-ecr \
        aws-ecr-login

# ── App targets ───────────────────────────────────────────────────────────────
version:
	@echo $(VERSION)

restore:
	@echo "Restoring NuGet packages..."
	dotnet restore $(PROJECT_PATH)

build: restore
	@echo "Building $(VERSION)..."
	dotnet build $(PROJECT_PATH) -c $(CONFIGURATION) -p:Version=$(VERSION)

test: build
	@echo "Running tests..."
	dotnet test $(PROJECT_PATH) -c $(CONFIGURATION)

clean:
	@echo "Cleaning..."
	dotnet clean $(PROJECT_PATH)

run: build
	dotnet run --project $(PROJECT_PATH)

# ── Docker targets ────────────────────────────────────────────────────────────
docker-build:
	@echo "Building Docker image $(VERSION)..."
	docker build --platform linux/amd64 \
		--build-arg VERSION=$(VERSION) \
		-t $(DOCKER_IMAGE):$(VERSION) .
	@echo "BUILD_VERSION=$(VERSION)"

docker-push:
	@if [ -z "$(VERSION_TO_PUSH)" ]; then \
		echo "Error: VERSION_TO_PUSH is required. Example: make docker-push VERSION_TO_PUSH=<version>"; \
		exit 1; \
	fi
	@echo "Pushing $(VERSION_TO_PUSH) to ECR..."
	docker tag $(DOCKER_IMAGE):$(VERSION_TO_PUSH) $(AWS_ECR_IMAGE):$(VERSION_TO_PUSH)
	docker push $(AWS_ECR_IMAGE):$(VERSION_TO_PUSH)

# Retag a versioned image as 'staging' (deployed to staging ECS)
docker-tag-staging-ecr:
	@if [ -z "$(VERSION_TO_TAG)" ]; then \
		echo "Error: VERSION_TO_TAG is required. Example: make docker-tag-staging-ecr VERSION_TO_TAG=<version>"; \
		exit 1; \
	fi
	@echo "Tagging $(VERSION_TO_TAG) as staging..."
	docker pull $(AWS_ECR_IMAGE):$(VERSION_TO_TAG)
	docker tag  $(AWS_ECR_IMAGE):$(VERSION_TO_TAG) $(AWS_ECR_IMAGE):staging
	docker push $(AWS_ECR_IMAGE):staging

# Retag a versioned image as 'latest' (deployed to prod ECS)
docker-tag-latest-ecr:
	@if [ -z "$(VERSION_TO_TAG)" ]; then \
		echo "Error: VERSION_TO_TAG is required. Example: make docker-tag-latest-ecr VERSION_TO_TAG=<version>"; \
		exit 1; \
	fi
	@echo "Tagging $(VERSION_TO_TAG) as latest..."
	docker pull $(AWS_ECR_IMAGE):$(VERSION_TO_TAG)
	docker tag  $(AWS_ECR_IMAGE):$(VERSION_TO_TAG) $(AWS_ECR_IMAGE):latest
	docker push $(AWS_ECR_IMAGE):latest

# ── AWS helpers ───────────────────────────────────────────────────────────────
aws-ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) \
	  | docker login --username AWS --password-stdin $(AWS_ECR_REGISTRY)
