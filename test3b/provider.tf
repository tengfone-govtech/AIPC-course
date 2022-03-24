terraform {
  required_version = "> 1.0.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.18.0"
    }
  }
  backend "s3" {
    key                         = "mystates/test3b.tfstates"
    region                      = "sgp1"
    bucket                      = "aipc-mar22"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    endpoint                    = "https://sgp1.digitaloceanspaces.com"
  }
}

provider "digitalocean" {
  token = var.DO_token
}

provider "local" {}
