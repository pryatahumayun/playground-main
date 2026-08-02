# Case Studies

This section is for practicing how architecture concepts apply in realistic scenarios.

## Suggested Scenarios

- scaling a read-heavy public API
- migrating a monolith into clearer modules
- designing an event-driven order workflow
- securing a cloud-native application
- improving reliability for a payment or booking system

## How To Answer

For each case study, try to explain:

- requirements
- constraints
- architecture choice
- tradeoffs
- risks
- rollout and rollback approach

## Example Case Study 1: Scale a Read-Heavy Public API

Scenario:

- a product catalog API is getting heavy read traffic
- latency is rising during peak usage
- writes are much less frequent than reads

A strong answer might include:

- stateless API instances behind a load balancer
- caching hot product data
- database indexing review
- read replicas if the relational database is the bottleneck
- monitoring for cache hit ratio and query latency

Tradeoffs to mention:

- caching improves speed but risks stale data
- replicas improve read scale but add complexity

## Example Case Study 2: Break Apart a Growing Monolith

Scenario:

- one application handles orders, payments, customer accounts, and reporting
- multiple teams are changing the same codebase
- releases are getting slower and riskier

A strong answer might include:

- first improve modularity inside the monolith
- identify real domain boundaries
- split the highest-friction area only when the boundary is clear
- introduce APIs or events between domains gradually

Tradeoffs to mention:

- microservices improve independence but add distributed systems complexity
- a modular monolith may solve the current problem with less overhead

## Example Case Study 3: Event-Driven Order Workflow

Scenario:

- placing an order should trigger payment, email, inventory update, and analytics

A strong answer might include:

- synchronous API call to create the order
- event publication after the order is persisted
- separate consumers for payment confirmation, email, inventory, and analytics
- idempotency and retries for each consumer

Tradeoffs to mention:

- better decoupling and scalability
- eventual consistency instead of immediate completion for every downstream action

## Example Case Study 4: Secure a Cloud-Native Application

Scenario:

- a public web app calls APIs, stores files, and uses a database

A strong answer might include:

- centralized authentication
- role-based authorization
- managed identity for service-to-service access
- encryption at rest and TLS in transit
- least privilege for workloads
- monitoring and audit logs

Tradeoffs to mention:

- stronger controls may add operational setup and governance overhead
- some convenience is intentionally sacrificed for lower risk

## Example Case Study 5: Improve Reliability for a Booking System

Scenario:

- users sometimes receive duplicate confirmations
- retries cause occasional double-booking risk
- the system must recover cleanly from transient failures

A strong answer might include:

- idempotency keys
- stronger transaction boundaries
- queue-based background notifications
- better monitoring and alerting
- rollback planning for release changes

Tradeoffs to mention:

- more reliability controls can make workflows more complex
- stronger consistency often comes with throughput or design constraints

## How To Practice

For each case study:

1. Say the requirements out loud.
2. Name the main risks.
3. Propose a simple design first.
4. Add scale, reliability, and security considerations.
5. End with tradeoffs and operational concerns.

That structure helps your answers sound calm and senior instead of scattered.
