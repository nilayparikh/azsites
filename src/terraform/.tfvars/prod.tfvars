project = "ergx"
env     = "prod"

static_site_config = [
  {
    identifier         = "main"
    index_document     = "index.html"
    error_404_document = "404.html"
    src = "../html/main"
    domain = {
      name = "ergosum.in"
      asverify_enabled = true
    }
  }
]

region = {
  qualified_name = "westeurope"
  short_name     = "weu"
}