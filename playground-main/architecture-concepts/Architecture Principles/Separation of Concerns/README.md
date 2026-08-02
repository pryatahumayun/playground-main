# Separation of Concerns

Separation of concerns means dividing a system so each part focuses on a distinct kind of responsibility. The idea is to keep different types of logic from becoming tangled together.

## What Separation of Concerns Is Really About

This principle asks:

- are different responsibilities clearly separated
- can we change one concern without rewriting another
- are we mixing presentation, business, and infrastructure logic carelessly

## Common Concern Areas

- user interface
- business rules
- persistence
- infrastructure
- security
- integration logic

## Example

Weak design:

- controller handles input validation, business rules, SQL queries, email formatting, and auth decisions

Better design:

- controller handles request/response concerns
- business layer handles rules
- repository or data layer handles persistence
- notification logic is isolated

That is a classic separation-of-concerns improvement.

## Why It Matters

Separation of concerns improves:

- maintainability
- testability
- readability
- change isolation

It also helps teams reason about architecture because each layer or module has a clearer purpose.

## Patterns That Support It

- MVC
- layered architecture
- hexagonal architecture
- clean architecture

These patterns are valuable when they support real clarity, not when they become ceremony for its own sake.

## Tradeoffs

Too little separation creates tangled systems. Too much separation can create too many layers, too much indirection, and unnecessary complexity. The goal is meaningful boundaries.

## What Interviewers Like To Hear

- `I want business rules separated from infrastructure concerns so both can evolve more safely.`
- `Separation of concerns helps reduce accidental complexity.`
- `Good boundaries improve testability because each concern can be validated more independently.`

## Quick Study Prompts

- What concerns are most commonly mixed together in weak designs
- How is separation of concerns different from modularity
- When can too many layers become a problem
- Why does separation help testing
