resource "azurerm_storage_account" "main" {
  name                     = "${module.naming.storage_account.name}${var.static_site_config.identifier}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_kind             = "StorageV2"
  account_tier             = var.storage_account_consts.account_tier
  account_replication_type = var.storage_account_consts.account_replication_type
  min_tls_version          = var.storage_account_consts.min_tls_version

  static_website {
    index_document     = var.static_site_config.index_document
    error_404_document = var.static_site_config.error_404_document
  }

  dynamic "custom_domain" {
    for_each = var.static_site_config.domain != null && var.static_site_config.domain.name != null ? [1] : []
    content {
      name          = var.static_site_config.domain.name
      use_subdomain = var.static_site_config.domain.asverify_enabled
    }
  }

  tags = merge(
    local.auto_tags,
    {
      "static_site_config_identifier" = var.static_site_config.identifier,
      "last_run_on"                   = timestamp()
    }
  )
}

resource "azurerm_storage_blob" "main" {
  for_each = local.html_files

  name                   = each.key
  storage_account_name   = azurerm_storage_account.main.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${each.value.src}/${each.key}"
  content_type           = lookup(local.mime_types, ".${element(reverse(split(".", each.key)), 0)}", "application/octet-stream")
  content_md5            = filemd5("${each.value.src}/${each.key}")
}
