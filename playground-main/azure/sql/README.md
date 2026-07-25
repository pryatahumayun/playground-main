# SQL

Azure SQL can mean Azure SQL Database, elastic pools, managed instance, or SQL Server on Azure VMs.

## Main choices

- Azure SQL Database
  Managed single database or elastic pool model.
- Azure SQL Managed Instance
  Closer to full SQL Server compatibility with more instance-level features.
- SQL Server on Azure VM
  Most control, most operational responsibility.

## Common concerns

- compute sizing
- backup and restore
- private access
- failover
- geo-redundancy

## Geo-redundancy and failover

For Azure SQL Database, the main multi-region options are:

- active geo-replication
  Replicates a single database to readable secondary databases in other regions.
- failover groups
  Build on geo-replication and let you fail over groups of databases together.

Practical setup flow:

1. create the primary logical server and database
2. choose a secondary region
3. create a geo-secondary or configure a failover group
4. test read-only secondary access if needed
5. test planned failover before relying on it operationally

Good to remember:

- geo-redundancy is about data replication across regions
- failover is about switching application traffic to a secondary region
- failover groups are usually easier to operate than managing many individual geo-replicas

Reference:

- Azure SQL reliability guidance: https://learn.microsoft.com/en-us/azure/reliability/reliability-sql-database
