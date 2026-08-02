# Requirements Engineering

Requirements engineering is the discipline of discovering, analyzing, documenting, validating, and managing requirements.

## Why It Matters

A bad solution often starts with unclear requirements, not bad implementation.

Strong requirements work helps answer:

- what problem are we solving
- who needs the capability
- what constraints must be respected
- how will we know the solution is successful

## Types of Requirements

### Functional Requirements

These describe what the system must do.

Examples:

- the system shall allow a user to submit a flight plan
- the API shall return current weather data
- the platform shall generate an alert on failed login attempts

### Non-Functional Requirements

These describe qualities or constraints of the system.

Examples:

- response time must be under 300 ms
- data must be encrypted in transit
- the service must support 5,000 concurrent users
- uptime must be 99.95 percent

### Constraints

Constraints limit the design space.

Examples:

- must run in a specific cloud
- must integrate with an existing database
- must meet regulatory controls
- must support bilingual operations

### Assumptions

Assumptions are conditions believed to be true for the design to work.

Example:

- identity provider will remain the enterprise standard

## What A Good Requirements Document Should Include

- business objective
- stakeholders
- scope
- functional requirements
- non-functional requirements
- assumptions
- constraints
- dependencies
- acceptance criteria
- traceability to business needs

## Traceability

Traceability means connecting requirements to:

- business goals
- design decisions
- test cases
- implementation work items

This matters because it helps prove that the solution actually satisfies the original need.

## Example

Weak requirement:

- system should be fast

Better requirement:

- the search API shall return results within 2 seconds for 95 percent of requests under expected peak load

The second version is testable and measurable.

## Interview Phrases

- `I would separate functional requirements from non-functional requirements early.`
- `I want acceptance criteria that are measurable, not vague.`
- `I would document assumptions and constraints because they directly affect architecture choices.`
