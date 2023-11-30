locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".xml"  = "application/xml"
    ".pdf"  = "application/pdf"
    ".txt"  = "text/plain"
  }

  auto_tags = {
    "region_short_name"  = var.region.short_name
    "region_qualified_name" = var.region.qualified_name
    "project" = var.project
    "environment" = var.env
  }

  exclude_patterns = [
    "exclude_folder/*",
    "exclude_file.txt"
  ]

  static_site_config_map = { for config in var.static_site_config : config.identifier => config }

  html_files = merge([
    for config in var.static_site_config : {
      for file in fileset(config.src, "**") : file => config if !anytrue([for pattern in local.exclude_patterns : can(regex(pattern, file))])
    }
  ]...)
}