FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

ARG VERSION=0.0.0

COPY src/ ./
RUN dotnet restore
RUN dotnet publish -c Release -p:Version=$VERSION -o /out

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS run
WORKDIR /app
COPY --from=build /out .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8080/healthz || exit 1

ENTRYPOINT ["dotnet", "sample-api.dll"]
