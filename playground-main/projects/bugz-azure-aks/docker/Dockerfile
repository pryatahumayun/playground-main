# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY src/Bugz.Api/ ./src/Bugz.Api/
WORKDIR /src/src/Bugz.Api
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
# create non-root user and set permissions where possible
RUN useradd -m appuser || true
WORKDIR /app
COPY --from=build /app/publish ./
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
# try to run as non-root when supported
USER appuser
ENTRYPOINT ["dotnet", "Bugz.Api.dll"]
