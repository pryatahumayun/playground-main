# Architecture Principles

These are the design qualities interviewers usually expect you to recognize and explain clearly.

## Topics

- [Scalability](./Scalability/README.md)
- [Availability](./Availability/README.md)
- [Reliability](./Reliability/README.md)
- [Maintainability](./Maintainability/README.md)
- [Loose Coupling](./Loose%20Coupling/README.md)
- [High Cohesion](./High%20Cohesion/README.md)
- [Separation of Concerns](./Separation%20of%20Concerns/README.md)
- [Modularity](./Modularity/README.md)
- [Simplicity (KISS)](./Simplicity%20(KISS)/README.md)

## Interview Angle

A strong answer usually explains:

- what the principle means
- why it matters
- what tradeoffs it introduces
- how it shows up in a real system

## Why These Principles Matter

Architecture principles help you judge whether a design is healthy, not just whether it works today.

A system can technically function and still have poor architecture if it is:

- hard to change
- tightly coupled
- fragile under failure
- overly complex for the problem

These principles are what let you explain that difference.

## Example: E-Commerce Platform

Imagine an online store with:

- product catalog
- shopping cart
- checkout
- payment processing
- order history

You can use architecture principles to evaluate the design:

- `Scalability`: can the catalog handle heavy read traffic during sales
- `Availability`: does checkout stay up if one app instance fails
- `Reliability`: can the order flow avoid duplicate payment charges
- `Maintainability`: can the team change cart logic without breaking checkout
- `Loose Coupling`: can payment logic change without rewriting the whole app
- `High Cohesion`: does the order service focus only on order behavior
- `Separation of Concerns`: are UI, business logic, and data access clearly separated
- `Modularity`: can major features evolve independently
- `Simplicity`: is the design solving the real problem without unnecessary complexity

That is a strong way to show that principles are practical, not abstract.

## Example: Monolith vs Microservices

A common interview question is whether a system should stay a monolith or move to microservices.

Architecture principles help you answer:

- if the monolith is still modular and maintainable, it may be the better choice
- if teams are blocked by coupling and release coordination, service separation may help
- if the system is small, simplicity may matter more than independent scaling

A strong answer might sound like:

`I would not move to microservices just because the app is growing. I would first evaluate maintainability, coupling, deployment friction, and whether there are real scaling boundaries that justify the extra complexity.`

## Example: API Under Heavy Traffic

Suppose a public API becomes slow during peak usage.

You can frame the problem through principles:

- `Scalability`: do we need horizontal scaling
- `Availability`: do we have enough healthy instances behind a load balancer
- `Reliability`: are retries causing bad side effects
- `Simplicity`: are we solving it with the least complex option first

That leads naturally into design choices like load balancing, caching, and queues.

## What Interviewers Like To Hear

Good answers in this section often sound like:

- `This improves maintainability because responsibilities are easier to change safely.`
- `This reduces coupling by keeping consumers dependent on a stable contract rather than internal implementation.`
- `This increases reliability because retries are idempotent and failures are better isolated.`
- `This design is simpler, which matters because the current requirements do not justify a more distributed solution.`

## Quick Study Prompts

Try answering these out loud:

- What is the difference between availability and reliability
- Why are loose coupling and high cohesion often discussed together
- When does simplicity beat flexibility
- What makes a design maintainable over time
- Why is modularity valuable even inside a monolith
