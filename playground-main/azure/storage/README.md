# Storage

Azure Storage includes Blob, File, Queue, and Table services, with Blob Storage being the most common place to start.

## Common uses

- application file storage
- static site assets
- backups and exports
- data lake and analytics pipelines

## Main concerns

- access control
- replication choice
- lifecycle management
- soft delete and versioning
- private endpoints

## Blob geo-redundancy

For Blob Storage, the main redundancy choices usually go from:

- LRS
- ZRS
- GRS
- RA-GRS
- GZRS
- RA-GZRS

Practical meaning:

- `GRS` and `GZRS` replicate to a secondary region
- `RA-` variants let you read from the secondary region
- `GZRS` combines zone redundancy in the primary region with geo-replication to the secondary region

Practical setup flow:

1. choose the storage account redundancy option during creation if possible
2. use `RA-GRS` or `RA-GZRS` when you want secondary-region read access
3. verify how your app handles regional failover and stale secondary reads
4. be careful changing redundancy later if the account has archive-tier blobs

Good to remember:

- redundancy choice affects both cost and failover behavior
- replication does not automatically mean your app knows how to fail over

References:

- Geo-redundancy design guidance: https://learn.microsoft.com/en-us/azure/storage/common/geo-redundant-design
- Change storage redundancy: https://learn.microsoft.com/en-us/azure/storage/common/redundancy-migration
