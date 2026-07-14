# Docker


This guide shows how to package a basic .NET 8 Web API into a Docker image and run it locally.

---

## 1. Example Solution Structure

```text
Millions/
├── Millions.sln
├── Millions.Api/
│   ├── Millions.Api.csproj
│   ├── Program.cs
│   ├── appsettings.json
│   └── Dockerfile
└── .dockerignore
```

The `Dockerfile` lives inside the API project folder.

---

## 2. Create the Dockerfile

Create:

```text
Millions.Api/Dockerfile
```

Add:

```dockerfile
# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY ["Millions.Api/Millions.Api.csproj", "Millions.Api/"]

RUN dotnet restore "Millions.Api/Millions.Api.csproj"

COPY . .

WORKDIR "/src/Millions.Api"

RUN dotnet publish "Millions.Api.csproj" \
    --configuration Release \
    --output /app/publish \
    --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "Millions.Api.dll"]
```

---

## 3. What the Dockerfile Does

### Build Stage

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
```

Uses an image containing the complete .NET 8 SDK.

The SDK is required to:

* Restore NuGet packages
* Compile the application
* Publish the application

### Set the Working Directory

```dockerfile
WORKDIR /src
```

Creates and switches to the `/src` directory inside the temporary build container.

### Copy the Project File

```dockerfile
COPY ["Millions.Api/Millions.Api.csproj", "Millions.Api/"]
```

Copies the project file before the rest of the source code.

This allows Docker to reuse the NuGet restore layer when the project dependencies have not changed.

### Restore NuGet Packages

```dockerfile
RUN dotnet restore "Millions.Api/Millions.Api.csproj"
```

Downloads all NuGet packages required by the project.

### Copy the Source Code

```dockerfile
COPY . .
```

Copies the remaining solution files into the build container.

### Publish the API

```dockerfile
RUN dotnet publish "Millions.Api.csproj" \
    --configuration Release \
    --output /app/publish \
    --no-restore
```

Compiles and publishes the API into `/app/publish`.

### Runtime Stage

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
```

Starts a clean image containing only the ASP.NET Core runtime.

The final image does not contain the complete .NET SDK or the source code.

### Copy the Published Application

```dockerfile
COPY --from=build /app/publish .
```

Copies only the published output from the build stage into the final runtime image.

### Start the API

```dockerfile
ENTRYPOINT ["dotnet", "Millions.Api.dll"]
```

Runs the API when the container starts.

---

## 4. Create a `.dockerignore`

Create `.dockerignore` beside the solution file:

```text
Millions/.dockerignore
```

Add:

```text
**/bin/
**/obj/
**/.vs/
**/.vscode/
**/node_modules/
.git/
.gitignore
Dockerfile*
README.md
```

This prevents unnecessary files from being copied into the Docker build context.

---

## 5. Build the Docker Image

Run the command from the solution root:

```bash
docker build \
  --file Millions.Api/Dockerfile \
  --tag millions-api:v1 .
```

### Command Breakdown

```text
--file Millions.Api/Dockerfile
```

Uses the Dockerfile located inside the `Millions.Api` project.

```text
--tag millions-api:v1
```

Names the image `millions-api` and assigns the tag `v1`.

```text
.
```

Uses the current directory as the Docker build context.

The final period is required.

---

## 6. Confirm the Image Exists

Run:

```bash
docker images
```

Expected result:

```text
REPOSITORY     TAG    IMAGE ID
millions-api   v1     abc123
```

---

## 7. Run the Container

```bash
docker run \
  --name millions-api \
  --publish 8080:8080 \
  millions-api:v1
```

### Command Breakdown

```text
--name millions-api
```

Names the running container.

```text
--publish 8080:8080
```

Maps port `8080` on your computer to port `8080` inside the container.

```text
localhost:8080
        ↓
container:8080
```

Open:

```text
http://localhost:8080
```

For Swagger:

```text
http://localhost:8080/swagger
```

Swagger must be enabled in the selected ASP.NET environment.

---

## 8. Run with Environment Variables

Environment-specific values should not be built directly into the Docker image.

Example:

```bash
docker run \
  --name millions-api \
  --publish 8080:8080 \
  --env ASPNETCORE_ENVIRONMENT=Development \
  --env ConnectionStrings__MillionsDatabase="Server=..." \
  millions-api:v1
```

