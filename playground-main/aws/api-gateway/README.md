# API Gateway

API Gateway is AWS's managed API front door for HTTP, REST, and WebSocket APIs.

## Common uses

- expose Lambda functions as APIs
- front internal services with authentication and throttling
- publish public APIs with usage plans and API keys

## Main choices

- HTTP API
  Lower cost and simpler, good for many modern APIs.
- REST API
  More mature feature set, useful when you need advanced API Gateway features.
- WebSocket API
  For persistent two-way communication.

## Good to remember

- API Gateway is often paired with Lambda, but it can also integrate with other AWS services
- authorizers are a key part of the security story
- HTTP API is usually the better default unless you know you need REST API features
