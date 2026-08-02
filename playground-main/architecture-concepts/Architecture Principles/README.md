# Architecture Principles

Architecture principles are the design qualities you use to judge whether a system is healthy. They help you move beyond "it works" into better questions:

- will it scale
- will it survive failure
- will it be easy to change
- is the design too tightly coupled
- is the solution more complex than the problem requires

These principles show up constantly in architecture interviews because they help you explain why one design is stronger than another.

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

## How To Talk About Principles

A strong answer usually explains:

- what the principle means
- why it matters
- what tradeoffs it introduces
- what a bad version looks like
- how it shows up in a real system

That last point matters. Interviewers usually do not want dictionary definitions only. They want to hear how the principle affects actual design choices.

## Why These Principles Matter

A system can technically function and still have poor architecture if it is:

- hard to change
- tightly coupled
- fragile under failure
- difficult to test
- operationally confusing
- more complicated than necessary

Architecture principles are how you name those problems clearly.

## 1. Scalability

### What It Means

Scalability is the ability of a system to handle more load without collapsing in performance or operability.

### What It Is Not

Scalability does not always mean "use microservices" or "add Kubernetes." Sometimes it just means:

- make the service stateless
- put it behind a load balancer
- cache expensive reads
- reduce database pressure

### Example

An e-commerce catalog gets slammed during a holiday sale.

A scalability-focused response might include:

- multiple API instances
- caching product data
- CDN for static assets
- asynchronous processing for non-critical work
- database indexing or read replicas

### Tradeoff

More scalability often means:

- more infrastructure
- more cost
- more complexity

## 2. Availability

### What It Means

Availability is how often the system is reachable and usable when users need it.

### What It Is Not

Availability does not mean the system is always correct. A service can be available and still return bad results.

### Example

If one application node fails and the site stays up because traffic shifts to healthy nodes, that is an availability improvement.

Typical availability design choices include:

- multiple instances
- health checks
- load balancing
- zone redundancy
- controlled deployments

### Tradeoff

Higher availability usually costs more because redundancy costs money and adds operational moving parts.

## 3. Reliability

### What It Means

Reliability is the ability of a system to behave correctly and consistently over time.

### What It Is Not

Reliability is not just uptime.

Example:

- if a payment service stays online but occasionally charges twice, it may be available but not reliable

### Example

An order-processing system uses:

- idempotency keys
- retries with backoff
- dead-letter queues
- durable message storage

That improves reliability because failures are handled more safely and duplicate side effects are reduced.

### Tradeoff

Improving reliability often means more design effort around:

- retries
- state handling
- monitoring
- recovery paths

## 4. Maintainability

### What It Means

Maintainability is how easy a system is to understand, support, test, and change over time.

### What It Is Not

Maintainability is not only "clean code." It also includes:

- system boundaries
- deployment simplicity
- documentation quality
- operational clarity

### Example

A billing service is difficult to update because business rules, database logic, and API formatting are all tangled together.

A more maintainable design would separate:

- business logic
- data access
- interface contracts
- deployment concerns

### Tradeoff

Better maintainability sometimes requires more initial structure and discipline, which can feel slower up front but pays off over time.

## 5. Loose Coupling

### What It Means

Loose coupling means components depend on each other as little as possible.

### What It Is Not

Loose coupling does not mean systems know nothing about each other. They still need contracts. It means the dependency is controlled and stable instead of fragile and invasive.

### Example

A shipping service should not need to understand the internals of the order service database. It should consume a stable API or event contract instead.

That way:

- the order service can evolve internally
- the shipping service is not broken by unrelated internal refactoring

### Tradeoff

Loose coupling often improves change safety, but too much abstraction can make the system harder to trace and debug.

## 6. High Cohesion

### What It Means

High cohesion means related responsibilities belong together.

### What It Is Not

High cohesion does not mean making components huge. It means each component has a focused purpose.

### Example

A service called `OrderService` should mainly own order behavior:

- create order
- update order status
- retrieve order history

If it also manages user authentication, product search, reporting, and email delivery, cohesion is poor.

### Tradeoff

High cohesion usually improves clarity and maintainability, but it requires thoughtful domain boundaries.

## 7. Separation of Concerns

### What It Means

Separation of concerns means splitting responsibilities so different kinds of logic do not become tangled.

### Example Areas

- presentation
- business rules
- persistence
- infrastructure
- security

### Example

If UI code directly writes SQL and embeds business rules, change becomes risky.

A stronger design separates:

