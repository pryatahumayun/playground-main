# Real-Time Systems

Real-time systems are systems where timing matters as much as functional correctness.

## Why They Matter

In some environments, being correct too late is still a failure.

## Key Ideas

- deterministic behavior
- bounded latency
- priority handling
- timing constraints
- predictable recovery behavior

## Soft vs Hard Real-Time

### Soft Real-Time

Late responses are bad, but not always catastrophic.

Example:

- delayed dashboard updates

### Hard Real-Time

Missing the timing requirement is a system failure.

Example:

- safety control response beyond allowed timing limit

## Example

A real-time telemetry system may need:

- low-latency processing
- controlled message paths
- predictable failure handling
- minimal jitter

## Interview Phrases

- `In a real-time context, timing is part of the requirement, not just a performance optimization.`
- `I would avoid designs with unpredictable latency if the workflow is time sensitive.`
- `Real-time requirements change which tradeoffs are acceptable.`
