# Amazon VPC (Virtual Private Cloud)

## What I Know

A VPC is your own private network inside AWS.

Think of it as the network boundary where most of your AWS resources live.

When you create resources like:

- EC2
- ECS
- RDS
- Elastic Load Balancers

they are typically deployed inside a VPC.

Some services, such as Lambda, can run without a VPC, but they can also be connected to one when private networking is required.

---

# Similar Azure Concept

The closest Azure equivalent is a **Virtual Network (VNET).**

Both provide:

- Private networking
- IP address ranges
- Subnets
- Routing
- Security
- Connectivity to on-premises and other networks

Coming from Azure, I found VPCs much easier to understand than expected because the concepts are very similar.

---

# Components

## CIDR Block

Defines the IP address range available for the VPC.

Example:

```
10.0.0.0/16
```

Choosing the correct CIDR block is important because every subnet inside the VPC will use addresses from this range.

---

## Subnets

Subnets divide a VPC into smaller networks.

Common examples include:

- Public Subnet
- Private Subnet
- Database Subnet

Very similar to Azure Subnets.

One thing AWS emphasizes more than Azure is whether a subnet is **public** or **private**.

---

## Route Tables

Route Tables determine where network traffic is sent.

Examples include:

- Local VPC traffic
- Internet Gateway
- NAT Gateway
- VPN
- Transit Gateway

Very similar to Azure Route Tables.

---

## Security Groups

Security Groups act like virtual firewalls.

They control:

- Inbound traffic
- Outbound traffic

Closest Azure equivalent:

```
Network Security Groups (NSGs)
```

### One Difference I Learned

Azure commonly applies NSGs to subnets.

AWS Security Groups are attached directly to resources such as:

- EC2
- ECS
- RDS
- Load Balancers

This makes Security Groups feel like firewall rules that travel with the resource instead of protecting an entire subnet.

---

## Internet Gateway

An Internet Gateway allows resources in public subnets to communicate with the Internet.

Without an Internet Gateway, a subnet isn't truly public, even if resources have public IP addresses.

Azure doesn't have one specific service called an Internet Gateway. Internet access is handled through routing, public IPs, load balancers, and other networking services.

---

## NAT Gateway

A NAT Gateway allows resources inside a **private subnet** to access the Internet without exposing them publicly.

Example:

```
Private EC2

↓

Downloads Windows Updates

↓

NAT Gateway

↓

Internet
```

This allows outbound traffic while preventing inbound connections from the Internet.

Azure provides a very similar NAT Gateway service.

---

# What Lives Inside a VPC?

Examples include:

- EC2 Instances
- ECS Tasks
- RDS Databases
- Elastic Load Balancers

One thing I noticed while learning AWS is that networking feels much more central than it does in Azure.

People often start with:

> "Which VPC should this resource live in?"

Whereas in Azure I usually think:

> "Which Resource Group am I deploying this into?"

---

# Lessons Learned

AWS vs Azure

| Azure | AWS |
|--------|-----|
| Virtual Network (VNET) | Virtual Private Cloud (VPC) |
| Subnet | Subnet |
| Network Security Group | Security Group |
| Route Table | Route Table |
| VPN Gateway | VPN Gateway |
| Private Endpoint | VPC Endpoint |

Learning Azure networking first made AWS networking much easier to understand.

---

# Things I Still Want to Learn

- VPC Peering
- Transit Gateway
- Network ACLs
- VPC Endpoints
- AWS PrivateLink
- DNS inside a VPC
- Multi-region networking
- Hub and Spoke architectures in AWS
- How large enterprises structure multiple VPCs
