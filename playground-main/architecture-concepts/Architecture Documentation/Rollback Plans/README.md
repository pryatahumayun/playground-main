# Rollback Plans

Rollback plans explain how to safely reverse a deployment or change when things go wrong. A rollback plan is one of the most practical architecture and delivery documents because it forces the team to think through failure before production is under pressure.

## What A Rollback Plan Is Trying To Answer

- what conditions should trigger rollback
- what exact version or state we are rolling back to
- what steps happen, and in what order
- whether data changes are reversible
- how we validate that rollback succeeded
- who approves and executes the rollback

## When A Rollback Plan Is Needed

You should have a rollback plan for changes such as:

- application releases
- infrastructure changes
- schema migrations
- security policy changes
- network or routing changes
- identity and access model changes

The bigger the blast radius, the more detailed the rollback plan should be.

## What A Rollback Plan Document Should Include

### 1. Change Summary

Describe:

- what is changing
- why it is changing
- when it is being deployed
- what environments are affected

### 2. Rollback Trigger Conditions

Be explicit about what should cause rollback.

Examples:

- error rate above threshold
- failed health checks
- latency spike above agreed limit
- authentication failures
- database migration partial failure
- customer-facing workflow broken

### 3. Rollback Target State

Document what "back" means.

Examples:

- previous application version
- previous infrastructure template version
- prior feature flag state
- restored routing rule

If the team cannot define the rollback target clearly, rollback gets dangerous.

### 4. Preconditions

Explain what must already exist to make rollback possible.

Examples:

- previous container image still stored
- previous Helm or manifest version available
- infrastructure template version tagged in source control
- database backup or snapshot completed
- feature flags available

### 5. Step-by-Step Rollback Procedure

List the exact steps in order.

Example:

1. pause rollout
2. disable traffic to new version if needed
3. redeploy previous stable application image
4. restore previous configuration or secrets if changed
5. verify database compatibility
6. re-run health checks
7. confirm user-facing flows
8. reopen traffic fully

### 6. Database Considerations

This is one of the most important sections.

Ask:

- was the schema changed
- is the change backward compatible
- can data be safely downgraded
- do we need a restore instead of a simple deployment rollback

Application rollback is often easy. Data rollback is often not.

### 7. Validation Steps

Document how to confirm rollback success.

Examples:

- health endpoint checks
- synthetic user tests
- login test
- checkout or payment test
- queue processing validation
- monitoring dashboards back to normal

### 8. Roles and Ownership

Document:

- who executes rollback
- who approves it
- who monitors impact
- who communicates status

### 9. Communication Plan

Include:

- who gets notified
- who gives final go/no-go
- how progress is shared during rollback

### 10. Known Limitations

Examples:

- some in-flight transactions may need manual reconciliation
- rollback may restore application version but not user session state
- feature flag rollback may not reverse database changes

## Example: Application Release Rollback

Suppose version `v2` of an API introduces a bug that causes 500 errors.

A rollback plan might include:

- trigger: 500 error rate over 5 percent for 10 minutes
- target: redeploy `v1.9.3`
- steps:
  - stop rollout
  - shift traffic back to stable instances
  - redeploy previous image
  - validate health and key endpoints
- communication:
  - notify support and incident channel
  - confirm when rollback completes

## Example: Schema Migration Rollback

Suppose a deployment adds a breaking database change.

The rollback plan should answer:

- is the new app version backward compatible with the old schema
- can the schema be reversed safely
- do we need snapshot restore
- how long does restore take
- what data may be lost

This is why teams often prefer backward-compatible migrations first, then cleanup later.

## Rollback vs Fix Forward

Sometimes rollback is not the best option.

Examples where fix forward may be better:

- irreversible schema changes
- urgent security patch that should not be removed
- minor issue with a fast, low-risk fix

A mature team knows when rollback is correct and when fix forward is safer.

## What Interviewers Like To Hear

Strong phrases for rollback answers:

- `I want rollback triggers defined before deployment starts.`
- `I treat database rollback separately because data changes are the risky part.`
- `I need a clear previous known-good target, not just a vague idea of going back.`
- `I would validate rollback with real user-path checks, not just infrastructure health.`

## Quick Study Prompts

- What should trigger rollback
- Why is database rollback harder than application rollback
- What information is needed before a rollback is possible
- When might fix forward be better than rollback
- Why should validation be part of the rollback document
