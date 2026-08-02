# Decision Records (ADR)

Architecture Decision Records capture important design choices and the reasoning behind them. They are one of the best ways to preserve architectural context so future engineers understand why a choice was made instead of only seeing the end result.

## What An ADR Is Trying To Answer

- what decision was made
- why it was made
- what alternatives were considered
- what tradeoffs came with the decision
- what consequences should be expected later

## Why ADRs Matter

Without ADRs, teams often forget:

- why one cloud service was chosen over another
- why a monolith was kept instead of splitting to microservices
- why eventual consistency was accepted
- why a certain database or messaging model was adopted

ADRs reduce repeated debates and preserve architecture history.

## What An ADR Document Should Include

### 1. Title

Make the decision easy to identify.

Examples:

- `Use Azure Container Registry for private image storage`
- `Keep billing module inside modular monolith`
- `Adopt event-driven order notifications`

### 2. Status

Common values:

- proposed
- accepted
- superseded
- deprecated

### 3. Context

Explain the problem or pressure that led to the decision.

Examples:

- scaling issue
- deployment complexity
- compliance requirement
- platform standardization

### 4. Decision

State clearly what was chosen.

Do not bury this in paragraphs.

### 5. Alternatives Considered

List realistic alternatives and why they were not selected.

Examples:

- Azure SQL vs Cosmos DB
- monolith vs microservices
- synchronous API calls vs async events

### 6. Rationale

Explain why the chosen option fit the requirements best.

This is the heart of the ADR.

### 7. Consequences

List expected outcomes, good and bad.

Examples:

- easier deployment
- stronger consistency
- more operational complexity
- higher cost

### 8. Follow-Up Actions

Document what still needs to happen.

Examples:

- create monitoring
- define rollback plan
- train team on new platform
- update diagrams or runbooks

## Example ADR

Title:

`Adopt queue-based background processing for image transformations`

Context:

- synchronous image processing is causing slow uploads and request timeouts

Decision:

- move thumbnail generation to background workers triggered by a queue

Alternatives:

- keep processing inline
- use scheduled batch processing

Rationale:

- improves responsiveness for users
- isolates processing spikes
- scales workers independently

Consequences:

- introduces eventual completion
- requires queue monitoring and retry handling

That is the kind of short, useful ADR that teams can actually maintain.

## When To Write An ADR

Write an ADR when the decision is:

- architecture significant
- likely to affect many people
- hard to reverse later
- likely to be questioned in the future

Do not write ADRs for every tiny implementation detail.

## What Interviewers Like To Hear

Strong phrases for ADR answers:

- `I use ADRs to preserve the reasoning behind important technical choices.`
- `I want the document to include alternatives and consequences, not just the final answer.`
- `If the decision gets replaced later, I mark the old ADR as superseded rather than deleting history.`

## Quick Study Prompts

- What makes a decision important enough for an ADR
- Why should alternatives be documented
- Why are consequences as important as rationale
- How do ADRs help future teams
