# Loose Coupling

Loose coupling means components depend on each other as little as possible. The goal is to reduce how much one part of the system must know about another part's internal design.

## What Loose Coupling Is Really About

Loose coupling asks:

- can one component change without breaking everything else
- do components depend on stable contracts or fragile assumptions
- can teams deploy or evolve parts independently

## What Tight Coupling Looks Like

- one service reads another service's database directly
- one component assumes internal implementation details of another
- many systems break when one schema changes
- every release requires many teams to coordinate

## Example: Payment Service

Weak design:

- the checkout service writes directly into the payment database

Better design:

- checkout sends a request through a stable API or event contract

Why it is better:

- payment internals can change without forcing checkout to change
- ownership is clearer
- testing and troubleshooting boundaries are cleaner

## APIs and Events as Boundaries

Common loose-coupling mechanisms include:

- REST APIs
- gRPC contracts
- message queues
- events

The point is not just "use APIs." The point is to depend on a deliberate contract instead of hidden internal behavior.

## Tradeoffs

Loose coupling improves change safety and flexibility, but:

- more boundaries can increase operational complexity
- async models can introduce eventual consistency
- too much abstraction can make the system hard to reason about

## What Interviewers Like To Hear

- `I want consumers to depend on a stable contract, not internal implementation details.`
- `Loose coupling improves independent change and reduces blast radius.`
- `Events can reduce direct dependency, but they also introduce traceability and consistency considerations.`

## Quick Study Prompts

- What is an example of tight coupling
- Why is direct database sharing often a bad coupling sign
- How do APIs and events support loose coupling
- What complexity can loose coupling introduce
