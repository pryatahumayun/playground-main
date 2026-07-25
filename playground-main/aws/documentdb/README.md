# DocumentDB

Amazon DocumentDB is a managed document database with MongoDB compatibility goals.

## Common uses

- JSON-like document storage
- apps already built around Mongo-style access patterns
- managed document database operations on AWS

## Trade-offs

- it is not the same thing as running MongoDB everywhere without differences
- compatibility should be checked carefully before migration
- relational queries and joins are not its strength

## Good to remember

- DocumentDB is best treated as its own AWS service with Mongo compatibility, not as a perfect MongoDB clone
- always verify driver, feature, and query compatibility against current AWS docs before committing to it
