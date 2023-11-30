resource "azurerm_resource_group" "main" {
  name     = module.naming.resource_group.name
  location = var.region.qualified_name
}
