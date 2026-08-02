# Microservices

Microservices split a system into independently deployable services aligned to business capabilities.

## What Microservices Are Really About

They aim to improve:

- team autonomy
- deployment independence
- scaling by capability
- domain ownership clarity

## What They Are Not

Microservices are not automatically:

- more scalable
- easier to maintain
- more modern in a useful way

They solve some problems and create others.

## Example

A large commerce platform may separate:

- catalog
- orders
- payments
- shipping
- notifications

Each service can evolve independently if the boundaries are real and stable.

## Benefits

- independent scaling
- independent deployments
- clearer domain ownership

## Costs

- distributed tracing needs
- network failure modes
- data consistency challenges
- more deployment and ops complexity

## What Interviewers Like To Hear

- `Microservices make more sense when domain boundaries and team boundaries are both strong enough to justify them.`
- `They trade monolith complexity for distributed-systems complexity.`
- `I would not use microservices by default for a small early-stage system.`

## Quick Study Prompts

- When do microservices make sense
- What new failure modes do they introduce
- Why are good boundaries required
- Why is observability more important in microservices
