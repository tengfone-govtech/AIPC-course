## can have docker1 / docker2... 
## then the resource will be like
## resource "docker1_image_container"

terraform {
  required_version = "> 1.0.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.18.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_token
}

provider "local" {}
