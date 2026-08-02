# Security

Security topics come up in architecture interviews because every design decision has trust, access, and data protection implications.

## Topics

- [Authentication](./Authentication/README.md)
- [Authorization](./Authorization/README.md)
- [Encryption](./Encryption/README.md)
- [TLS](./TLS/README.md)
- [Least Privilege](./Least%20Privilege/README.md)
- [Defense in Depth](./Defense%20in%20Depth/README.md)

## Why Security Belongs in Architecture

Security is not a separate phase after design. It is part of the design.

A system can scale well and still be poorly architected if it:

- exposes secrets carelessly
- gives workloads too much access
- lacks secure transport
- has weak boundaries between trusted and untrusted actors

## Example: Cloud API with a Database

Imagine a public API backed by a database.

A security-aware architecture would think about:

- `Authentication`: how users or services prove identity
- `Authorization`: what each caller is allowed to do
- `Encryption`: how stored data is protected
- `TLS`: how traffic is protected in transit
- `Least Privilege`: whether the app only has the minimum DB permissions it needs
- `Defense in Depth`: what happens if one control fails

## Example: Managed Identity vs Stored Secrets

Suppose a cloud application needs access to storage or a container registry.

Weak answer:

- store a shared password in app settings

Stronger answer:

- use managed identity
- assign only the required role
- avoid long-lived credentials where possible

That is a very practical example of least privilege and stronger secret handling.

## Example: Admin Portal

An internal admin portal for customer accounts should usually include:

- strong authentication, ideally MFA
- role-based authorization
- audit logging for sensitive actions
- TLS for all access
- separation between normal users and support staff permissions

This is a good example because it shows security is also about business control, not just crypto.

## Example: Defense in Depth

If one API endpoint is exposed to the internet, you should not rely on only one protection.

A better layered design might include:

- authenticated access
- authorization checks
- TLS
- WAF or ingress protections
- network restrictions where possible
- monitoring and alerting

That is what defense in depth means in practice.

## What Interviewers Like To Hear

Strong phrases in security answers often sound like:

- `I would avoid embedding credentials and prefer managed identity where the platform supports it.`
- `Authentication proves identity, but authorization decides what that identity can do.`
- `I would protect data both in transit and at rest.`
- `I would reduce blast radius by giving the service only the permissions it actually needs.`

## Quick Study Prompts

- What is the difference between authentication and authorization
- Why is least privilege important for cloud workloads
- Why is TLS still important for internal traffic in some environments
- What does defense in depth look like in a real API platform
- Why is secret management an architecture concern, not just a coding concern
