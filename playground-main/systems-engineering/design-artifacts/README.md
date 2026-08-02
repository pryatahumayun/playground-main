# Design Artifacts

Design artifacts are the diagrams and structured documents that communicate how a system works.

## Why They Matter

Interviewers often care whether you know how to express architecture clearly, not just think about it in your head.

## Common Design Artifacts

### Context Diagram

Shows the system and its external actors or systems.

Use it to explain boundaries quickly.

### Container or Component Diagram

Shows the main internal building blocks and how they interact.

### Sequence Diagram

Shows step-by-step interaction over time.

Good for:

- request flows
- integrations
- failure scenarios

### State Diagram

Shows how an object or process changes state.

Good for:

- order lifecycle
- workflow states
- approval processes

### Deployment Diagram

Shows where software runs.

Examples:

- containers
- VMs
- Kubernetes clusters
- cloud services

### Data Flow Diagram

Shows how data moves through the system.

## Example

If someone asks how a booking system works, you might use:

- context diagram for external systems
- sequence diagram for booking flow
- deployment diagram for cloud hosting
- data flow diagram for transaction and notification movement

## Interview Phrases

- `I would start with a context diagram to establish system boundaries.`
- `A sequence diagram is useful when the question is really about interaction flow or integration timing.`
- `I want the artifact to match the question instead of drawing everything at once.`
