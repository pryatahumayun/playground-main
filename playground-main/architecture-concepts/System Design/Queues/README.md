# Queues

Queues decouple producers from consumers and let work be processed asynchronously instead of forcing everything through the request path.

## What Queues Are Really About

Queues help with:

- burst handling
- resilience
- background processing
- workload smoothing

## Simple Diagram

```text
Producer -> Queue -> Consumer Workers
```

## Why They Matter

If producers are faster than consumers, a queue can absorb the spike temporarily instead of breaking the whole system immediately.

## Example: Image Processing

A user uploads an image.

Instead of:

- upload
- transform
- scan
- thumbnail

all in one request, the system can:

- accept upload
- store file
- push processing job to queue
- let workers handle the rest

## Important Design Questions

- is message ordering required
- can work be retried safely
- what happens to poison messages
- how is dead-letter handling done
- how is queue lag monitored

## Tradeoff

Queues improve resilience and scalability, but they also introduce eventual completion instead of immediate completion.

## What Interviewers Like To Hear

- `Queues are useful when work does not need to be completed in the user request path.`
- `I would think about retry behavior, duplicate handling, and DLQ design.`
- `Queues smooth bursts, but they do not eliminate downstream limits by themselves.`

## Quick Study Prompts

- Why do queues help with bursty traffic
- What is a dead-letter queue
- Why does idempotency matter with queues
- When is a queue a bad fit
