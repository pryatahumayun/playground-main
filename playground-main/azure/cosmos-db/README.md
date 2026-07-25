# Cosmos DB

Azure Cosmos DB is Azure's globally distributed database platform.

## Common uses

- globally distributed applications
- low-latency reads close to users
- high-availability operational data
- JSON document workloads and other supported APIs

## Main ideas

- account
- region distribution
- consistency level
- partitioning
- multi-region writes
- automatic or manual failover

## Geo-redundancy and business continuity

For Cosmos DB, geo-redundancy usually means:

- adding multiple regions to the account
- enabling automatic failover when needed
- optionally enabling multi-region writes
- choosing the right consistency model

Practical setup flow:

1. create the Cosmos DB account in a primary region
2. add one or more secondary regions
3. decide whether writes stay single-region or become multi-region
4. configure failover priorities or multi-write behavior
5. decide whether specific regions should be zone redundant

Good to remember:

- multi-region reads and multi-region writes are different decisions
- zone redundancy is configured per region, not as one account-wide toggle
- failover planning should include consistency and application routing behavior

References:

- Global distribution: https://learn.microsoft.com/en-us/azure/cosmos-db/distribute-data-globally
- Multi-region writes: https://learn.microsoft.com/en-us/azure/cosmos-db/multi-region-writes
- Zone redundancy: https://learn.microsoft.com/en-us/azure/cosmos-db/enable-zone-redundancy
- Disaster recovery guidance: https://learn.microsoft.com/en-us/azure/cosmos-db/disaster-recovery-guidance
