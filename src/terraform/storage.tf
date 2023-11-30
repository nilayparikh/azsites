resource "azurerm_storage_account" "main" {
  for_each = local.static_site_config_map

  name                     = "${module.naming.storage_account.name}${each.value.identifier}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_kind             = "StorageV2"
  account_tier             = var.storage_account_consts.account_tier
  account_replication_type = var.storage_account_consts.account_replication_type
  min_tls_version          = var.storage_account_consts.min_tls_version

  static_website {
    index_document     = each.value.index_document
    error_404_document = each.value.error_404_document
  }

  dynamic "custom_domain" {
    for_each = each.value.domain != null ? each.value.domain.name != null ? [1] : [] : []
    content {
      name = each.value.domain.name
      use_subdomain = each.value.domain.asverify_enabled
    }
  }

  tags = merge(
    local.auto_tags,
    {
      "static_site_config_identifier" = each.value.identifier,
      "last_run_on" = timestamp()
    }
  )
}

resource "azurerm_storage_blob" "main" {
  for_each = local.html_files

  name                   = each.key
  storage_account_name   = azurerm_storage_account.main[each.value.identifier].name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${each.value.src}/${each.key}"
  content_type = lookup(local.mime_types, ".${element(reverse(split(".", each.key)), 0)}", "application/octet-stream")
}