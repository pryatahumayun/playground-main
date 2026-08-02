# Monoliths

A monolith keeps the application in one deployable unit. That does not automatically make it a bad design.

## What Monoliths Are Really About

Monoliths often make sense when:

- one team owns the system
- domain boundaries are still forming
- operational simplicity matters
- scale is still moderate

## Strong Version: Modular Monolith

A modular monolith can still have:

- clear domain boundaries
- clean internal modules
- strong testing
- good maintainability

## Weak Version: Tangled Monolith

Problems arise when:

- everything depends on everything
- change breaks unrelated areas
- releases are risky
- boundaries are unclear

## Example

A business app with:

- user accounts
- reporting
- approvals
- notifications

may be better as a modular monolith than as many tiny services if the team is small and the scale is manageable.

## What Interviewers Like To Hear

- `A monolith is not bad by definition; poor boundaries are the real issue.`
- `Many systems should start as monoliths and evolve only when real pressure justifies decomposition.`
- `A modular monolith is often an excellent middle ground.`

## Quick Study Prompts

- Why can a monolith still be a strong design
- What makes a monolith hard to evolve
- When should a monolith stay a monolith
- What is a modular monolith
