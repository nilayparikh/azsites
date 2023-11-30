terraform {
  required_version = ">= 1.5.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.82.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "my-resource-group" // value will be assigned at runtime
    storage_account_name = "my-storage-account" // value will be assigned at runtime
    container_name       = "my-container" // value will be assigned at runtime
    key                  = "terraform.tfstate" // value will be assigned at runtime
  }
}

provider "azurerm" {
  features {}
}

provider "cloudflare" {
  api_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" // value will be assigned at runtime
}

provider "random" {}

provider "time" {}
