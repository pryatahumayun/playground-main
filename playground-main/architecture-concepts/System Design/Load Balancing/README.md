# Load Balancing

Load balancing distributes traffic across multiple backends so no single instance has to absorb all demand alone.

## What Load Balancing Is Really About

Load balancing helps with:

- scalability
- availability
- failover
- traffic distribution

## Simple Diagram

```text
Clients
   |
   v
Load Balancer
 |    |    |
 v    v    v
App1 App2 App3
```

## Common Functions

- health checks
- removing unhealthy nodes from rotation
- routing by path or host
- TLS termination
- internal or external traffic distribution

## Layer 4 vs Layer 7

### Layer 4

Routes based on network information like IP and port.

### Layer 7

Routes based on application-level details like:

- URL path
- host header
- cookies

## Example: Public Web App

Three web instances sit behind a load balancer.

If one instance fails:

- health checks detect failure
- new traffic is routed to healthy nodes

That improves both scale and availability.

## Sticky Sessions

Sticky sessions send the same client back to the same backend.

Useful when state is tied to one node, but it reduces flexibility and can create uneven load.

## What Interviewers Like To Hear

- `Load balancing is about both traffic distribution and health-aware failover.`
- `Layer 7 balancing gives richer routing control than Layer 4.`
- `Sticky sessions can simplify stateful apps, but stateless designs scale more cleanly.`

## Quick Study Prompts

- Why are health checks important
- What is the difference between Layer 4 and Layer 7 load balancing
- Why are stateless backends easier behind a load balancer
- What tradeoff comes with sticky sessions
