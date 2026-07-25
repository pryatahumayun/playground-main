# Monitoring

Monitoring in AWS usually combines CloudWatch with service-specific metrics, logs, and alarms.

## Common goals

- know when a service is down
- detect latency and error spikes
- inspect logs during incidents
- track basic capacity and cost signals

## Typical tools

- CloudWatch metrics
- CloudWatch logs
- CloudWatch alarms
- dashboards
- X-Ray or third-party observability platforms when needed

## Good to remember

- even simple projects benefit from a few alarms
- health checks, logs, and deployment events are the first things to wire up
