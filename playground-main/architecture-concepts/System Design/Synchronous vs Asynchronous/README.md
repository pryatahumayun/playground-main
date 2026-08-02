# Synchronous vs Asynchronous

Synchronous communication waits for a direct response. Asynchronous communication lets work continue without waiting for immediate completion.

## Synchronous

### What It Means

The caller sends a request and waits.

```text
Client -> API -> Response
```

### Good For

- immediate validation
- direct user feedback
- short request-response workflows

### Risks

- caller is blocked
- downstream latency affects user experience
- chain failures can cascade

## Asynchronous

### What It Means

The caller submits work and continues while processing happens later.

```text
Client -> API -> Queue/Event -> Worker -> Completion
```

### Good For

- background processing
- heavy or long-running workflows
- burst smoothing
- decoupled integrations

### Risks

- eventual completion
- more operational complexity
- harder tracing

## Example

Synchronous:

- checking login credentials

Asynchronous:

- generating a large export
- image processing
- notification fan-out

## What Interviewers Like To Hear

- `I prefer synchronous communication when the user needs an immediate answer.`
- `I prefer asynchronous patterns when the work is slower, bursty, or integration-heavy.`
- `Many strong systems use a hybrid model instead of treating one style as universally better.`

## Quick Study Prompts

- When should a workflow stay synchronous
- When is async the better answer
- What are the user-experience tradeoffs
- Why do hybrid architectures show up so often
