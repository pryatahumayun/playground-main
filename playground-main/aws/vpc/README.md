# Amazon VPC (Virtual Private Cloud)

A VPC is your private network boundary inside AWS.

If you deploy:

- EC2
- ECS
- EKS worker nodes
- RDS
- load balancers

they usually live inside a VPC.

## Azure comparison

Closest Azure equivalent:

- `VNet` in Azure
- `VPC` in AWS

The concepts are very similar, but AWS makes networking feel especially central because many workload services are explicitly VPC-first.

## Core VPC components

### CIDR block

The VPC CIDR defines the address space for the network.

Example:

```text
10.0.0.0/16
```

Every subnet in the VPC draws its space from that range.

### Subnets

Subnets divide the VPC into smaller network segments.

Common patterns:

- public subnets for internet-facing load balancers
- private subnets for application workloads
- isolated/database subnets for stateful services

### Route tables

Route tables control where subnet traffic goes:

- local VPC traffic
- internet gateway
- NAT gateway
- VPC peering
- transit gateway
- VPN or Direct Connect

### Security groups

Security groups are AWS's stateful resource firewalls.

Unlike Azure NSGs, they are usually attached directly to resources such as:

- EC2
- ECS tasks
- RDS
- load balancers

### Internet gateway

An internet gateway allows traffic between public subnets and the internet.

Without a route to an internet gateway, a subnet is not truly public.

### NAT gateway

A NAT gateway lets private subnet resources reach the internet for outbound traffic without exposing them publicly for inbound access.

This is common for:

- package updates
- pulling container images
- reaching public AWS services from private workloads

## Example Terraform from this repo

This repo already has a good VPC module example:

- [main.tf](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/aws-playground/infrastructure-modules/modules/networking/vpc/main.tf)

That module creates:

- one VPC
- one public subnet per AZ
- one private subnet per AZ
- an internet gateway
- one NAT gateway per AZ
- public and private route tables

### Create the VPC

```hcl
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.vpc_name })
}
```

### Create public subnets

```hcl
resource "aws_subnet" "public" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
}
```

### Create private subnets

```hcl
resource "aws_subnet" "private" {
  for_each = { for idx, az in var.availability_zones : az => idx }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, each.value + length(var.availability_zones))
  availability_zone = each.key
}
```

### Route public traffic to the internet

```hcl
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}
```

### Route private traffic through NAT

```hcl
resource "aws_route" "private_nat" {
  for_each = toset(var.availability_zones)

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}
```

## Practical VPC patterns

### Public ALB plus private app workloads

Very common in ECS and EKS:

- ALB in public subnets
- app tasks or nodes in private subnets
- NAT for outbound access

### Private database tier

- app in private subnets
- RDS in separate private/database subnets
- security groups only allow app-to-db traffic

### Admin access

If you need instance access, common AWS approaches include:

- Systems Manager Session Manager
- bastion host

For many modern AWS environments, Session Manager is often cleaner than exposing a bastion publicly.

## Good to remember

- public vs private in AWS is mostly a routing decision
- subnet design, route tables, and security groups work together
- NAT gateways are useful but can become noticeable cost items
