# Systems Integration

Systems integration is about how separate systems, subsystems, services, or components work together as one solution.

## Why It Matters

Many failures happen at the seams between systems, not inside one component.

Integration thinking asks:

- what systems exchange data
- what format or protocol they use
- how failures are handled
- what assumptions each side makes

## Common Integration Concerns

- API contracts
- event schemas
- file exchange formats
- protocol compatibility
- timing and latency
- authentication and trust
- retries and duplicate handling
- dependency sequencing

## Interface Documentation

Useful interface information includes:

- source system
- target system
- protocol
- payload format
- auth method
- frequency
- error handling behavior
- expected SLA or latency

## Example

An order service sends completed orders to:

- billing
- warehouse
- analytics

A strong integration plan would define:

- sync vs async communication
- schema versioning
- retry policy
- DLQ or replay strategy
- ownership of the interface

## Interview Phrases

- `I would document the interface contract and failure handling explicitly.`
- `Integration risk usually lives in the assumptions between systems.`
- `I would identify upstream and downstream dependency impact before making contract changes.`
