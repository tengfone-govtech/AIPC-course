## can have docker1 / docker2... 
## then the resource will be like
## resource "docker1_image_container"

terraform {
  required_version = "> 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.18.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "digitalocean" {
  token = var.DO_token
}
