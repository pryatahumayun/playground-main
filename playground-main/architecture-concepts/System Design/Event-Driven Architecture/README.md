# Event-Driven Architecture

Event-driven architecture uses events to signal that something happened so other parts of the system can react independently.

## What It Is Really About

Events are useful when:

- multiple consumers need the same signal
- producers should not tightly control every downstream action
- workflows can tolerate eventual consistency

## Simple Diagram

```text
Order Service -> Event Bus -> Email Service
                         -> Inventory Service
                         -> Analytics Service
```

## Example

When an order is created, the order service publishes `OrderCreated`.

Different consumers can then:

- send an email
- reserve inventory
- update analytics

without the order service having to call each one directly.

## Why It Matters

This improves:

- loose coupling
- extensibility
- fan-out processing

## Risks and Design Concerns

- eventual consistency
- replay handling
- schema versioning
- observability across consumers
- duplicate event handling

## What Interviewers Like To Hear

- `Events are useful when I want to decouple producers from multiple downstream consumers.`
- `I would plan for schema evolution and idempotent consumers.`
- `Event-driven design often trades immediacy for flexibility and resilience.`

## Quick Study Prompts

- What is an event-driven system good at
- Why is eventual consistency common here
- Why do consumers need idempotency
- Why is observability harder in event-driven systems
