# Impact Analysis

Impact analysis asks what changes when a proposed design or implementation changes. It is about understanding blast radius before rollout so teams are not surprised by downstream breakage, hidden dependencies, or operational side effects.

## What Impact Analysis Is Trying To Answer

- who or what depends on this system now
- what other systems will be affected by the change
- whether the impact is technical, operational, business, or all three
- what teams need to be involved
- what testing and communication are needed

## What An Impact Analysis Document Should Include

### 1. Change Summary

Describe:

- what is changing
- why it is changing
- what environments are affected

### 2. In-Scope Components

List the services, applications, databases, queues, networks, or shared platforms touched by the change.

### 3. Upstream Dependencies

Document what sends traffic, data, or events into the system.

Examples:

- UI applications
- other APIs
- scheduled jobs
- partner integrations

### 4. Downstream Dependencies

Document what relies on the output of the system.

Examples:

- databases
- queues
- analytics platforms
- customer notifications
- reporting systems

### 5. Interface Impact

Ask whether the change affects:

- API contracts
- event schemas
- auth flows
- database schema
- network rules

### 6. Operational Impact

Document effects on:

- monitoring
- logging
- alerting
- deployment process
- support teams

### 7. Business Impact

Explain what user or business capability is affected.

Examples:

- checkout flow
- customer onboarding
- reporting delays
- support operations

### 8. Risk Areas

Highlight the parts most likely to fail or create follow-on issues.

### 9. Mitigations

Document how risk is reduced.

Examples:

- versioned API
- feature flag
- staged rollout
- shadow testing
- additional monitoring

## Example: API Contract Change

Suppose a customer API changes its response shape.

Impact analysis should ask:

- which consumers parse that response today
- whether any mobile apps require backward compatibility
- whether a versioned endpoint is needed
- whether monitoring and support scripts depend on the old format

That is far stronger than saying "the API still works for us."

## Example: Platform Upgrade

Imagine upgrading a Kubernetes ingress controller.

Impact analysis might include:

- workloads using that ingress
- TLS termination behavior
- WAF or routing dependencies
- DNS and load balancer impact
- rollout timing and rollback complexity

## What Interviewers Like To Hear

Strong phrases for impact analysis answers:

- `I want to identify both upstream and downstream dependencies before rollout.`
- `I would check contract, data, and operational impact, not just application code impact.`
- `If a shared service changes, impact analysis becomes essential because blast radius is larger.`

## Quick Study Prompts

- Why is impact analysis different from risk assessment
- What types of dependencies are easiest to miss
- Why does a shared platform change need stronger impact analysis
- How does impact analysis influence rollout strategy
