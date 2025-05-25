// Resource Group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

// Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

// Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
}

// Route Tables
resource "azurerm_route_table" "route_tables" {
  for_each = var.route_tables

  name                = each.value.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

// Routes
resource "azurerm_route" "routes" {
  for_each = {
    for route in flatten([
      for rt_key, rt in var.route_tables : [
        for route_index, route in rt.routes : {
          key            = "${rt_key}-${route_index}"
          route_table_id = azurerm_route_table.route_tables[rt_key].id
          route          = route
        }
      ]
    ]) : route.key => route
  }

  name                   = each.value.route.name
  resource_group_name    = azurerm_resource_group.this.name
  route_table_name       = split("-", each.key)[0] == "public" ? azurerm_route_table.route_tables["public"].name : azurerm_route_table.route_tables["private"].name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = each.value.route.next_hop_in_ip_address
}

// Associate Route Tables with Subnets
resource "azurerm_subnet_route_table_association" "subnet_associations" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.route_tables[each.key].id
}