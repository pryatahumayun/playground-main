# Scalability

Scalability is a system's ability to handle more load without collapsing in performance, stability, or operability. It answers the question: if demand grows, can the system grow with it in a controlled way.

## What Scalability Is Really About

Scalability is not only about traffic volume. A system may need to scale for:

- more users
- more requests per second
- more data
- more background jobs
- more teams changing the system

That last one matters too. Sometimes architecture needs to scale organizationally, not just technically.

## Types of Scaling

### Vertical Scaling

Vertical scaling means making one machine or node more powerful.

Examples:

- more CPU
- more memory
- larger database instance

Pros:

- simple to understand
- often fast to apply initially

Cons:

- there is always a ceiling
- large instances can get expensive
- one big node can still be a single point of failure

### Horizontal Scaling

Horizontal scaling means adding more nodes or instances.

Examples:

- more API instances
- more worker nodes
- more message consumers

Pros:

- usually better for high growth
- supports better availability
- often fits cloud-native systems well

Cons:

- requires better coordination
- stateful services are harder to scale horizontally
- load balancing and consistency become important

## Stateless vs Stateful

Stateless services usually scale more easily because any instance can handle any request.

Examples:

- public APIs
- frontend web applications
- background workers that pull from a queue

Stateful components are harder to scale because data or session ownership matters.

Examples:

- relational databases
- in-memory session stores
- systems with strong transaction requirements

## Common Scalability Techniques

- load balancing
- caching
- CDN usage
- queues for burst smoothing
- asynchronous processing
- partitioning or sharding
- read replicas
- database tuning and indexing

## Example: Product Catalog

An online store gets huge read traffic during a sale.

A scalability-aware design might include:

- multiple API instances behind a load balancer
- caching popular product data
- CDN for images and static content
- separate background processing for recommendation updates
- read replicas or optimized indexing for product queries

This is stronger than simply saying "we will scale it."

## Example: File Processing System

A file upload API becomes slow because every uploaded file is scanned and transformed in the request path.

A better design might:

- keep the upload API fast
- store the file immediately
- push processing into a queue
- scale workers independently

That is a classic scalability improvement because it separates user-facing responsiveness from heavier background work.

## What Scalability Is Not

Scalability does not automatically mean:

- use microservices
- use Kubernetes
- move everything to NoSQL
- use the most distributed design possible

Sometimes the right scaling answer is:

- better indexes
- caching
- removing a synchronous bottleneck
- fixing a poor query

## Common Bottlenecks

When people say "the system does not scale," the real bottleneck is often one of these:

- database writes
- expensive reads
- synchronous downstream dependencies
- shared session state
- large payloads
- CPU-heavy business logic
- single-threaded processing

## Tradeoffs

Better scalability often comes with:

- more infrastructure cost
- more moving parts
- more operational complexity
- more observability requirements
- more consistency tradeoffs in distributed systems

## What Interviewers Like To Hear

- `I would identify the actual bottleneck before choosing a scaling pattern.`
- `Stateless services usually scale horizontally more easily than stateful ones.`
- `Queues and asynchronous processing help when the issue is burst smoothing, not just raw compute.`
- `Scaling the application layer is often easier than scaling the database layer.`

## Quick Study Prompts

- What is the difference between vertical and horizontal scaling
- Why do stateless services scale more easily
- When is a queue a scalability tool
- Why is the database often the hardest layer to scale
