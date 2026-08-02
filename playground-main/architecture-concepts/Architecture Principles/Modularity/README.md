# Modularity

Modularity means building a system from well-bounded parts that can be understood, tested, and changed with limited side effects. It is about structure and boundaries.

## What Modularity Is Really About

Modularity asks:

- can the system be reasoned about in parts
- do those parts have clear interfaces
- can one part change without forcing changes everywhere else

## Modularity Is Not Only Microservices

A common mistake is assuming modularity means microservices.

Not true.

A system can be modular as:

- a modular monolith
- a plugin-based platform
- a layered application
- a set of services

Microservices are one possible expression of modularity, not the definition.

## Example: Modular Monolith

An application may have modules for:

- user accounts
- orders
- payments
- reporting

If those modules have:

- clear boundaries
- limited dependencies
- focused responsibilities

then the system can be highly modular even as one deployable unit.

## Why Modularity Matters

Modularity helps with:

- maintainability
- testability
- safer change
- clearer ownership
- gradual evolution

It often makes refactoring and later decomposition easier too.

## What Weak Modularity Looks Like

- modules call each other chaotically
- boundaries exist in folders only, not in behavior
- shared data models leak everywhere
- every change crosses many modules

That is a system that looks modular on paper but not in reality.

## Tradeoffs

Stronger modularity may require:

- deliberate interface design
- more boundary discipline
- less convenience in sharing internals freely

But the payoff is usually much better long-term control.

## What Interviewers Like To Hear

- `Modularity is about well-bounded parts, not just separate deployments.`
- `A modular monolith is often a strong design option.`
- `Weak boundaries reduce the value of modularity quickly.`

## Quick Study Prompts

- How is modularity different from microservices
- Why can a monolith still be modular
- What are signs that module boundaries are weak
- Why does modularity help future change
