# CAP Theorem

CAP says a distributed system can only fully guarantee two of the following three properties during a network partition:

- consistency
- availability
- partition tolerance

## What To Know

- in real distributed systems, partition tolerance is usually not optional
- the real tradeoff is often between consistency and availability during failure

## Good Interview Points

- CAP is about behavior under partition, not normal operation
- eventual consistency is a common design choice
- use the theorem to explain tradeoffs, not as a slogan
