# Terraform Cloud Modules Repository

This repository contains reusable Terraform modules for deploying infrastructure across multiple cloud providers, with a primary focus on Azure. These modules are designed to be referenced by other Terraform configurations, such as those in the `core-infrastructure` repository.

## Repository Structure

```
terraform-cloud-modules-iac/
├── azure/                # Azure modules
│   └── storage/          # Azure Storage Account module
│       ├── main.tf       # Main module configuration
│       ├── variables.tf  # Input variable definitions
│       ├── outputs.tf    # Output definitions
│       └── README.md     # Module documentation
├── gcp/                  # Google Cloud Platform modules (planned)
└── .gitignore            # Git ignore file
```

## Module Design Philosophy

This repository follows a comprehensive module design philosophy to ensure high-quality, maintainable infrastructure code:

### 1. Single Responsibility Principle

Each module focuses on deploying a specific resource or set of closely related resources. This approach:
- Makes modules easier to understand and maintain
- Allows for targeted testing and validation
- Enables composition of larger infrastructure from smaller building blocks

### 2. Comprehensive Configuration Options

Modules expose a rich set of variables for customizing the deployed resources:
- Required variables for essential configuration
- Optional variables with sensible defaults
- Validation rules to prevent misconfigurations
- Descriptive variable documentation

### 3. Consistent Interface Pattern

All modules follow a consistent interface pattern:
- Standard input variable naming conventions
- Consistent output structure
- Predictable resource naming
- Uniform tagging support

### 4. Thorough Documentation

Documentation is a first-class concern:
- Each module includes a detailed README
- Code comments explain complex logic
- Examples demonstrate common use cases
- Input and output documentation

### 5. Versioning and Compatibility

Modules are versioned to ensure stability:
- Semantic versioning (MAJOR.MINOR.PATCH)
- Backward compatibility within major versions
- Deprecation notices before breaking changes
- Migration guides for major version upgrades

## Azure Modules

### Storage Account Module

The Azure Storage Account module (`azure/storage/`) provides a comprehensive solution for deploying and managing Azure Storage resources:

#### Features

- **Storage Account Creation**: Deploys an Azure Storage Account with configurable settings
- **Blob Storage Configuration**: Supports blob storage with versioning and lifecycle management
- **Container Management**: Creates and configures multiple storage containers
- **Security Settings**: Configures access tiers, network rules, and encryption
- **Lifecycle Policies**: Supports retention policies for blobs and containers

#### Configuration Options

The module supports extensive configuration options:

```hcl
module "storage_account" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/storage?ref=v1.0.0"

  # Basic configuration
  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "eastus"

  # Performance and redundancy
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  # Data protection
  enable_versioning                 = true
  enable_delete_retention           = true
  delete_retention_days             = 14
  enable_container_delete_retention = true
  container_delete_retention_days   = 14

  # Container configuration
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

  # Resource tagging
  tags = {
    Environment = "Production"
    Department  = "IT"
    Project     = "Data Lake"
  }
}
```

## Module Usage Patterns

### Remote Source Reference

For production use, reference modules directly from the Git repository:

```hcl
module "storage_account" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/storage?ref=v1.0.0"

  # Module input variables
  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "eastus"
  # ... other variables
}
```

### Local Development Reference

For local development and testing, reference modules using a relative path:

```hcl
module "storage_account" {
  source = "../../modules/storage"

  # Module input variables
  storage_account_name = "mystorageaccount"
  resource_group_name  = "my-resource-group"
  location             = "eastus"
  # ... other variables
}
```

### Composition Pattern

Combine multiple modules to create complex infrastructure:

```hcl
module "resource_group" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/resource-group?ref=v1.0.0"

  name     = "rg-data-platform"
  location = "eastus"
}

module "storage_account" {
  source = "git::https://github.com/your-org/terraform-cloud-modules-iac.git//azure/storage?ref=v1.0.0"

  storage_account_name = "stdataplatform"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  # ... other variables
}
```

## Development and Contribution

### Module Development Workflow

1. **Create a Branch**: Create a feature branch for your new module or changes
2. **Develop Locally**: Develop and test the module locally
3. **Document**: Write comprehensive documentation
4. **Test**: Test the module with various configurations
5. **Submit PR**: Submit a pull request for review

### Testing Standards

All modules should include:
- Basic functionality tests
- Edge case validation
- Example configurations
- Integration tests with dependent resources

### Documentation Requirements

Module documentation should include:
- Purpose and use cases
- Required and optional inputs
- Outputs and their usage
- Example configurations
- Any limitations or known issues