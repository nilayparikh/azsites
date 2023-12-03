project = "npazs"
env     = "demo"

static_site_config = {
  identifier         = "bs5"
  index_document     = "index.html"
  error_404_document = "404.html"
  src                = "../html"
  domain = {
    name             = "azsites.nilayparikh.com"
    asverify_enabled = true
  }
}

region = {
  qualified_name = "westeurope"
  short_name     = "weu"
}