ASP.NET converts:

```text
ConnectionStrings__MillionsDatabase
```

into:

```json
{
  "ConnectionStrings": {
    "MillionsDatabase": "Server=..."
  }
}
```

Never commit real passwords or connection strings into the repository.

---

## 9. Stop and Remove the Container

Stop the container:

```bash
docker stop millions-api
```

Remove the container:

```bash
docker rm millions-api
```

Remove the image:

```bash
docker rmi millions-api:v1
```

---

## 10. Rebuild After Code Changes

Build a new version:

```bash
docker build \
  --file Millions.Api/Dockerfile \
  --tag millions-api:v2 .
```

Run the new image:

```bash
docker run \
  --name millions-api-v2 \
  --publish 8080:8080 \
  millions-api:v2
```

Each image tag represents a specific version of the application.

---

## 11. Local Deployment Flow

```text
Millions source code
        ↓
docker build
        ↓
millions-api:v1
        ↓
docker run
        ↓
Running container
```

---

## 12. AWS Deployment Flow

```text
Millions source code
        ↓
GitHub Actions
        ↓
docker build
        ↓
millions-api:v1
        ↓
Push image to Amazon ECR
        ↓
Amazon ECS pulls the image
        ↓
ECS starts the container
```

Example ECR image:

```text
123456789012.dkr.ecr.ca-central-1.amazonaws.com/millions-api:v1
```

---

## 13. Azure Deployment Flow

```text
Millions source code
        ↓
Azure DevOps
        ↓
docker build
        ↓
millions-api:v1
        ↓
Push image to Azure Container Registry
        ↓
Azure Container Apps, App Service, or AKS pulls the image
```

---

## 14. What Goes Inside the Image

The final Millions API image contains:

```text
.NET runtime
Millions.Api.dll
Dependent DLL files
Published configuration files
Application startup command
```

It does not contain:

```text
SQL Database
Cosmos DB
Blob Storage
Amazon S3
Source repository
Production secrets
Terraform infrastructure
```

Those remain external services that the API container connects to.

---

## 15. Multi-Stage Build

The Dockerfile uses two separate stages.

### Build Stage

```text
Full .NET SDK
Source code
NuGet packages
Compilation tools
Published application output
```

### Runtime Stage

```text
ASP.NET runtime
Published Millions API
Startup command
```

Benefits:

* Smaller final image
* No source code in the runtime image
* No unnecessary build tools in production
* Reduced security surface
* Cleaner separation between building and running

---

## 16. Common Problems

### Docker Cannot Find the `.csproj`

Make sure the build command runs from the solution root:

```bash
docker build -f Millions.Api/Dockerfile -t millions-api:v1 .
```

The final period matters.

### Container Starts but the API Is Unreachable

Confirm the Dockerfile contains:

```dockerfile
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
```

Run the container with:

```bash
docker run -p 8080:8080 millions-api:v1
```

### Swagger Does Not Appear

Swagger may only be enabled in Development.

Run:

```bash
docker run \
  -p 8080:8080 \
  -e ASPNETCORE_ENVIRONMENT=Development \
  millions-api:v1
```

### Database Connection Fails

Inside a Docker container, `localhost` refers to the container itself.

A database running directly on your computer may need:

```text
host.docker.internal
```

instead of:

```text
localhost
```

### HTTPS Certificate Errors

For an initial local Docker test, expose the application over HTTP inside the container.

In a deployed environment, TLS is commonly terminated by:

* AWS Application Load Balancer
* Azure Application Gateway
* Reverse proxy
* Kubernetes ingress controller
* CloudFront

---

## 17. Key Takeaway

The Docker image replaces the ZIP artifact.

### Traditional App Service Deployment

```text
dotnet publish
        ↓
ZIP artifact
        ↓
Release pipeline
        ↓
Azure App Service
```

### Container Deployment

```text
dotnet publish inside Docker
        ↓
Docker image
        ↓
ECR or ACR
        ↓
ECS, AKS, App Service, or another container platform
```

The build pipeline creates the image once.

The deployment platform runs that exact image without cloning the repository, restoring packages, or compiling the application again.
