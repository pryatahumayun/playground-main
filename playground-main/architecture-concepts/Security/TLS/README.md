# TLS

TLS protects data in transit between systems. It provides encryption, integrity, and server identity for network communication.

## What TLS Is Really About

TLS helps prevent:

- eavesdropping
- man-in-the-middle attacks
- message tampering

HTTPS is HTTP running over TLS.

## Simple Flow

```text
Client -> TLS Handshake -> Server Identity Verified
                         |
                         v
                  Encrypted Session Established
                         |
                         v
                  Secure Data Exchange
```

## Where TLS Matters

- browser to web app
- API client to API
- service-to-service communication
- admin portals
- internal east-west traffic in sensitive environments

## Example: Public API

A public API should use HTTPS so:

- credentials are not exposed
- payloads are not visible to intermediaries
- clients can verify the server identity

## Example: Internal Traffic

Some teams assume internal traffic does not need TLS.

That can be wrong in:

- zero trust environments
- regulated environments
- multi-tenant platforms
- sensitive enterprise networks

## TLS Termination

TLS can terminate at:

- load balancer
- ingress controller
- application

Where you terminate TLS changes your trust boundary.

## Operational Risks

- expired certificates
- weak cipher or outdated config
- poor certificate rotation
- unclear ownership of certificate lifecycle

## What Interviewers Like To Hear

- `TLS protects confidentiality, integrity, and server identity in transit.`
- `Certificate management is part of architecture, not just an ops detail.`
- `Where TLS terminates affects the trust boundary.`

## Quick Study Prompts

- Why is TLS more than just encryption
- What is TLS termination
- Why might internal traffic still need TLS
- What operational risks come with certificates
