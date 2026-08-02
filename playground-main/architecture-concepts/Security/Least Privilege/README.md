# Least Privilege

Least privilege means giving users, services, and systems only the access they actually need, and no more.

## What Least Privilege Is Really About

This principle reduces blast radius.

If one identity is compromised, least privilege helps limit:

- what can be read
- what can be changed
- what can be deleted
- how far the compromise spreads

## Where It Applies

- user accounts
- admins
- service accounts
- cloud workloads
- CI/CD pipelines

## Example: Storage Access

An app needs to read files from storage.

Weak design:

- give it owner access to the whole subscription

Better design:

- give it read-only access to the specific storage resource

## Example: Production Access

Engineers may need temporary production access during incidents.

Least privilege suggests:

- just-in-time access
- scoped roles
- audited elevation

instead of permanent broad admin rights.

## Why It Matters

Least privilege improves:

- security
- auditability
- compliance posture
- recovery containment

## Common Pitfalls

- granting broad access for convenience
- never removing unused roles
- sharing powerful service credentials
- using one identity for many unrelated workloads

## What Interviewers Like To Hear

- `I want access scoped to the exact action and resource needed.`
- `Least privilege applies to workloads as much as to people.`
- `Temporary elevation is better than permanent broad access where possible.`

## Quick Study Prompts

- Why is least privilege important for cloud workloads
- What is an example of over-permissioning
- Why are shared admin credentials dangerous
- How does least privilege reduce blast radius
