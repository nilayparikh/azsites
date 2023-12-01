project = "ergx"
env     = "prod"

static_site_config = [
  {
    identifier         = "mrt"
    index_document     = "index.html"
    error_404_document = "404.html"
    src = "../html/mrt"
    domain = {
      name = "mrt.azsites.oss.nilayparikh.com"
      asverify_enabled = true
    }
  },
  {
    identifier         = "one"
    index_document     = "index.html"
    error_404_document = "404.html"
    src = "../html/one"
    domain = {
      name = "two.azsites.oss.nilayparikh.com"
      asverify_enabled = true
    }
  },
  {
    identifier         = "two"
    index_document     = "index.html"
    error_404_document = "404.html"
    src = "../html/mrt"
    domain = {
      name = "two.azsites.oss.nilayparikh.com"
      asverify_enabled = true
    }
  }
]

region = {
  qualified_name = "westeurope"
  short_name     = "weu"
}