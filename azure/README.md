# Azure Terraform Modules

This directory contains reusable Terraform modules for Azure cloud resources. These modules are designed to be referenced by other Terraform configurations to deploy standardized Azure infrastructure.

## Available Modules

### Storage Account Module

The `storage/` module provides a comprehensive solution for deploying and managing Azure Storage resources:

- Creates an Azure Storage Account with configurable settings
- Supports blob storage with versioning and lifecycle management
- Creates and configures multiple storage containers
- Configures access tiers, network rules, and encryption
- Supports retention policies for blobs and containers

[View Storage Module Documentation](./storage/README.md)

## Module Design Standards

All Azure modules in this repository follow these design standards:

### 1. Azure Resource Naming

Modules accept resource names as input variables, allowing the calling configuration to control naming conventions. This enables:

- Consistent naming across environments
- Compliance with organizational naming standards
- Flexibility for different naming requirements

### 2. Resource Group Management

Modules typically do not create resource groups but accept an existing resource group name as an input. This approach:

- Separates resource group lifecycle management from resource deployment
- Allows multiple resources to be deployed to the same resource group
- Supports organizational resource grouping strategies

### 3. Location Handling

Modules accept the Azure region (location) as an input variable, enabling:

- Deployment to any supported Azure region
- Consistent region selection across resources
- Support for multi-region architectures

### 4. Tagging Support

All modules support resource tagging through a `tags` input variable, enabling:

- Consistent tagging across resources
- Support for organizational tagging policies
- Cost allocation and resource organization

### 5. Output Structure

Modules provide consistent outputs including:

- Resource IDs for referencing in other configurations
- Resource names for human-readable identification
- Resource-specific attributes needed for integration

## Planned Modules

The following Azure modules are planned for future development:

1. **Resource Group Module**: For creating and managing Azure Resource Groups
2. **Virtual Network Module**: For deploying Azure Virtual Networks with subnets
3. **Key Vault Module**: For managing Azure Key Vault and secrets
4. **App Service Module**: For deploying Azure App Services
5. **SQL Database Module**: For provisioning Azure SQL Databases
6. **Container Registry Module**: For managing Azure Container Registry
7. **Kubernetes Service Module**: For deploying Azure Kubernetes Service (AKS)

## Usage Examples

### Basic Storage Account

```hcl
module "storage_account" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/storage?ref=v1.0.0"

  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "eastus"
}
```

### Storage Account with Containers

```hcl
module "storage_account" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/storage?ref=v1.0.0"

  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "eastus"

  containers = [
    {
      name        = "data"
      access_type = "private"
    },
    {
      name        = "public"
      access_type = "blob"
    }
  ]

  tags = {
    Environment = "Production"
    Department  = "IT"
  }
}
```