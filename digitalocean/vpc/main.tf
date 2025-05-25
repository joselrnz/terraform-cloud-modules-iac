# terraform {
#   required_providers {
#     digitalocean = {
#       source  = "digitalocean/digitalocean"
#       version = ">= 2.24"
#     }
#   }
# }

# Main VPC resource
resource "digitalocean_vpc" "vpc" {
  name        = var.vpc_name
  region      = var.region
  description = var.vpc_description
  ip_range    = var.ip_range
}

# Optional: Create a firewall for the VPC
resource "digitalocean_firewall" "vpc_firewall" {
  count = var.create_firewall ? 1 : 0
  
  name = "${var.vpc_name}-firewall"

  # Allow SSH from specific IPs
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowed_ips
  }

  # Allow HTTP traffic
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow HTTPS traffic
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow Kubernetes API server (if needed from outside)
  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = var.k8s_api_allowed_ips
  }

  # Allow all traffic within the VPC
  inbound_rule {
    protocol    = "tcp"
    port_range  = "1-65535"
    source_addresses = [var.ip_range]
  }

  inbound_rule {
    protocol    = "udp"
    port_range  = "1-65535"
    source_addresses = [var.ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [var.ip_range]
  }

  # Allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  tags = var.firewall_tags
}

# Optional: Create a Load Balancer for Kubernetes services
resource "digitalocean_loadbalancer" "k8s_lb" {
  count = var.create_load_balancer ? 1 : 0
  
  name   = "${var.vpc_name}-k8s-lb"
  region = var.region
  vpc_uuid = digitalocean_vpc.vpc.id

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 80
  }

  forwarding_rule {
    entry_protocol  = "https"
    entry_port      = 443
    target_protocol = "http"
    target_port     = 80
    certificate_name = var.ssl_certificate_name
  }

  healthcheck {
    protocol = "http"
    port     = 80
    path     = var.healthcheck_path
  }

  # Droplet tag for automatic assignment
  droplet_tag = var.lb_droplet_tag

  redirect_http_to_https = var.redirect_http_to_https
  enable_proxy_protocol  = var.enable_proxy_protocol

  tags = var.lb_tags
}

# Optional: Reserve IP for Load Balancer
resource "digitalocean_reserved_ip" "lb_ip" {
  count  = var.create_reserved_ip ? 1 : 0
  region = var.region
  type   = "assign"
  droplet_id = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].id : null
}

# Optional: Create additional subnets for different environments
resource "digitalocean_vpc" "staging_vpc" {
  count = var.create_staging_vpc ? 1 : 0
  
  name        = "${var.vpc_name}-staging"
  region      = var.region
  description = "Staging environment VPC"
  ip_range    = var.staging_ip_range
}