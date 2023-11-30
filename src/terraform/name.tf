module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.4.0"

  suffix = [var.project, var.env, var.region.short_name]
}
