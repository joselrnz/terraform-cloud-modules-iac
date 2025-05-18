output "role_assignment_ids" {
  value = [for r in azurerm_role_assignment.dynamic : r.id]
}