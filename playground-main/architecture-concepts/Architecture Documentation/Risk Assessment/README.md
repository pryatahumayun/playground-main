# Risk Assessment

Risk assessment identifies what can go wrong, how likely it is, how severe the impact would be, and what should be done about it. In architecture conversations, this is how you show that you are not only designing for the happy path.

## What Risk Assessment Is Trying To Answer

- what failure or threat scenarios matter most
- how likely each scenario is
- how damaging each scenario would be
- what controls or mitigations reduce the risk
- what risks are still accepted

## What A Risk Assessment Document Should Include

### 1. Scope

State what system, change, or architecture decision is being assessed.

### 2. Risk List

Document individual risks clearly.

Examples:

- database migration failure
- cross-region failover not tested
- secrets overexposed
- downstream rate limits causing customer impact
- queue growth causing delayed processing

### 3. Probability

Estimate how likely the risk is.

You can use simple labels:

- low
- medium
- high

### 4. Impact

Estimate the severity if the risk happens.

Examples:

- minor inconvenience
- user-facing outage
- data loss
- compliance breach
- financial damage

### 5. Risk Rating

Combine likelihood and impact into an overall view of seriousness.

This helps prioritize action.

### 6. Mitigations

Document what reduces the risk.

Examples:

- backup before migration
- canary rollout
- stronger access control
- retries with idempotency
- monitoring and alerting

### 7. Residual Risk

State what risk still remains after mitigation.

No serious system has zero risk.

### 8. Owner

Assign responsibility for monitoring or mitigating the risk.

### 9. Acceptance or Escalation

If a risk is accepted, document that intentionally.

If it is too large, escalate it rather than quietly carrying it.

## Example: Database Migration Risk Assessment

Possible risks:

- migration script corrupts data
- old application version is incompatible with new schema
- rollback takes too long
- reporting jobs fail on changed schema

Mitigations:

- snapshot before change
- test migration in production-like environment
- backward-compatible release sequence
- clearly defined rollback trigger

## Example: Public API Platform

Possible risks:

- DDoS or traffic spikes
- auth provider outage
- cache stampede
- database bottleneck
- accidental data exposure through weak authorization

That shows risk assessment is not just a security exercise. It covers reliability and operations too.

## Risk Assessment vs Impact Analysis

This is a common confusion.

- `Impact Analysis` asks: what will this change affect
- `Risk Assessment` asks: what could go wrong, how serious is it, and what will we do about it

Both are important, but they answer different questions.

## What Interviewers Like To Hear

Strong phrases for risk assessment answers:

- `I want risks documented with both likelihood and impact, not just a vague list of concerns.`
- `I care about mitigations and residual risk, not just naming the problem.`
- `Risk acceptance should be explicit because every architecture has tradeoffs.`

## Quick Study Prompts

- Why should residual risk be documented
- What is the difference between a mitigation and a rollback
- Why is ownership important in a risk document
- How do you prioritize architecture risks when there are many
