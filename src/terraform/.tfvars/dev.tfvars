project = "npazs"
env     = "dev"

static_site_config = {
  identifier         = "dbs5"
  index_document     = "index.html"
  error_404_document = "404.html"
  src                = "../html"
  domain = {
    name             = "azsites-dev.nilayparikh.com"
    asverify_enabled = true
  }
}

region = {
  qualified_name = "westeurope"
  short_name     = "weu"
}
