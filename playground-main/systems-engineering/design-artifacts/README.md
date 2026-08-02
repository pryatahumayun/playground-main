# Design Artifacts

Design artifacts are the diagrams and structured documents that communicate how a system works. They are important because architecture is not just about having the right idea. It is also about explaining that idea clearly to engineers, stakeholders, operators, testers, and leadership.

## Why They Matter

Good diagrams help answer questions like:

- what is inside the system boundary
- what external systems are involved
- how requests move through the solution
- where software is deployed
- how components depend on each other
- how a workflow changes state over time

Interviewers often care whether you know how to choose the right diagram for the question instead of drawing everything at once.

## Common Design Artifacts

### Context Diagram

Shows the system as one box and the major users or external systems around it.

Best for:

- defining scope
- showing boundaries
- explaining integrations at a high level

### Container or Component Diagram

Shows the major internal building blocks of the system and how they interact.

Best for:

- explaining service structure
- showing application layers
- showing integration boundaries

### Sequence Diagram

Shows step-by-step interaction over time.

Best for:

- request flows
- integrations
- timing-sensitive behavior
- failure scenarios

### State Diagram

Shows how an object or process changes state.

Best for:

- order lifecycle
- workflow status changes
- approvals
- lifecycle-heavy business processes

### Deployment Diagram

Shows where software runs.

Examples:

- browser
- app server
- VM
- Kubernetes cluster
- database
- cloud services

### Data Flow Diagram

Shows how data moves through the system.

Best for:

- ingestion pipelines
- reporting flows
- integrations
- ETL or analytics scenarios

## UML vs Other Architecture Diagrams

`UML` is a formal modeling family with standard diagram types such as:

- use case diagrams
- class diagrams
- sequence diagrams
- state diagrams
- activity diagrams
- deployment diagrams

Not every architecture conversation needs strict UML. In real work, teams often mix:

- UML-style diagrams
- cloud architecture diagrams
- C4-style diagrams
- simple boxes-and-arrows diagrams

The key is whether the diagram communicates the right thing clearly.

## 1. Context Diagram Example

Use this when someone asks:

`What does the system interact with`

Example: Booking platform

```text
                 +------------------+
                 |  Customer        |
                 +------------------+
                           |
                           v
 +-------------+    +------------------+    +------------------+
 | Payment API |<-->| Booking Platform |<-->| Operations Team  |
 +-------------+    +------------------+    +------------------+
                           |
                           v
                 +------------------+
                 | Notification Svc |
                 +------------------+
```

What this tells you:

- the booking platform is the system of interest
- customers and operations staff use it
- it integrates with payment and notification systems

## 2. Component Diagram Example

Use this when someone asks:

`What are the main parts inside the system`

Example: E-commerce application

```text
+----------------------+
| Web / Mobile Client  |
+----------------------+
           |
           v
+----------------------+
| API Gateway          |
+----------------------+
     |        |       |
     v        v       v
+--------+ +--------+ +--------------+
| Catalog| | Orders | | Auth Service |
+--------+ +--------+ +--------------+
     |        |
     v        v
+--------+ +--------------+
| Cache  | | Order DB     |
+--------+ +--------------+
```

What this tells you:

- clients hit one gateway
- the system is split into focused backend components
- data and cache dependencies are visible

## 3. Sequence Diagram Example

Use this when someone asks:

`Walk me through what happens when a user places an order`

Example:

```text
Customer -> Web App: Submit Order
Web App -> Order API: Create Order
Order API -> Inventory Service: Reserve Items
Inventory Service -> Order API: Reserved
Order API -> Payment Service: Charge Card
Payment Service -> Order API: Success
Order API -> Order DB: Save Order
Order API -> Event Bus: Publish OrderCreated
Order API -> Web App: Order Confirmed
```

Why it is useful:

- it shows call order
- it makes dependencies obvious
- it reveals where failure handling may be needed

## 4. State Diagram Example

Use this when someone asks:

`What lifecycle does this object go through`

Example: Order lifecycle

```text
[Created] -> [Pending Payment] -> [Paid] -> [Shipped] -> [Delivered]
                    |
                    v
               [Cancelled]
```

Why it is useful:

- it shows business state transitions clearly
- it helps identify invalid transitions
- it is useful for rules, workflows, and testing

## 5. Deployment Diagram Example

Use this when someone asks:

`Where does this actually run`

Example: Cloud-hosted application

```text
User Browser
    |
    v
Load Balancer / Ingress
    |
    v
Kubernetes Cluster
  |           |
  v           v
API Pod     Worker Pod
  |
  v
Managed Database
```

Why it is useful:

- it separates logical design from runtime placement
- it helps with networking and ops discussions
- it surfaces scaling and failure boundaries

## 6. Data Flow Diagram Example

Use this when someone asks:

`How does data move through the system`

Example: Telemetry pipeline

```text
Sensors -> Ingestion API -> Queue -> Processing Service -> Database -> Dashboard
```

Why it is useful:

- highlights ingestion, transformation, and storage steps
- makes async boundaries visible
- helps with scale and reliability discussions

## 7. UML Use Case Diagram Example

Use this when someone asks:

`What can different actors do in the system`

Example:

```text
Actor: Customer
- Search Products
- Place Order
- Track Order

Actor: Admin
- Manage Inventory
- Review Orders
- Issue Refund
```

This is less visual than full UML notation, but the idea is the same: show actors and their interactions with the system.

## 8. UML Class Diagram Example

Use this when someone asks:

`What are the key domain objects and their relationships`

Example:

```text
Customer
- customerId
- name

Order
- orderId
- orderDate

OrderItem
- quantity
- price

Relationships:
Customer 1 -> many Orders
Order 1 -> many OrderItems
```

Why it is useful:

- shows data/domain relationships
- helps reason about ownership and cardinality
- useful in object-oriented and data modeling conversations

## 9. UML Activity Diagram Example

Use this when someone asks:

`What are the workflow steps and decision points`

Example: Leave request approval

```text
Start
  |
Submit Request
  |
Manager Review
  |
Is Approved?
 /       \
Yes       No
 |         |
Notify HR  Reject Request
 |
End
```

Why it is useful:

- great for business workflows
- shows decisions clearly
- helpful for process-heavy systems

## Which Diagram To Choose

If the question is:

- `What systems are involved`
  - use a context diagram
- `What are the internal building blocks`
  - use a component diagram
- `What happens step by step`
  - use a sequence diagram
- `What states does this object move through`
  - use a state diagram
- `Where does this run`
  - use a deployment diagram
- `How does data move`
  - use a data flow diagram

## Example: One System, Multiple Diagrams

Imagine a cloud-based order platform.

You could describe it with:

- context diagram: customers, payment provider, notification service
- component diagram: API gateway, order service, payment service, database
- sequence diagram: place order flow
- state diagram: order status lifecycle
- deployment diagram: browser, ingress, Kubernetes, database

That is a strong interview move because it shows you understand that different diagrams answer different questions.

## What Interviewers Like To Hear

- `I would start with a context diagram to establish the boundary, then drill into a sequence or component diagram depending on the question.`
- `I choose the artifact based on what I need to explain, not based on what is most formal.`
- `Sequence diagrams are especially useful when integration timing or failure behavior matters.`
- `Deployment diagrams help separate logical design from runtime hosting.`

## Quick Study Prompts

- What is the difference between a context diagram and a component diagram
- When is a sequence diagram more useful than a class diagram
- Why is a deployment diagram good for cloud architecture discussions
- What kind of question is best answered by a state diagram
- How would you explain one system using more than one diagram type
