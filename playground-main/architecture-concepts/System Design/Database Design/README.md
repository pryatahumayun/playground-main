# Database Design

Database design covers how data is structured, stored, queried, and protected from inconsistency.

## What Database Design Is Really About

Good database design should reflect:

- data relationships
- access patterns
- consistency needs
- scale requirements
- reporting needs

## Common Topics

- normalization
- denormalization
- indexing
- partitioning
- relational vs NoSQL choice
- transaction boundaries

## Example

An order system often fits relational storage well because:

- order, payment, and status changes need integrity
- transactions matter
- relationships are meaningful

A product catalog or event log may have different needs depending on scale and query style.

## Access Patterns Matter

Do not design the schema in isolation.

Ask:

- what queries are most common
- what writes are most common
- which fields are filtered often
- which operations require strong consistency

## Tradeoffs

- normalization improves integrity but can increase join complexity
- denormalization can improve read speed but increases duplication
- indexes help reads but hurt writes and use storage

## What Interviewers Like To Hear

- `I want schema design to reflect access patterns, not just entity names.`
- `Relational and NoSQL choices depend on consistency, scale, and query needs.`
- `Indexes are powerful, but they are not free.`

## Quick Study Prompts

- Why do access patterns matter in schema design
- When is normalization useful
- Why can denormalization help
- Why are indexes a tradeoff
