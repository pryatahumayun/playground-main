# Simplicity (KISS)

KISS means "keep it simple." In architecture, it means choosing the least complex design that still satisfies the real requirements.

## What Simplicity Is Really About

Simplicity asks:

- are we solving the actual problem
- are we introducing complexity too early
- can the team understand, operate, and change this design

Simple architecture is usually easier to:

- explain
- build
- support
- debug
- evolve

## What Simplicity Is Not

Simplicity does not mean:

- ignore future needs
- avoid all structure
- choose naive solutions

It means complexity should be earned by real requirements, not imagination or trend-following.

## Example: Small Internal Tool

Suppose a small internal workflow tool has:

- one team
- modest traffic
- limited integration needs

A simple and strong design may be:

- modular monolith
- relational database
- straightforward REST API
- basic CI/CD

That may be much better than jumping immediately to:

- microservices
- event choreography
- service mesh
- multiple data stores

## Example: Premature Complexity

Sometimes teams build for scale they may never reach.

Example:

- introducing a queue, event bus, and five services for an app with ten users and one team

That may reduce simplicity without delivering real value.

## Why Simplicity Matters

Simplicity improves:

- maintainability
- onboarding
- operational clarity
- delivery speed
- reliability, because fewer moving parts often means fewer failure paths

## Tradeoffs

Simplicity is not always enough if the requirements are truly complex.

Examples where more complexity may be justified:

- strict scaling demands
- high availability requirements
- complex domain boundaries
- many teams needing independence

The point is not to reject complexity forever. It is to introduce it only when justified.

## What Interviewers Like To Hear

- `I would choose the least complex design that meets the requirements.`
- `I do not want to pay distributed-systems complexity unless the problem really requires it.`
- `Simple designs are often easier to maintain, debug, and operate.`
- `If requirements change later, I can evolve the design incrementally.`

## Quick Study Prompts

- Why is simplicity an architecture strength
- When does a simple design stop being enough
- What is an example of premature complexity
- Why does simplicity often improve reliability and maintainability
