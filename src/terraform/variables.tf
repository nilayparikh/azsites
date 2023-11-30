
variable "project" {
  type        = string
  description = "The project name"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must be lowercase alphanumeric characters or hyphens"
  }
}

variable "env" {
  type        = string
  description = "The environment"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.env))
    error_message = "Environment must be lowercase alphanumeric characters or hyphens"
  }
}

variable "static_site_config" {
  type = list(object({
    index_document     = string
    error_404_document = string
    identifier         = string
    src                = string
    domain             = optional(object({
      name             = string
      asverify_enabled = optional(bool)
    }))
  }))
  description = "Static site configuration"
  validation {
    condition     = alltrue([
      for config in var.static_site_config : 
          can(regex("^([a-zA-Z0-9]+/)?[a-zA-Z0-9]+\\.[a-zA-Z0-9]+$", config.index_document)) && 
          can(regex("^([a-zA-Z0-9]+/)?[a-zA-Z0-9]+\\.[a-zA-Z0-9]+$", config.error_404_document)) && 
          can(regex("^[a-z0-9]{4}$", config.identifier)) && 
          can(regex("^(\\.|\\.\\.)?(/[a-zA-Z0-9]+)*$", config.src)) &&
          (config.domain != null ? (can(regex("^[a-zA-Z0-9-.]+$", config.domain.name)) && 
          (config.domain.name != null ? config.domain.asverify_enabled != null : true)) : true)
    ])
    error_message = "Index page and error_404_page must be valid absolute paths, identifier must be 4 lowercase alphanumeric characters, and src must be a valid relative or absolute path. Domain name must be a valid domain. If domain name is provided, asverify_enabled must exist."
  }
}


variable "region" {
  type        = object({
    qualified_name = string
    short_name     = string
  })
  description = "The region"
  validation {
    condition     = contains(["australiacentral","australiacentral2","australiaeast","australiasoutheast","brazilsouth","brazilsoutheast","brazilus","canadacentral","canadaeast","centralindia","centralus","centraluseuap","eastasia","eastus","eastus2","eastus2euap","francecentral","francesouth","germanynorth","germanywestcentral","israelcentral","italynorth","japaneast","japanwest","jioindiacentral","jioindiawest","koreacentral","koreasouth","malaysiasouth","mexicocentral","northcentralus","northeurope","norwayeast","norwaywest","polandcentral","qatarcentral","southafricanorth","southafricawest","southcentralus","southeastasia","southindia","spaincentral","swedencentral","swedensouth","switzerlandnorth","switzerlandwest","uaecentral","uaenorth","uksouth","ukwest","westcentralus","westeurope","westindia","westus","westus2","westus3","austriaeast","chilecentral","eastusslv","israelnorthwest","malaysiawest","newzealandnorth","northeuropefoundational","taiwannorth","taiwannorthwest"], var.region.qualified_name) && can(regex("^[a-z0-9]+$", var.region.short_name))
    error_message = "Region properties must be lowercase alphanumeric characters or hyphens and qualified_name must be a valid region"
  }
}