# AWS Terraform Modules

This directory contains Terraform modules for AWS cloud resources.# Azure Networking Module

This Terraform module creates an Azure Virtual Network with public and private subnets, including User-Defined Routes (UDRs).

## Features

- Creates a resource group
- Creates a virtual network with configurable address space
- Creates multiple subnets (public and private)
- Creates route tables for each subnet
- Configures routes within each route table
- Associates route tables with their respective subnets

## Usage

```hcl
module "networking" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/networking"

  vnet_name          = "my-vnet"
  vnet_address_space = ["10.0.0.0/16"]
  location           = "eastus"
  resource_group_name = "my-resource-group"
  
  subnets = {
    public = {
      name           = "public-subnet"
      address_prefix = "10.0.1.0/24"
      security_group = ""
    }
    private = {
      name           = "private-subnet"
      address_prefix = "10.0.2.0/24"
      security_group = ""
    }
  }

  route_tables = {
    public = {
      name = "public-rt"
      routes = [
        {
          name                   = "internet-route"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
          next_hop_in_ip_address = null
        }
      ]
    }
    private = {
      name = "private-rt"
      routes = [
        {
          name                   = "default-route"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.1.4"
        }
      ]
    }
  }

  tags = {
    Environment = "Production"
    Owner       = "Infrastructure Team"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 2.0.0 |

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vnet_name | Name of the virtual network | `string` | n/a | yes |
| vnet_address_space | Address space for the virtual network | `list(string)` | n/a | yes |
| location | Azure region where resources will be created | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| subnets | Map of subnet configurations | `map(object)` | n/a | yes |
| route_tables | Map of route table configurations | `map(object)` | n/a | yes |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID of the created virtual network |
| vnet_name | Name of the created virtual network |
| subnet_ids | Map of subnet names to their IDs |
| route_table_ids | Map of route table names to their IDs |
| resource_group_name | Name of the resource group |
| resource_group_id | ID of the resource group |