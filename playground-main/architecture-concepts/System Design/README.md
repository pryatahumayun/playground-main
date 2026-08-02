# System Design

System design topics describe how applications behave at runtime, how they scale, and how they manage data, traffic, and failure.

## Topics

- [Load Balancing](./Load%20Balancing/README.md)
- [Caching](./Caching/README.md)
- [Queues](./Queues/README.md)
- [Event-Driven Architecture](./Event-Driven%20Architecture/README.md)
- [Synchronous vs Asynchronous](./Synchronous%20vs%20Asynchronous/README.md)
- [Microservices](./Microservices/README.md)
- [Monoliths](./Monoliths/README.md)
- [APIs](./APIs/README.md)
- [Database Design](./Database%20Design/README.md)
- [CAP Theorem](./CAP%20Theorem/README.md)

## Why System Design Matters

System design is where architectural thinking becomes operational.

It answers questions like:

- how requests move through the system
- where bottlenecks show up
- how failures are isolated
- how traffic spikes are handled
- how data is stored and served efficiently

## Example: Design a URL Shortener

If someone asks for a URL shortener design, you might discuss:

- an API to create and resolve short links
- a database for short code to long URL mapping
- caching hot lookups for frequently visited links
- load balancing across API instances
- analytics processing through asynchronous events

That one example uses several system design topics together.

## Example: Image Upload Service

A practical design might look like this:

- client uploads through an API
- file is stored in object storage
- metadata goes into a database
- a queue triggers background processing
- workers generate thumbnails asynchronously
- CDN serves the final images efficiently

Topics involved:

- APIs
- synchronous vs asynchronous communication
- queues
- caching or CDN strategy
- database design

## Example: High-Traffic Product Catalog

Suppose a shopping site gets huge read traffic.

A stronger system design answer might include:

- load balancer in front of stateless app servers
- caching for product data
- read replicas if relational storage is used
- asynchronous processing for non-critical updates
- monitoring for cache hit rates and DB latency

This is the kind of answer that shows layered thinking.

## Example: Notification Workflow

A user places an order and should receive:

- email confirmation
- SMS update
- internal analytics event

A good design might use:

- synchronous API for the order placement itself
- event publication after the order is saved
- separate consumers for email, SMS, and analytics

That demonstrates event-driven architecture and loose coupling in a system design context.

## What Interviewers Like To Hear

Strong phrases in system design answers often sound like:

- `I would keep the user-facing request short and push slow work into a queue.`
- `I would add caching only where the read pattern justifies the complexity.`
- `I would keep the service stateless so it scales horizontally more easily.`
- `I would check whether the database is the real bottleneck before scaling everything else.`

## Quick Study Prompts

- When would you use a queue instead of direct synchronous processing
- What problem does caching solve, and what problem can it create
- When is a monolith the better answer than microservices
- Why does CAP theorem matter only in distributed systems
- What makes an API design easier for consumers to use safely
