# Authentication

Authentication answers the question: who are you

It is the process of verifying identity before a system decides what a user or service is allowed to do.

## What Authentication Is Really About

Authentication is the first trust gate in a system.

It is used for:

- human users
- services calling other services
- administrators
- workloads running in cloud platforms

## Common Authentication Methods

### Username and Password

Still common, but weak on its own if not paired with stronger controls.

### Multi-Factor Authentication

Adds another proof, such as:

- authenticator app
- text code
- hardware token

### Token-Based Authentication

Common in modern APIs and web apps.

Examples:

- JWT access tokens
- OAuth access tokens

### Federated Identity

Uses a trusted identity provider such as:

- Entra ID
- Okta
- Google

### Service Identity

Non-human identity for workloads.

Examples:

- managed identity
- service principals
- IAM roles

## Basic Flow

```text
User -> Login Request -> Identity Provider
                        |
                        v
                  Token Issued
                        |
                        v
User -> API with Token -> Token Validation -> Request Continues
```

## Authentication vs Authorization

Authentication proves identity.

Authorization decides what that identity can do.

Example:

- authentication confirms you are Priya
- authorization decides whether Priya can delete a resource

## Example: Public Web App

A user logs into a web app with Entra ID.

Strong architecture points:

- authentication is centralized
- the app trusts issued tokens instead of storing passwords
- MFA can be enforced by the identity provider

## Example: Service-to-Service Authentication

An API needs to call blob storage.

Weak approach:

- store account keys in config

Stronger approach:

- use managed identity
- grant only the needed role

## Risks and Pitfalls

- storing passwords or secrets insecurely
- long-lived tokens without proper expiry
- skipping MFA for privileged access
- mixing identity logic into every service separately

## What Interviewers Like To Hear

- `I prefer centralized identity where possible.`
- `Authentication proves identity, but it does not decide permissions by itself.`
- `For workloads, I prefer managed identity or platform-native service identity over embedded secrets.`

## Quick Study Prompts

- What is the difference between authentication and authorization
- Why is MFA important
- Why is federated identity usually better than every app managing passwords
- Why is managed identity a strong authentication pattern for workloads
