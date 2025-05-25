# VPC outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = digitalocean_vpc.vpc.id
}

output "vpc_urn" {
  description = "URN of the VPC"
  value       = digitalocean_vpc.vpc.urn
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = digitalocean_vpc.vpc.name
}

output "vpc_ip_range" {
  description = "IP range of the VPC"
  value       = digitalocean_vpc.vpc.ip_range
}

output "vpc_region" {
  description = "Region of the VPC"
  value       = digitalocean_vpc.vpc.region
}

output "vpc_description" {
  description = "Description of the VPC"
  value       = digitalocean_vpc.vpc.description
}

output "vpc_default" {
  description = "Whether this is the default VPC"
  value       = digitalocean_vpc.vpc.default
}

output "vpc_created_at" {
  description = "Creation timestamp of the VPC"
  value       = digitalocean_vpc.vpc.created_at
}

# Firewall outputs
output "firewall_id" {
  description = "ID of the VPC firewall"
  value       = var.create_firewall ? digitalocean_firewall.vpc_firewall[0].id : null
}

output "firewall_name" {
  description = "Name of the VPC firewall"
  value       = var.create_firewall ? digitalocean_firewall.vpc_firewall[0].name : null
}

output "firewall_status" {
  description = "Status of the VPC firewall"
  value       = var.create_firewall ? digitalocean_firewall.vpc_firewall[0].status : null
}

# Load Balancer outputs
output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].id : null
}

output "load_balancer_name" {
  description = "Name of the load balancer"
  value       = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].name : null
}

output "load_balancer_ip" {
  description = "IP address of the load balancer"
  value       = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].ip : null
}

output "load_balancer_status" {
  description = "Status of the load balancer"
  value       = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].status : null
}

output "load_balancer_urn" {
  description = "URN of the load balancer"
  value       = var.create_load_balancer ? digitalocean_loadbalancer.k8s_lb[0].urn : null
}

# Reserved IP outputs
output "reserved_ip_address" {
  description = "Reserved IP address"
  value       = var.create_reserved_ip ? digitalocean_reserved_ip.lb_ip[0].ip_address : null
}

output "reserved_ip_urn" {
  description = "URN of the reserved IP"
  value       = var.create_reserved_ip ? digitalocean_reserved_ip.lb_ip[0].urn : null
}

# Staging VPC outputs
output "staging_vpc_id" {
  description = "ID of the staging VPC"
  value       = var.create_staging_vpc ? digitalocean_vpc.staging_vpc[0].id : null
}

output "staging_vpc_ip_range" {
  description = "IP range of the staging VPC"
  value       = var.create_staging_vpc ? digitalocean_vpc.staging_vpc[0].ip_range : null
}

# Network information for Kubernetes
output "network_info" {
  description = "Network information useful for Kubernetes configuration"
  value = {
    vpc_id       = digitalocean_vpc.vpc.id
    vpc_ip_range = digitalocean_vpc.vpc.ip_range
    region       = digitalocean_vpc.vpc.region
    
    # Suggested pod and service networks that don't overlap with VPC
    suggested_pod_network     = "10.244.0.0/16"
    suggested_service_network = "10.96.0.0/12"
    
    # Network boundaries
    vpc_network_start = cidrhost(digitalocean_vpc.vpc.ip_range, 0)
    vpc_network_end   = cidrhost(digitalocean_vpc.vpc.ip_range, pow(2, 32 - split("/", digitalocean_vpc.vpc.ip_range)[1]) - 1)
  }
}