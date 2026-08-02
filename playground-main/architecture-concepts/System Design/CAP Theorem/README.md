# CAP Theorem

CAP says a distributed system can only fully guarantee two of these three properties during a network partition:

- consistency
- availability
- partition tolerance

## What CAP Is Really About

CAP is about what happens during partition, not what happens on a normal healthy day.

In real distributed systems, partition tolerance is usually not optional. That means the meaningful tradeoff is often between:

- stronger consistency
- higher availability

during failure conditions.

## Terms

### Consistency

Every client sees the same current data after a write.

### Availability

Every request receives a response, even if it may not reflect the latest write.

### Partition Tolerance

The system continues operating even when network communication between nodes is disrupted.

## Example

Suppose two regions cannot communicate.

You may choose:

- pause writes until consistency is preserved
- or continue serving requests and accept temporary inconsistency

That is the CAP tradeoff in practice.

## What CAP Is Not

- not a general statement that one database is “CP” forever and another is “AP” forever in every context
- not mainly about normal performance
- not an excuse to avoid understanding actual workload needs

## What Interviewers Like To Hear

- `CAP matters during network partition, not just normal runtime.`
- `Partition tolerance is usually assumed in distributed systems, so the real tension is consistency versus availability under failure.`
- `I use CAP to explain tradeoffs, not as a slogan.`

## Quick Study Prompts

- Why is partition tolerance usually non-negotiable
- What is consistency in CAP terms
- Why is CAP about failure conditions
- What is an example of choosing availability over strict consistency
