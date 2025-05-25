# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = ">= 2.24"
#     }
#   }
# }

 Main Kubernetes cluster resource
resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name     = var.cluster_name
  region   = var.region
  version  = var.k8s_version
  vpc_uuid = var.vpc_id

  # High availability control plane (optional but recommended for production)
  ha = var.enable_ha

  # Auto-upgrade settings
  auto_upgrade = var.auto_upgrade
  
  # Surge upgrade settings
  surge_upgrade = var.surge_upgrade

  # Main node pool
  node_pool {
    name       = var.pool_name
    size       = var.node_size
    node_count = var.node_count
    
    # Auto-scaling configuration
    auto_scale = var.enable_autoscale
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
    
    # Labels and taints
    labels = var.node_labels
    tags   = var.node_tags
  }

  # Maintenance window
  maintenance_policy {
    start_time = var.maintenance_start_time
    day        = var.maintenance_day
  }

  # Cluster tags
  tags = var.cluster_tags
}

# Additional node pool (optional)
resource "digitalocean_kubernetes_node_pool" "additional_pool" {
  count = var.create_additional_pool ? 1 : 0
  
  cluster_id = digitalocean_kubernetes_cluster.k8s_cluster.id
  name       = var.additional_pool_name
  size       = var.additional_pool_size
  node_count = var.additional_pool_count
  
  auto_scale = var.additional_pool_autoscale
  min_nodes  = var.additional_pool_min_nodes
  max_nodes  = var.additional_pool_max_nodes
  
  labels = var.additional_pool_labels
  tags   = var.additional_pool_tags
}