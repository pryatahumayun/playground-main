# Security Groups

Security groups are AWS's stateful virtual firewalls attached to resources.

## Common uses

- allow traffic into ALBs, EC2, ECS tasks, and databases
- restrict east-west traffic between services
- control which sources can reach which ports

## Key ideas

- ingress rules
- egress rules
- stateful behavior
- reference another security group instead of only CIDRs

## Good to remember

- security groups protect resources, not entire subnets
- they are different from NACLs
- many AWS connectivity issues come down to security group rules
