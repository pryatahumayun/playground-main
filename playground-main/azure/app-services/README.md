# Azure App Services

## What I've Learned

Azure App Services are one of the easiest ways to host web applications, but a surprising amount of their behaviour is controlled by configuration rather than code.

---

## Lessons Learned

### App Service Plan vs App Service

One App Service Plan can host multiple App Services.

Scaling the App Service Plan scales every App Service running on that plan.

---

### Environment Variables Drive Behaviour

One of the biggest lessons I've learnt is that Azure App Services rely heavily on **environment variables (Application Settings)**.

Many runtime features are enabled simply by setting the correct configuration value.

Examples:

- .NET version
- Runtime stack
- Azure Functions worker model
- WEBSITE_RUN_FROM_PACKAGE
- WEBSITE_DNS_SERVER
- ASPNETCORE_ENVIRONMENT
- Connection strings
- Feature flags

Sometimes changing one setting completely changes how the application behaves without touching the code.

---

### Application Settings Become Environment Variables

Every App Setting in Azure becomes an environment variable available to the application.

For example:

```
ASPNETCORE_ENVIRONMENT=Development
```

becomes

```csharp
Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT")
```

or

```csharp
builder.Configuration["ASPNETCORE_ENVIRONMENT"]
```

---

### Environment Variables Override web.config / appsettings.json

This one caught me by surprise.

Configuration is loaded in order.

Typically:

```
appsettings.json
↓

appsettings.{Environment}.json
↓

Environment Variables
```

The last value wins.

That means if Azure has an Application Setting with the same key, **Azure overrides whatever is in appsettings.json or web.config.**

This allows the exact same application package to be deployed to Dev, Test, QA and Production without changing the code.

---

### Azure Functions Runtime Depends on Configuration

I ran into this while working with .NET 8.

Whether Azure treats a Function App as **In-Process** or **Isolated Worker** isn't just determined by the project.

The Function App configuration must also match.

For example:

```
FUNCTIONS_WORKER_RUNTIME=dotnet-isolated
```

If this setting isn't correct, Azure won't recognize the application as an Isolated Worker Function.

Sometimes the portal won't even show the expected runtime because the configuration doesn't match the application.

Lesson:

> Always check the Function App configuration before assuming the deployment failed.

---

### WEBSITE_DNS_SERVER

This setting is commonly used when an App Service is integrated with a VNET.

Without the correct DNS server, private endpoints may fail even though networking appears correct.

Networking problems are often DNS problems.

---

### Managed Identity

Instead of storing passwords:

```
SQL Username
SQL Password
Storage Keys
Key Vault Secrets
```

Prefer using Managed Identity whenever Azure supports it.

Less configuration.

Better security.

No secret rotation.

---

### Easy Auth

Azure can authenticate users before requests even reach the application.

This means:

Client
↓

Easy Auth

↓

Application

Your code can focus on authorization rather than implementing an authentication system.

---

## Things I Always Check First

When something behaves differently between environments:

- Runtime Stack
- App Settings
- Environment Variables
- Managed Identity
- Authentication
- VNET Integration
- DNS
- Private Endpoint
- Diagnostic Settings
- Application Insights

More often than not, the issue isn't the code.
It's the configuration.

---

## ⭐ My Favourite Fucking Button (Literally saved me during a production deploy): Pull Reference Values

If your App Settings contain **Key Vault references**, Azure doesn't always immediately pull the newest secret value after a change.

Before assuming:

- the deployment failed,
- Managed Identity is broken,
- Key Vault permissions are wrong,
- or that you need to redeploy...

Try pressing:

```
Pull Reference Values
```

This tells Azure to refresh all of the Key Vault references for the App Service or Function App.

I've had situations where:

- the secret existed,
- permissions were correct,
- the deployment was successful,

...but Azure was still using an old or unresolved value.

Pressing **Pull Reference Values** fixed it instantly.



This is now one of the first buttons I press when troubleshooting configuration issues.
