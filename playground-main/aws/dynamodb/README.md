# DynamoDB

DynamoDB is AWS's fully managed key-value and document database.

## Best fit

- predictable access patterns
- very high scale
- low-latency lookups
- event-driven architectures

## Design ideas that matter

- design around access patterns first
- choose partition keys carefully
- use sort keys when you need grouped or ordered access
- add GSIs only when they support a real query pattern

## Common concepts

- partition key
- sort key
- GSI
- on-demand vs provisioned capacity
- TTL

## Good to remember

- DynamoDB rewards intentional data modeling
- the hardest part is usually schema design, not service setup
- scans are usually a smell unless the dataset is small or the use case is one-off
