variable "role_assignments" {
  description = "List of role assignments (principal_id + role + scope)"
  type = list(object({
    principal_id         = string
    scope                = string
    role_definition_name = optional(string)
    role_definition_id   = optional(string)
  }))
}