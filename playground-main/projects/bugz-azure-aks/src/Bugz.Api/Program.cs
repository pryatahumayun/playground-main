using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Map port from ASPNETCORE_HTTP_PORTS env if set (fallback to 8080)
var portEnv = Environment.GetEnvironmentVariable("ASPNETCORE_HTTP_PORTS") ?? "8080";
builder.WebHost.UseUrls($"http://*:{portEnv}");

var app = builder.Build();

app.MapGet("/", () => Results.Ok(new {
    name = Environment.GetEnvironmentVariable("PET_NAME") ?? "Bugz",
    provider = Environment.GetEnvironmentVariable("CLOUD_PROVIDER") ?? "Azure",
    platform = Environment.GetEnvironmentVariable("PLATFORM") ?? "AKS"
}));

app.MapGet("/health", () => Results.Ok(new { status = "Healthy", now = DateTime.UtcNow }));

app.MapGet("/cloud", () => Results.Ok(new {
    cloud = Environment.GetEnvironmentVariable("CLOUD_PROVIDER") ?? "Azure"
}));

app.MapGet("/version", () => Results.Ok(new {
    version = Environment.GetEnvironmentVariable("APP_VERSION") ?? "1.0.0"
}));

app.Run();
