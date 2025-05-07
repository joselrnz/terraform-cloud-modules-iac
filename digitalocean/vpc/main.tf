terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.24"
    }
  }
}

resource "digitalocean_vpc" "main" {
  name     = var.vpc_name
  region   = var.region
  ip_range = var.vpc_ip_range
}
