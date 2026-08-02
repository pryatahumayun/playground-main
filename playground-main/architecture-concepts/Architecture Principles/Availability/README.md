# Availability

Availability is the percentage of time a system is usable and reachable when it is needed. In architecture conversations, availability is about minimizing downtime and designing the system so failures do not immediately take the whole service offline.

## What Availability Is Really About

Availability asks:

- can users still reach the system
- can the system still serve requests
- can it survive failures without total outage

This usually depends on redundancy, failover behavior, and removal of single points of failure.

## Availability vs Reliability

Availability and reliability are related but not the same.

- availability asks whether the system is up
- reliability asks whether it behaves correctly and consistently

Example:

- a service that returns responses quickly but sometimes gives wrong results may be available but not reliable

## Common Availability Techniques

- multiple app instances
- load balancers
- health probes
- zone redundancy
- failover routing
- graceful degradation
- rolling deployments
- maintenance windows and traffic control

## Single Points of Failure

A single point of failure is any component whose failure takes down the whole system.

Examples:

- one application server
- one database instance without failover
- one region for a critical service
- one identity provider path without contingency

Removing single points of failure is one of the most direct ways to improve availability.

## Example: Web API

A public API runs on one server.

Availability risk:

- server crash means total outage

Better design:

- deploy multiple instances
- place them behind a load balancer
- use health checks so unhealthy nodes stop receiving traffic

## Example: Planned Deployment

Availability is affected by deployments too.

If a release requires shutting down the only running instance, the system becomes unavailable.

A better approach might use:

- rolling deployment
- blue-green deployment
- canary rollout

This is a good interview point because availability is not only about unplanned failure.

## Graceful Degradation

Sometimes the best availability decision is not full functionality. It is partial service instead of total outage.

Example:

- product search stays up
- recommendations are temporarily disabled
- checkout remains functional

This keeps critical business flows alive while a non-critical subsystem is impaired.

## Tradeoffs

Higher availability often means:

- more redundancy
- higher cost
- more architecture complexity
- more failure-mode testing

You are usually buying resilience with additional infrastructure and operational discipline.

## What Interviewers Like To Hear

- `I would remove single points of failure first.`
- `Multiple instances are not enough by themselves; they need health checks and proper traffic routing.`
- `Availability includes deployment strategy, not just runtime design.`
- `In some cases graceful degradation is better than an all-or-nothing service model.`

## Quick Study Prompts

- What is a single point of failure
- Why is a load balancer important for availability
- How do rolling deployments help availability
- What is graceful degradation
