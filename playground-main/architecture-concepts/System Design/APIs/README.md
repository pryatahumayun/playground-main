# APIs

APIs are contracts that let systems communicate in a controlled, predictable way.

## What APIs Are Really About

Good APIs create:

- stable integration boundaries
- predictable behavior
- safer reuse

## Common Styles

- REST
- GraphQL
- gRPC

Each has different strengths.

## Good API Design Concerns

- naming consistency
- versioning
- error handling
- authentication
- authorization
- backward compatibility
- payload shape
- idempotency where needed

## Example

An order API should expose a clean contract like:

- create order
- get order
- update order status where allowed

Clients should not need to know internal database details.

## Why APIs Matter Architecturally

APIs are one of the most common coupling boundaries in modern systems.

Weak API design creates:

- fragile integrations
- versioning pain
- security risk
- inconsistent client behavior

## What Interviewers Like To Hear

- `I want APIs to expose stable contracts without leaking internal implementation details.`
- `Backward compatibility and clear versioning matter once consumers depend on the interface.`
- `Authentication and authorization need to be part of API design from the start.`

## Quick Study Prompts

- Why are APIs architectural boundaries
- What makes an API hard to consume safely
- Why is versioning important
- What is the difference between good API design and just exposing endpoints
