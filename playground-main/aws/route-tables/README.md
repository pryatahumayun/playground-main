# Route Tables

Route tables control where subnet traffic goes inside a VPC.

## Common destinations

- internet gateway
- NAT gateway
- VPC peering connection
- transit gateway
- local VPC routes

## Why they matter

- route tables are what make a subnet effectively public or private
- bad routing can break otherwise healthy workloads

## Good to remember

- subnet association decides which route table applies
- routing and security groups solve different problems