- UI handling
- business logic
- repository or data access logic

### Tradeoff

Too little separation creates chaos. Too much layering can create ceremony. The goal is useful boundaries, not boundary theater.

## 8. Modularity

### What It Means

Modularity means building the system out of well-bounded parts that can be understood, tested, and changed with limited side effects.

### What It Is Not

Modularity is not the same as microservices only. A modular monolith can still be highly modular.

### Example

A monolith with clear modules for:

- catalog
- checkout
- payments
- reporting

is often healthier than a set of poorly bounded microservices that constantly depend on each other.

### Tradeoff

Modularity improves flexibility, but weak module boundaries remove most of the benefit.

## 9. Simplicity (KISS)

### What It Means

KISS means "keep it simple." Choose the least complex design that still solves the real problem.

### What It Is Not

Simplicity does not mean being naive or ignoring future needs. It means not introducing complexity before it is justified.

### Example

If a small internal tool has one team and modest traffic, a modular monolith may be far better than:

- microservices
- service mesh
- event-driven choreography everywhere

The simpler system may be easier to build, support, and evolve.

### Tradeoff

Simple systems are easier to understand, but oversimplifying can ignore real requirements. The goal is appropriate simplicity.

## Example: E-Commerce Platform

Imagine an online store with:

- product catalog
- shopping cart
- checkout
- payment processing
- order history

You can use architecture principles to evaluate the design:

- `Scalability`: can the catalog handle heavy read traffic during sales
- `Availability`: does checkout stay up if one instance fails
- `Reliability`: can the order flow avoid duplicate payment charges
- `Maintainability`: can the team change cart logic without breaking checkout
- `Loose Coupling`: can payment logic change without rewriting the whole app
- `High Cohesion`: does the order service focus mainly on order behavior
- `Separation of Concerns`: are UI, business logic, and persistence separated
- `Modularity`: can major features evolve independently
- `Simplicity`: is the design solving the real problem without unnecessary platform complexity

## Example: Monolith vs Microservices

A common interview question is whether a system should stay a monolith or move to microservices.

Architecture principles help you answer:

- if the monolith is still modular and maintainable, it may be the better choice
- if teams are blocked by coupling and release coordination, service separation may help
- if the system is small, simplicity may matter more than independent scaling
- if reliability is harmed by distributed failure modes, decomposition may not yet be worth it

A strong answer might sound like:

`I would not move to microservices just because the app is growing. I would first evaluate maintainability, coupling, team boundaries, deployment friction, and whether there are real scaling or ownership boundaries that justify the extra complexity.`

## Example: API Under Heavy Traffic

Suppose a public API becomes slow during peak usage.

You can frame the problem through principles:

- `Scalability`: do we need horizontal scaling or caching
- `Availability`: do we have enough healthy instances behind a load balancer
- `Reliability`: are retries causing duplicate side effects
- `Maintainability`: is the bottleneck easy to isolate and improve
- `Simplicity`: are we solving it with the least complex option first

That leads naturally into design choices like:

- load balancing
- caching
- queues
- database tuning

## Principles That Work Together

Some principles are often paired:

- `Loose Coupling` and `High Cohesion`
  - good boundaries usually need both
- `Maintainability` and `Simplicity`
  - unnecessary complexity hurts maintainability quickly
- `Availability` and `Reliability`
  - uptime matters, but correctness matters too
- `Modularity` and `Separation of Concerns`
  - both improve clarity, but from slightly different angles

## Common Interview Mistakes

- treating scalability as just "add more servers"
- confusing availability with reliability
- assuming microservices are automatically better architecture
- describing loose coupling without explaining the contract boundary
- using "simple" to mean under-designed

## What Interviewers Like To Hear

Good answers in this section often sound like:

- `This improves maintainability because responsibilities are easier to change safely.`
- `This reduces coupling by keeping consumers dependent on a stable contract rather than internal implementation.`
- `This increases reliability because retries are idempotent and failures are better isolated.`
- `This design is simpler, which matters because the current requirements do not justify a more distributed solution.`
- `This improves cohesion because the service owns one clear business capability instead of several unrelated ones.`

## Quick Study Prompts

Try answering these out loud:

- What is the difference between availability and reliability
- Why are loose coupling and high cohesion often discussed together
- When does simplicity beat flexibility
- What makes a design maintainable over time
- Why is modularity valuable even inside a monolith
- When does scalability pressure justify architectural change
- What is an example of a system that is available but not reliable
