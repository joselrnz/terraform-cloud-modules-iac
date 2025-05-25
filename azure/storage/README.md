# Azure Storage Account Module

This Terraform module creates an Azure Storage Account with optional containers.

## Features

- Creates an Azure Storage Account
- Configurable storage account settings (tier, replication, kind, access tier)
- Optional blob versioning
- Optional delete retention policies
- Create multiple containers with different access types

## Usage

```hcl
module "storage_account" {
  source = "path/to/modules/azure/storage"

  storage_account_name      = "mystorageaccount"
  resource_group_name       = "my-resource-group"
  location                  = "eastus"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  
  enable_versioning         = true
  enable_delete_retention   = true
  delete_retention_days     = 14
  
  containers = [
    {
      name        = "container1"
      access_type = "private"
    },
    {
      name        = "container2"
      access_type = "blob"
    }
  ]
  
  tags = {
    Environment = "Production"
    Department  = "IT"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| storage_account_name | Name of the storage account | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region where the storage account will be created | `string` | n/a | yes |
| account_tier | Defines the Tier to use for this storage account (Standard or Premium) | `string` | `"Standard"` | no |
| account_replication_type | Defines the type of replication to use for this storage account (LRS, GRS, RAGRS, ZRS) | `string` | `"LRS"` | no |
| account_kind | Defines the Kind of account (StorageV2, Storage, BlobStorage, BlockBlobStorage, FileStorage) | `string` | `"StorageV2"` | no |
| access_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts (Hot or Cool) | `string` | `"Hot"` | no |
| tags | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| enable_versioning | Enable versioning for the storage account | `bool` | `false` | no |
| enable_delete_retention | Enable delete retention policy for the storage account | `bool` | `false` | no |
| delete_retention_days | Number of days to retain deleted blobs | `number` | `7` | no |
| enable_container_delete_retention | Enable container delete retention policy for the storage account | `bool` | `false` | no |
| container_delete_retention_days | Number of days to retain deleted containers | `number` | `7` | no |
| containers | List of containers to create and their access levels | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| storage_account_id | The ID of the storage account |
| storage_account_name | The name of the storage account |
| primary_blob_endpoint | The endpoint URL for blob storage in the primary location |
| primary_access_key | The primary access key for the storage account |
| secondary_access_key | The secondary access key for the storage account |
| containers | Map of containers |
