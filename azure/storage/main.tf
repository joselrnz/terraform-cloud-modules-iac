/**
 * # Azure Storage Account Module
 *
 * This module creates an Azure Storage Account with optional containers and blobs.
 */

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  access_tier              = var.access_tier
  
  tags = var.tags

  dynamic "blob_properties" {
    for_each = var.enable_versioning || var.enable_delete_retention || var.enable_container_delete_retention ? [1] : []
    content {
      dynamic "versioning_enabled" {
        for_each = var.enable_versioning ? [1] : []
        content {
          enabled = true
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.enable_delete_retention ? [1] : []
        content {
          days = var.delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = var.enable_container_delete_retention ? [1] : []
        content {
          days = var.container_delete_retention_days
        }
      }
    }
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = { for container in var.containers : container.name => container }
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
}
