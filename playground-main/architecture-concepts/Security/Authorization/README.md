# Authorization

Authorization answers the question: what are you allowed to do

It happens after authentication and determines which actions, data, or resources an identity can access.

## What Authorization Is Really About

Authorization is about control boundaries.

It answers questions like:

- can this user read this record
- can this service write to this queue
- can this admin delete this environment

## Common Authorization Models

### RBAC

Role-Based Access Control.

Permissions are attached to roles.

Examples:

- Reader
- Contributor
- BillingAdmin

### ABAC

Attribute-Based Access Control.

Access depends on attributes such as:

- department
- environment
- resource tag
- request context

### Policy-Based Authorization

Rules are evaluated against claims, roles, or conditions.

Common in APIs and modern app frameworks.

## Basic Flow

```text
Authenticate Identity
        |
        v
Evaluate Roles / Claims / Policies
        |
        v
Allow or Deny Action
```

## Example: Admin Portal

Not every authenticated employee should be able to:

- change billing settings
- delete user data
- approve production releases

A strong design uses role or policy checks so sensitive actions are limited to the right users.

## Example: API Authorization

A customer should only be able to view their own orders.

That means authorization is not just "is logged in." It is also:

- is this order owned by this identity

## Service Authorization

Authorization also applies to workloads.

Example:

- one service gets read access to a storage account
- another gets write access
- neither gets full subscription admin access

## Risks and Pitfalls

- hardcoding permissions everywhere
- giving broad admin rights for convenience
- failing open instead of failing closed
- not logging denied or privileged actions

## What Interviewers Like To Hear

- `Authentication and authorization solve different problems.`
- `I prefer least privilege and role or policy boundaries instead of broad access.`
- `Authorization should be explicit, testable, and auditable.`

## Quick Study Prompts

- What is the difference between RBAC and ABAC
- Why is “authenticated” not enough
- Why should authorization logic be consistent across the system
- How does authorization apply to service identities too
