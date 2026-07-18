# Networking Cheatsheet

Networking basics and common commands I understand and use.

------------------------------------------------------------------------

# What Is a Network?

A network allows computers, applications, databases, and cloud resources
to communicate with each other.

Examples:

-   A laptop connecting to Wi-Fi
-   An application calling an API
-   An App Service connecting to a database
-   A Function App connecting to an on-premises system
-   Resources communicating inside an Azure VNET or AWS VPC

------------------------------------------------------------------------

# IP Address

An IP address identifies a device or resource on a network.

Example:

``` text
192.168.1.25
```

## Private IP Address

A private IP is used inside a private network.

Example:

``` text
10.0.1.5
```

Private IPs are not normally accessible from the public internet.

## Public IP Address

A public IP allows a resource to communicate over the internet.

Examples:

-   Public website
-   Public Load Balancer
-   Virtual Machine

------------------------------------------------------------------------

# DNS

DNS converts a name into an IP address.

``` text
api.example.com
        ↓
20.100.50.10
```

Private DNS can resolve Azure resources to private IP addresses.

------------------------------------------------------------------------

# Port

An IP identifies the resource.

A port identifies the service.

Example:

``` text
10.0.1.5:1433
```

Common ports:

    Port Purpose
  ------ ------------
      22 SSH
      53 DNS
      80 HTTP
     443 HTTPS
    1433 SQL Server
    3306 MySQL
    3389 RDP
    5432 PostgreSQL

------------------------------------------------------------------------

# VNET vs VPC

Azure **VNET** ≈ AWS **VPC**

Both provide a private network containing:

-   Subnets
-   Route Tables
-   Security Rules
-   Private Endpoints

------------------------------------------------------------------------

# Subnet

A subnet is a smaller section of a network.

``` text
VNET
├── Web
├── Data
└── Private Endpoint
```

------------------------------------------------------------------------

# CIDR

CIDR describes network size.

  CIDR     Total IPs
  ------ -----------
  /24            256
  /25            128
  /26             64
  /27             32
  /28             16
  /29              8

Azure reserves some addresses, so not every IP is usable.

------------------------------------------------------------------------

# Network Security Group (NSG)

An NSG controls network traffic.

Rules can allow or deny traffic based on:

-   Source
-   Destination
-   Port
-   Protocol

------------------------------------------------------------------------

# Firewall

A firewall controls traffic between networks and can inspect traffic
more deeply than an NSG.

------------------------------------------------------------------------

# Route Table

A Route Table tells traffic where to go.

Example:

``` text
Destination: 0.0.0.0/0
Next Hop: Azure Firewall
```

------------------------------------------------------------------------

# Private Endpoint

A Private Endpoint gives an Azure service a private IP inside a VNET.

Common services:

-   Azure SQL
-   Storage
-   Key Vault
-   Cosmos DB

------------------------------------------------------------------------

# VNET Integration

Allows an App Service or Function App to send outbound traffic into a
VNET.

------------------------------------------------------------------------

# Load Balancer

A Load Balancer provides one IP or DNS name in front of multiple
servers.

``` text
Users
   ↓
Load Balancer
 ├── Server 1
 ├── Server 2
 └── Server 3
```

Users always connect to the Load Balancer.

The Load Balancer decides which healthy server receives the request.

If one server goes down, it stops sending traffic there.

Think of it as:

> One address in front. Multiple healthy servers behind it.

------------------------------------------------------------------------

# Application Gateway

An Azure Application Gateway is a Layer 7 Load Balancer.

It understands HTTP and HTTPS traffic and can route based on URL paths.

------------------------------------------------------------------------

# VPN

A VPN creates a secure encrypted connection between networks.

------------------------------------------------------------------------

# Hub and Spoke

``` text
       Spoke
         │
         ▼
Spoke → Hub ← Spoke
         │
     Firewall
```

The Hub contains shared networking resources.

------------------------------------------------------------------------

# Useful Commands

## ipconfig

``` powershell
ipconfig
ipconfig /all
```

------------------------------------------------------------------------

## nslookup

``` powershell
nslookup example.com
```

Checks DNS resolution.

------------------------------------------------------------------------

## Test-NetConnection

``` powershell
Test-NetConnection example.com -Port 443
```

Tests whether a port is reachable.

------------------------------------------------------------------------

## ping

``` powershell
ping example.com
```

Tests basic connectivity.

------------------------------------------------------------------------

## tracert

``` powershell
tracert example.com
```

Shows the path packets take.

------------------------------------------------------------------------

## curl

``` powershell
curl https://example.com
```

Calls a website or API.

------------------------------------------------------------------------

## netstat

``` powershell
netstat -ano
```

Shows active network connections.

------------------------------------------------------------------------

## Flush DNS

``` powershell
ipconfig /flushdns
```

Clears the local DNS cache.

------------------------------------------------------------------------

# Azure to AWS

  Azure                 AWS
  --------------------- ---------------------------
  VNET                  VPC
  Subnet                Subnet
  NSG                   Security Group
  Private Endpoint      VPC Endpoint
  Application Gateway   Application Load Balancer
  Load Balancer         Elastic Load Balancer
  Route Table           Route Table
  Azure Firewall        AWS Network Firewall

------------------------------------------------------------------------

# Troubleshooting Checklist

1.  Is DNS resolving?
2.  Is the IP correct?
3.  Is the correct port open?
4.  Does the NSG allow it?
5.  Does the Firewall allow it?
6.  Is the Route Table correct?
7.  Is there a Private Endpoint?
8.  Is the App VNET integrated?
9.  Is there a Load Balancer?
10. Is the destination application running?

------------------------------------------------------------------------

# Mental Models

**DNS**

    Name → IP Address

**Port**

    IP → Service

**Subnet**

    Small section of a network

**NSG**

    Traffic rules

**Route Table**

    Where traffic goes

**Private Endpoint**

    Private IP for an Azure service

**VNET Integration**

    Allows an app to access private resources

**Load Balancer**

    One IP
       ↓
    Many Servers
