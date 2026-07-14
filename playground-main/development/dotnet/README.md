# .NET

Notes, samples, and best practices for .NET development.
# .NET Best Practices

A collection of .NET, cloud, architecture, and software engineering practices I've learned through real-world projects and ongoing learning.

---

# Solution Structure

## Project Organization

- Follow the Single Responsibility Principle.
- Keep APIs, business logic, data access, and shared libraries separated.
- Avoid circular dependencies.
- Use clear and consistent project names.
- Keep reusable code in shared libraries.
- Keep projects small and focused.

---

# Dependency Injection

## Best Practices

- Prefer constructor injection.
- Inject abstractions instead of concrete classes.
- Register services with the correct lifetime.
- Avoid service locator patterns.
- Keep services focused on one responsibility.

## Service Lifetimes

### Singleton

- One instance for the lifetime of the application.
- Good for stateless shared services.

### Scoped

- One instance per request.
- Ideal for database contexts.

### Transient

- New instance every time it is requested.
- Good for lightweight services.

---

# REST APIs

## Design Principles

- Use nouns instead of verbs.
- Use meaningful resource names.
- Return appropriate HTTP status codes.
- Validate all input.
- Version APIs.
- Keep endpoints focused.

### Examples

GET /projects

POST /projects

PUT /projects/{id}

DELETE /projects/{id}

---

# Authentication & Authorization

## Best Practices

- Authenticate before authorizing.
- Never trust client input.
- Use claims-based authorization.
- Use OAuth/OpenID Connect where appropriate.
- Prefer Managed Identity over secrets.
- Never expose sensitive information.

### Topics

- JWT
- OAuth
- OpenID Connect
- Easy Auth
- Managed Identity
- User Impersonation

---

# Logging

## Best Practices

- Log meaningful events.
- Include correlation IDs.
- Prefer structured logging.
- Log unexpected failures.

### Tools

- ILogger
- Application Insights
- OpenTelemetry
- Log Analytics

---

# Exception Handling

## Best Practices

- Catch only exceptions you can handle.
- Avoid swallowing exceptions.
- Use global exception middleware.
- Return meaningful API responses.
- Log unexpected exceptions.

---

# Async Programming

## Best Practices

- Async all the way.
- Avoid .Result.
- Avoid .Wait().
- Await database calls.
- Await HTTP calls.

---

# Entity Framework

## Best Practices

- Use async queries.
- Project into DTOs.
- Avoid SELECT * equivalents.
- Avoid unnecessary Includes.
- Only retrieve required data.

---

# SQL

## Best Practices

- Use parameterized queries.
- Avoid SELECT *.
- Index frequently queried columns.
- Use views for reporting.
- Let SQL handle filtering whenever possible.

---

# Configuration

## Best Practices

- Never hardcode secrets.
- Use environment variables.
- Store secrets in Key Vault or Secrets Manager.
- Separate configuration by environment.
- Keep configuration outside application code.

---

# Azure Functions

## Topics

- In-Process
- Isolated Worker
- HTTP Triggers
- Timer Triggers
- Service Bus Triggers
- Local Development
- Managed Identity
- host.json
- local.settings.json

---

# Security

## Best Practices

- Principle of Least Privilege.
- Validate all user input.
- Encrypt data in transit.
- Encrypt data at rest.
- Rotate secrets.
- Never commit secrets to source control.
- Use HTTPS everywhere.

---

# Docker

## Best Practices

- Use multi-stage builds.
- Keep images small.
- One application per container.
- Store configuration in environment variables.
- Never store secrets in images.

---

# Infrastructure as Code

## Best Practices

- Treat infrastructure like application code.
- Use reusable modules.
- Parameterize environments.
- Keep deployments repeatable.
- Review infrastructure through pull requests.
- Use What-If or Terraform Plan before deployment.

### Technologies

- Bicep
- ARM
- Terraform
- Terragrunt

---

# Cloud Design

## Best Practices

- Build stateless applications.
- Store files outside containers.
- Store sessions centrally.
- Prefer managed cloud services.
- Design for scalability.
- Design for resiliency.
- Design for observability.

---

# AI Applications

## Best Practices

- Keep prompts outside application code.
- Validate retrieved context.
- Never let an LLM make authorization decisions.
- Filter permissions before retrieval.
- Store metadata with embeddings.
- Use RAG for private company knowledge.
- Separate ingestion from querying.

---

# Performance

## Best Practices

- Cache where appropriate.
- Minimize database calls.
- Paginate large datasets.
- Stream large files.
- Reduce unnecessary network requests.
- Measure before optimizing.

---

# Code Reviews

## Best Practices

- Keep pull requests small.
- Prioritize readability.
- Use meaningful names.
- Remove dead code.
- Don't duplicate logic.
- Keep methods focused.
- Comment why, not what.

---

# Architecture Principles

- Understand the architecture before changing code.
- Infrastructure is as important as application code.
- Networking is often the root cause of cloud issues.
- Authentication is one of the hardest parts of cloud applications.
- Design for reuse.
- Build loosely coupled services.
- Prefer composition over duplication.
- Learn concepts before cloud-specific implementations.

---

# Common Mistakes to Avoid

- Hardcoded secrets.
- Missing Managed Identity permissions.
- Incorrect subnet configuration.
- Private DNS misconfiguration.
- Incorrect environment variables.
- Pipeline variable mismatches.
- Missing NuGet packages.
- Incorrect authentication configuration.
- Ignoring logging.
- Deploying without validating infrastructure changes.

---

# Personal Lessons Learned

- Always understand why something works before memorizing how.
- Cloud concepts transfer across providers even when the service names change.
- Good architecture simplifies development.
- Documentation saves future debugging time.
- Small improvements made consistently compound over time.
- Build things yourself to truly understand them.
- Ask questions until the system makes sense.
- Focus on learning patterns rather than memorizing services.

---
