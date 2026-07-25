# Subnets

Subnets divide a VPC into smaller network segments and are where AWS resources actually land.

## Common subnet patterns

- public subnets for ALBs, bastion hosts, or public-facing resources
- private subnets for ECS tasks, app servers, and internal services
- database subnets for RDS and other stateful tiers
- one subnet per availability zone for resilient workloads

## What makes a subnet public or private

In AWS, a subnet is effectively:

- public if its route table sends `0.0.0.0/0` to an internet gateway
- private if its default route goes to a NAT gateway or stays internal

So the route table decides the real behavior, not just the subnet name.

## Example from this repo

From the AWS playground VPC module:

```hcl
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
}
```

```hcl
resource "aws_subnet" "private" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, each.value + length(var.availability_zones))
  availability_zone = each.key
}
```

## Why subnet design matters

- it affects routing, security, and internet access
- ECS, EKS, Lambda in VPC mode, and databases all rely on subnet placement
- subnet sizing mistakes can become painful later

## Practical examples

### ECS or EKS app pattern

- public subnets for ALB or NLB
- private subnets for pods, nodes, or tasks
- NAT for outbound internet access

### Database isolation pattern

- app tier in private subnets
- database in separate subnets
- no direct internet route for the database path

## Good to remember

- use multiple AZs for resilient workloads
- keep public and private responsibilities separate
- public vs private is mostly about routing, not only about the subnet label
