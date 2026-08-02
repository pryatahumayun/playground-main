# Defense in Depth

Defense in depth means using multiple layers of protection instead of trusting any single security control.

## What Defense in Depth Is Really About

The assumption is simple:

- one control can fail

So strong architecture uses layers such as:

- identity
- authorization
- network controls
- encryption
- secure configuration
- logging and monitoring
- backups and recovery

## Simple Layered View

```text
User / Service
     |
Authentication
     |
Authorization
     |
Network Controls
     |
Application Controls
     |
Data Protection
     |
Monitoring / Alerting
```

## Example: Public API

A public API should not depend on only one defense.

A better layered design might include:

- authentication
- authorization
- TLS
- WAF or ingress filtering
- rate limiting
- secure secret handling
- logging and alerts

## Example: Sensitive Data Platform

For customer or financial data:

- encrypt data at rest
- use TLS in transit
- restrict network exposure
- limit permissions
- monitor access patterns
- test backup and recovery

## Why It Matters

If one layer fails:

- other controls still reduce damage

That is the core value of depth.

## What Interviewers Like To Hear

- `I assume one control can fail, so I want layered protections.`
- `Monitoring and alerting are part of defense in depth, not separate from it.`
- `Secure architecture is usually a stack of controls, not one magic control.`

## Quick Study Prompts

- What are common layers in defense in depth
- Why is monitoring part of the model
- How would you apply defense in depth to a public API
- Why is one strong control not enough
