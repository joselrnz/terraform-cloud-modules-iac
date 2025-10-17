terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.24"
    }
  }
}

# Managed Database Cluster
resource "digitalocean_database_cluster" "main" {
  name       = var.database_name
  engine     = var.database_engine
  version    = var.database_version
  size       = var.database_size
  region     = var.region
  node_count = var.node_count
  
  # Place in VPC
  private_network_uuid = var.vpc_id
  
  # Maintenance window
  maintenance_window {
    day  = var.maintenance_window_day
    hour = var.maintenance_window_hour
  }
  
  tags = concat(var.database_tags, var.common_tags)
}

# Database firewall rules
resource "digitalocean_database_firewall" "main" {
  count      = length(var.allowed_droplet_ids) > 0 || length(var.allowed_ips) > 0 ? 1 : 0
  cluster_id = digitalocean_database_cluster.main.id
  
  # Allow access from droplets
  dynamic "rule" {
    for_each = var.allowed_droplet_ids
    content {
      type  = "droplet"
      value = rule.value
    }
  }
  
  # Allow access from specific IPs
  dynamic "rule" {
    for_each = var.allowed_ips
    content {
      type  = "ip_addr"
      value = rule.value
    }
  }
  
  # Allow access from K8s clusters
  dynamic "rule" {
    for_each = var.allowed_k8s_cluster_ids
    content {
      type  = "k8s"
      value = rule.value
    }
  }
}

# Database user (optional)
resource "digitalocean_database_user" "additional_users" {
  count      = length(var.additional_users)
  cluster_id = digitalocean_database_cluster.main.id
  name       = var.additional_users[count.index]
}

# Database (optional - for PostgreSQL/MySQL)
resource "digitalocean_database_db" "additional_databases" {
  count      = length(var.additional_databases)
  cluster_id = digitalocean_database_cluster.main.id
  name       = var.additional_databases[count.index]
}

# Connection pool (optional - for PostgreSQL)
resource "digitalocean_database_connection_pool" "pool" {
  count      = var.create_connection_pool && var.database_engine == "pg" ? 1 : 0
  cluster_id = digitalocean_database_cluster.main.id
  name       = var.connection_pool_name
  mode       = var.connection_pool_mode
  size       = var.connection_pool_size
  db_name    = var.connection_pool_db_name != "" ? var.connection_pool_db_name : digitalocean_database_cluster.main.database
  user       = var.connection_pool_user != "" ? var.connection_pool_user : digitalocean_database_cluster.main.user
}

# Replica (optional)
resource "digitalocean_database_replica" "read_replica" {
  count      = var.create_read_replica ? 1 : 0
  cluster_id = digitalocean_database_cluster.main.id
  name       = "${var.database_name}-replica"
  size       = var.replica_size != "" ? var.replica_size : var.database_size
  region     = var.replica_region != "" ? var.replica_region : var.region
  
  tags = concat(var.database_tags, var.common_tags, ["replica"])
}

