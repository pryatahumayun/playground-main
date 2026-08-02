# Caching

Caching stores frequently requested data closer to the consumer so responses are faster and backend systems do less work.

## What Caching Is Really About

Caching helps with:

- lower latency
- lower database load
- better scale for read-heavy traffic

## Common Cache Layers

- browser cache
- CDN cache
- application cache
- distributed cache like Redis
- database query cache where applicable

## Simple Flow

```text
Request
  |
  v
Cache?
 | \
 |  \ miss
 |   v
hit  Database / Backend
 |      |
 v      v
Response + Cache Fill
```

## Example: Product Catalog

A product catalog is read far more often than it changes.

Good candidate for caching:

- product metadata
- category pages
- popular search results

## Main Tradeoff

Caching improves speed but risks stale data.

That is why cache invalidation is such a big topic.

## Common Cache Decisions

- TTL length
- invalidation strategy
- eviction policy
- cache key design
- what data should never be cached

## What Interviewers Like To Hear

- `Caching is strongest for read-heavy workloads with tolerable staleness windows.`
- `I would think about invalidation and consistency before celebrating the speed gain.`
- `Cache hit rate and stale-data tolerance matter just as much as adding the cache itself.`

## Quick Study Prompts

- What kinds of workloads benefit most from caching
- Why is cache invalidation difficult
- What are common cache layers
- When is stale data unacceptable
