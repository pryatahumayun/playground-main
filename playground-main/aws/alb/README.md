# ALB

Application Load Balancer is the Layer 7 load balancer in AWS for HTTP and HTTPS traffic.

## Common uses

- route traffic to ECS, EKS, EC2, or Lambda targets
- path-based routing such as `/api` and `/admin`
- host-based routing such as `api.example.com` and `app.example.com`
- TLS termination with ACM certificates

## Main building blocks

- listener
- listener rules
- target group
- health checks
- security group

## Good to remember

- ALBs are managed from the EC2 console, even when they front ECS or Fargate
- target groups decide where traffic actually goes
- health checks are often the first place to look when an app seems "up" but is not serving traffic
