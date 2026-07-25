# Networking

Azure networking starts with VNets and subnets, but the technical design work usually ends up in:

- subnet boundaries
- NSG rules
- route tables
- private endpoints and DNS
- ingress choices like Application Gateway or Load Balancer
- admin access paths like Bastion

If you already know cloud networking well, the Azure mapping is usually:

- `VNet` = private network boundary
- `Subnet` = segmentation and placement
- `NSG` = firewall rules
- `UDR` = custom route control
- `Private Endpoint` = private IP for a PaaS service

## Core building blocks

### VNet

The VNet is the IP boundary for your Azure resources.

Typical design decisions:

- address space size
- flat vs hub-and-spoke layout
- whether private endpoints get a dedicated subnet
- whether this VNet will be peered to others

### Subnets

Subnets segment the VNet and are where resources actually land.

Common subnet patterns:

- app subnet
- data subnet
- private endpoint subnet
- `AzureBastionSubnet`
- gateway subnet

Example from this repo:

```bicep
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: appSubnetName
        properties: {
          addressPrefix: appSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: privateEndpointSubnetName
        properties: {
          addressPrefix: privateEndpointSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}
```

Source:

- [network.settings.bicep](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/azure-playground/modules/networking/network.settings.bicep)

### NSGs

NSGs are your subnet or NIC firewall rules.

Typical inbound examples:

- allow `443` from the internet to a public ingress subnet
- allow only app-to-db traffic on `1433`
- allow admin traffic only from a jump network or Bastion path

Typical outbound examples:

- force traffic to a firewall
- restrict direct internet egress
- allow only internal or approved destination ranges

Example NSG in Bicep:

```bicep
resource appNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-app'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-https-inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'allow-app-to-sql'
        properties: {
          priority: 200
          direction: 'Outbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}
```

To associate it with a subnet:

```bicep
resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: virtualNetwork
  name: appSubnetName
  properties: {
    addressPrefix: appSubnetPrefix
    networkSecurityGroup: {
      id: appNsg.id
    }
  }
}
```

### Route tables and UDRs

Azure route tables are how you override default routing behavior.

Typical uses:

- send all outbound traffic through Azure Firewall
- direct traffic to an NVA
- influence hybrid routing to on-prem
- avoid direct internet breakout from sensitive subnets

Example route table in Bicep:

```bicep
resource appRouteTable 'Microsoft.Network/routeTables@2023-11-01' = {
  name: 'rt-app'
  location: location
  properties: {
    routes: [
      {
        name: 'default-to-firewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.10.4'
        }
      }
    ]
  }
}
```

To associate it with a subnet:

```bicep
resource appSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: virtualNetwork
  name: appSubnetName
  properties: {
    addressPrefix: appSubnetPrefix
    routeTable: {
      id: appRouteTable.id
    }
  }
}
```

### Private endpoints

Private endpoints are one of the most important Azure networking features for production design.

They let PaaS services get a private IP inside your VNet, such as:

- Azure SQL
- Storage Blob
- Key Vault
- Cosmos DB

Typical setup pattern:

1. create a dedicated private endpoint subnet
2. disable private endpoint network policies on that subnet
3. create the private endpoint
4. link the correct private DNS zone
5. verify clients resolve the service name privately

Example Bicep shape:

```bicep
resource sqlPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'pe-sql'
  location: location
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: 'sql-connection'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
}
```

Source pattern:

- [database.settings.bicep](/C:/Users/pryat/Downloads/playground-main/playground-main/projects/azure-playground/modules/database/database.settings.bicep)

### Private DNS note

Private endpoints are only half the solution. DNS is the other half.

Common private DNS zones:

- `privatelink.database.windows.net`
- `privatelink.blob.core.windows.net`
- `privatelink.documents.azure.com`

If DNS is wrong, the private endpoint exists but clients may still hit the public endpoint.

### Bastion and VM access

If you ever need to connect to a VM without exposing RDP or SSH directly to the internet, Azure Bastion is the clean Azure-native path.

Typical pattern:

1. create a subnet named `AzureBastionSubnet`
2. deploy Bastion into that subnet
3. keep the VM on a private subnet
4. connect through the Azure portal

Example Bastion subnet:

```bicep
resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: virtualNetwork
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: '10.0.99.0/26'
  }
}
```

High-level Bastion resource shape:

```bicep
resource bastionPublicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-bastion'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2023-11-01' = {
  name: 'bastion-main'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'
        properties: {
          subnet: {
            id: bastionSubnet.id
          }
          publicIPAddress: {
            id: bastionPublicIp.id
          }
        }
      }
    ]
  }
}
```

## Practical Azure patterns

### App plus private data tier

- app subnet
- private endpoint subnet
- Azure SQL or Storage through private endpoint
- NSG on app subnet
- optional UDR through Azure Firewall

### AKS with private dependencies

- AKS node subnet
- ingress subnet or front-end load balancer path
- private endpoints for ACR, Key Vault, SQL, or Storage where required
- careful DNS planning

### VM admin access without public exposure

- VM in private subnet
- Bastion in `AzureBastionSubnet`
- no public IP on the VM

## Good to remember

- in Azure, private endpoints and private DNS usually come as a pair
- NSGs and route tables solve different problems
- subnet planning is easier early than during migration
- when troubleshooting, always check:
  - effective NSG rules
  - effective routes
  - DNS resolution
