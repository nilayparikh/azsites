variable "storage_account_consts" {
  type = object({
    account_tier             = string
    account_replication_type = string
    min_tls_version          = string
  })

  default = {
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_2"
  }
}
