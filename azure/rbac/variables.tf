variable "scope" {
  description = "The resource ID where the role assignment applies (e.g., a storage account)"
  type        = string
}

variable "role_definition_name" {
  description = "The role to assign (e.g., 'Reader', 'Storage Blob Data Contributor')"
  type        = string
}

variable "principal_id" {
  description = "The object ID of the user, group, or service principal"
  type        = string
}

variable "role_assignments" {
  description = <<EOT
List of IAM role assignments:
- principal_id (required)
- scope (required)
- role_definition_name (optional)
- role_definition_id (optional)
Only one of role_definition_name or role_definition_id should be provided.
EOT
  type = list(object({
    principal_id         = string
    scope                = string
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
  }))
}