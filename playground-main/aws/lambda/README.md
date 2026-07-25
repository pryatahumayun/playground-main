# Lambda

AWS Lambda is AWS's serverless compute service for event-driven code.

## Common triggers

- API Gateway
- EventBridge
- S3
- SQS
- DynamoDB streams

## Best fit

- lightweight APIs
- background processing
- scheduled jobs
- integration glue between services

## Good to remember

- Lambda is great for bursty or event-driven workloads
- cold starts and execution limits matter
- packaging and IAM permissions are part of the real deployment story
