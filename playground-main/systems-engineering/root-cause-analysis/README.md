# Root Cause Analysis

Root cause analysis is the structured process of finding the underlying reason a problem happened instead of only fixing the visible symptom.

## Why It Matters

In architecture and operations roles, people care whether you can:

- troubleshoot systematically
- separate symptoms from causes
- recommend corrective and preventive actions

## Common Techniques

### 5 Whys

Keep asking why until the underlying cause becomes clear.

### Fishbone Diagram

Break causes into categories such as:

- people
- process
- technology
- environment

### Timeline Review

Reconstruct what happened and in what order.

## Example

Problem:

- reports are delayed every morning

Possible root causes:

- queue backlog
- under-scaled batch workers
- dependency API slowdown
- changed schedule causing overlap

The symptom is delayed reports. The root cause may be one of the underlying system behaviors.

## Interview Phrases

- `I try to separate the observed symptom from the underlying cause.`
- `I want corrective actions for the immediate issue and preventive actions for recurrence.`
- `Structured RCA is important in integrated environments because the first visible failure is often not the root problem.`
