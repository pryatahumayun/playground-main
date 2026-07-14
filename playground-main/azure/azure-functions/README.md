# Azure Functions
# Azure Functions

## What I've Learned

Azure Functions are Microsoft's serverless compute service. They let you execute code in response to events without worrying about managing servers.

Although Function Apps run on Azure App Services, they are designed around **events** rather than users.

Examples:

- HTTP Requests
- Service Bus Messages
- Event Grid Events
- Blob Uploads
- Timers
- Cosmos DB Changes

One of the biggest mindset shifts for me was realizing that most Functions don't have a user pressing a button. They're constantly reacting to events happening throughout the system.

---

# Real World Experience

A project I had to do but did not want to do **In-Process** hosting model to the **.NET Isolated Worker** model.

This involved:

- Updating the application architecture
- Migrating startup configuration
- Dependency Injection changes
- Authentication updates
- Deployment pipeline changes
- Runtime configuration
- Testing across multiple Azure environments

The migration gave me a much better understanding of how Azure Functions actually run in production.

---

# In-Process vs Isolated Worker

Microsoft's recommended hosting model is now **Isolated Worker**.

Benefits include:

- Better dependency management
- Independent .NET runtime
- Cleaner startup configuration
- Easier upgrades
- Future-proof for newer .NET versions

One important lesson:

Changing the project isn't enough.

The Azure Function App configuration must also match.

Always verify:

```
FUNCTIONS_WORKER_RUNTIME=dotnet-isolated
```

before assuming something went wrong with the deployment.

---

# Event Driven Architecture

Functions really shine when they're connected to Azure services.

Some examples I've worked with include:

```
User Created

↓

Event Grid

↓

Azure Function

↓

Create Report
```

or

```
Queue Message

↓

Service Bus

↓

Azure Function

↓

Process Request
```

This keeps applications loosely coupled and much easier to scale.

---

# Durable Functions

Not every task finishes immediately.

Durable Functions allow long-running workflows that can:

- Wait for approvals
- Wait for files
- Call multiple Functions
- Retry failed steps
- Maintain workflow state

They're useful when a process needs to happen over minutes, hours, or even days.

---

# Lessons Learned

### Configuration causes more problems than code.

If something works locally but not in Azure, check:

- Function App configuration
- Environment Variables
- Managed Identity
- Networking
- Storage Account
- Runtime version
- Authentication

before debugging the application.

---

### Storage Accounts are required.

Every Function App depends on an Azure Storage Account.

It's used for things like:

- Trigger management
- Scaling
- Host state
- Checkpoints
- Logging

Without it, the Function App won't operate correctly.

---

### Logging is everything.

Functions often execute without anyone watching.

Good logging is the only way to understand what happened after the fact.

Always include:

- Correlation IDs
- Request IDs
- Resource IDs
- External API failures
- Exceptions

---

### Small Functions are Better

One Function should perform one job well.

Large Functions become difficult to maintain and troubleshoot.

---

### Retry Behaviour Matters

Azure can automatically retry failed executions.

Functions should be designed so they can safely run more than once without creating duplicate data.

---

# Things Future Me Should Remember

- Azure Functions are event driven.
- The hosting model matters.
- Runtime configuration matters just as much as the code.
- The Function App configuration and the project configuration must agree.
- Check Azure before blaming Visual Studio.
- Most production issues aren't because Functions are broken. They're because something around the Function is.
