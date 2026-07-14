using Microsoft.AspNetCore.Diagnostics.HealthChecks;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHealthChecks();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapHealthChecks("/healthz", new HealthCheckOptions { AllowCachingResponses = false });
app.MapHealthChecks("/livez",   new HealthCheckOptions { AllowCachingResponses = false });

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
