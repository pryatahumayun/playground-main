# Caching

Caching stores frequently requested data closer to the consumer to reduce latency and backend load.

## What To Know

- common layers are browser, CDN, application, and database caching
- cache invalidation is one of the hard parts
- stale data is the main tradeoff

## Good Interview Points

- good for read-heavy workloads
- can protect databases during spikes
- TTL, eviction strategy, and consistency requirements matter
