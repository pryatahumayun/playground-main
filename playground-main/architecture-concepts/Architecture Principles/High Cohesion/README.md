# High Cohesion

High cohesion means related responsibilities stay together inside the same module, class, or service. A cohesive component has a focused purpose instead of trying to do many unrelated things.

## What High Cohesion Is Really About

High cohesion asks:

- does this component own one clear capability
- do its responsibilities belong together naturally
- does its internal behavior make conceptual sense as one unit

## What Poor Cohesion Looks Like

- a service owns unrelated business processes
- one class handles validation, persistence, formatting, and notification
- a module becomes the dumping ground for miscellaneous logic

Poor cohesion usually creates confusion and makes testing harder.

## Example: Order Service

A cohesive order service might:

- create orders
- retrieve orders
- update order state
- enforce order rules

Poor cohesion would look like that same service also:

- sends marketing emails
- manages user login
- calculates unrelated reporting dashboards

## Why Cohesion Matters

High cohesion usually improves:

- maintainability
- readability
- testability
- ownership clarity

It becomes easier to understand what a component is for and what kinds of changes belong there.

## Cohesion and Coupling Together

High cohesion and loose coupling are often discussed together because they reinforce each other.

Good design often looks like:

- each component has one focused purpose
- components interact through clean boundaries

## Tradeoffs

High cohesion requires thoughtful boundaries. If you split responsibilities too aggressively, you can end up with many tiny pieces that are awkward to manage. The goal is focus, not fragmentation.

## What Interviewers Like To Hear

- `A cohesive component owns one logical capability well.`
- `When unrelated concerns pile into one service, cohesion drops and change gets riskier.`
- `High cohesion usually makes systems easier to test and reason about.`

## Quick Study Prompts

- What is an example of poor cohesion
- Why are cohesion and maintainability related
- How do high cohesion and loose coupling work together
- When can over-splitting hurt design clarity
