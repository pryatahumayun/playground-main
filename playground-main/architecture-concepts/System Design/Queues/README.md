# Queues

Queues decouple producers from consumers and allow work to be processed asynchronously.

## What To Know

- smooths bursts of traffic
- improves resilience when downstream systems are slower
- allows retry and backoff patterns

## Good Interview Points

- message ordering and duplicate handling matter
- dead-letter queues help isolate bad messages
- queues improve system stability at the cost of immediacy
