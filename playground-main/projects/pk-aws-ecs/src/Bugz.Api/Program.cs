var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

app.MapGet("/health", () => Results.Ok(new
{
    status = "healthy",
    name = Environment.GetEnvironmentVariable("PET_NAME") ?? "PK the Presa"
}));

app.MapGet("/api/info", () => Results.Ok(new
{
    name = Environment.GetEnvironmentVariable("PET_NAME") ?? "PK the Presa",
    provider = Environment.GetEnvironmentVariable("CLOUD_PROVIDER") ?? "AWS",
    platform = Environment.GetEnvironmentVariable("PLATFORM") ?? "ECS Fargate",
    version = Environment.GetEnvironmentVariable("APP_VERSION") ?? "1.0.0"
}));

app.Run();
