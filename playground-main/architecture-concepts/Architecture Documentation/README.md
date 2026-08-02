# Architecture Documentation

Architecture documentation shows that design is not just about diagrams. It is also about traceability, risk awareness, decision quality, and operational preparedness.

## Topics

- [Impact Analysis](./Impact%20Analysis/README.md)
- [Risk Assessment](./Risk%20Assessment/README.md)
- [Decision Records (ADR)](./Decision%20Records%20(ADR)/README.md)
- [Rollback Plans](./Rollback%20Plans/README.md)
- [Disaster Recovery](./Disaster%20Recovery/README.md)

## Why Documentation Matters

Documentation is what keeps architectural decisions understandable after the meeting ends.

Without it, teams forget:

- why a design was chosen
- what risks were accepted
- who is affected by change
- how to recover if rollout fails

## Example: API Version Change

Suppose a shared customer API needs a breaking schema change.

Good architecture documentation would include:

- `Impact Analysis`: which consumers call the API now
- `Risk Assessment`: what fails if one consumer cannot upgrade on time
- `ADR`: why versioning is being handled a certain way
- `Rollback Plan`: how to restore the old contract if deployment causes issues
- `Disaster Recovery`: whether the change affects backup, restore, or regional failover assumptions

That is much stronger than only updating a diagram.

## Example: Database Migration

A database schema migration is one of the best examples for this section.

Questions documentation should answer:

- does the change break old application versions
- can the migration be rolled back
- is the deployment order app first or DB first
- what happens if the migration partially succeeds
- how is data restored if corruption occurs

This is where architecture intersects directly with delivery safety.

## Example: Cloud Platform Change

Imagine moving a workload from one hosting model to another.

Documentation should cover:

- what systems are affected
- what new risks are introduced
- what dependencies must move with it
- what rollback trigger would stop the change
- how the team restores service if the new platform fails unexpectedly

## What Interviewers Like To Hear

Strong phrases in documentation answers often sound like:

- `I would capture the decision in an ADR so the reasoning is preserved.`
- `I would identify upstream and downstream impact before rollout.`
- `I would define rollback triggers and sequence ahead of the deployment.`
- `I would confirm RTO and RPO expectations as part of the recovery plan.`

## Quick Study Prompts

- What belongs in an ADR
- How is impact analysis different from risk assessment
- Why is rollback planning different from disaster recovery
- What architectural changes are hardest to reverse
- Why is documentation a design quality issue, not just a project management issue
