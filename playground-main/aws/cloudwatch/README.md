# CloudWatch

CloudWatch is the default AWS observability layer for metrics, logs, alarms, and dashboards.

## Common uses

- collect application and infrastructure logs
- monitor CPU, memory, request counts, and errors
- set alarms for failures or thresholds
- build dashboards for service health

## Main building blocks

- CloudWatch Logs
- CloudWatch Metrics
- CloudWatch Alarms
- Dashboards

## Good to remember

- ECS, Lambda, and many AWS services integrate with CloudWatch out of the box
- logs and metrics are separate concepts
- alarms are often the first operational control worth setting up, even in small projects
