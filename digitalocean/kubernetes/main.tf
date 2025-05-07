terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.24"
    }
  }
}


resource "digitalocean_kubernetes_cluster" "this" {
  name    = var.cluster_name
  region  = var.region
  version = var.kubernetes_version

  vpc_uuid = var.vpc_id

  node_pool {
    name       = "default-pool"
    size       = var.node_size
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    auto_scale = true
  }

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  tags = ["terraform", var.cluster_name]
}
