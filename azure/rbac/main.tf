# resource "azurerm_role_assignment" "this" {
#   scope                = var.scope
#   role_definition_name = var.role_definition_name
#   principal_id         = var.principal_id
# }


resource "azurerm_role_assignment" "dynamic" {
  for_each = {
    for assignment in var.role_assignments :
    "${assignment.principal_id}-${assignment.role_definition_name != null ? assignment.role_definition_name : assignment.role_definition_id}-${assignment.scope}" => assignment
  }

  principal_id         = each.value.principal_id
  scope                = each.value.scope
  role_definition_name = lookup(each.value, "role_definition_name", null)
  role_definition_id   = lookup(each.value, "role_definition_id", null)
}