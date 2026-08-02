# Reliability

Reliability is the ability of a system to behave correctly and consistently over time, even when parts fail. A reliable system does not just stay online. It produces the expected outcome in a dependable way.

## What Reliability Is Really About

Reliability asks:

- does the system produce correct results
- does it handle failure safely
- does it avoid duplicate or inconsistent outcomes
- can it recover predictably

## Reliability vs Availability

This is one of the most important distinctions to understand.

- availability: system is reachable
- reliability: system behaves correctly

Example:

- a payments API that is online but occasionally charges twice has an availability success and a reliability failure

## Reliability Techniques

- idempotency
- retries with backoff
- circuit breakers
- dead-letter queues
- durable messaging
- transaction boundaries
- fallback behavior
- observability and alerting

## Example: Order Processing

An order system sends a payment request, gets a timeout, and retries. If the payment was actually processed the first time, the retry could double-charge the user.

A more reliable design would include:

- idempotency keys
- transaction and state tracking
- safe retry rules
- monitoring for duplicate effects

This is a classic reliability example because the system is not failing loudly. It is failing subtly.

## Example: Background Jobs

A queue consumer crashes while processing a message.

A reliable system considers:

- was the message acknowledged too early
- can the work be retried safely
- where do poison messages go
- how is stuck work detected

## Partial Failure Mindset

Reliable systems assume partial failure is normal.

Examples:

- downstream service is slow
- one consumer instance crashes
- one network call times out
- one cache node becomes unavailable

A reliable design does not panic when one component misbehaves. It contains the damage.

## Tradeoffs

Improving reliability often adds:

- more complexity in workflows
- more state handling
- stronger observability requirements
- additional infrastructure for safe retries and recovery

## What Interviewers Like To Hear

- `I would design retries carefully because retries without idempotency can create worse failures.`
- `Reliable systems assume partial failure and isolate it.`
- `A system can be available but still unreliable if it returns bad or inconsistent results.`
- `Observability is part of reliability because you cannot trust what you cannot detect.`

## Quick Study Prompts

- Why is idempotency important for reliability
- How can retries make a system less reliable
- What is an example of availability without reliability
- Why are queues often part of reliability discussions
