# Droplet outputs
output "droplet_ids" {
  description = "IDs of the created droplets"
  value       = digitalocean_droplet.main[*].id
}

output "droplet_names" {
  description = "Names of the created droplets"
  value       = digitalocean_droplet.main[*].name
}

output "droplet_urns" {
  description = "URNs of the created droplets"
  value       = digitalocean_droplet.main[*].urn
}

output "droplet_regions" {
  description = "Regions of the droplets"
  value       = digitalocean_droplet.main[*].region
}

output "droplet_images" {
  description = "Images used for the droplets"
  value       = digitalocean_droplet.main[*].image
}

output "droplet_sizes" {
  description = "Sizes of the droplets"
  value       = digitalocean_droplet.main[*].size
}

output "droplet_disk_sizes" {
  description = "Disk sizes of the droplets"
  value       = digitalocean_droplet.main[*].disk
}

output "droplet_vcpus" {
  description = "Number of vCPUs for each droplet"
  value       = digitalocean_droplet.main[*].vcpus
}

output "droplet_memory" {
  description = "Memory of each droplet in MB"
  value       = digitalocean_droplet.main[*].memory
}

output "droplet_status" {
  description = "Status of the droplets"
  value       = digitalocean_droplet.main[*].status
}

# Network information
output "droplet_ipv4_addresses" {
  description = "Public IPv4 addresses of the droplets"
  value       = digitalocean_droplet.main[*].ipv4_address
}

output "droplet_ipv4_addresses_private" {
  description = "Private IPv4 addresses of the droplets"
  value       = digitalocean_droplet.main[*].ipv4_address_private
}

output "droplet_ipv6_addresses" {
  description = "IPv6 addresses of the droplets"
  value       = digitalocean_droplet.main[*].ipv6_address
}

output "droplet_vpc_uuid" {
  description = "VPC UUID of the droplets"
  value       = digitalocean_droplet.main[*].vpc_uuid
}

# SSH information
output "ssh_key_id" {
  description = "ID of the created SSH key"
  value       = var.create_ssh_key ? digitalocean_ssh_key.default[0].id : null
}

output "ssh_key_name" {
  description = "Name of the SSH key"
  value       = var.create_ssh_key ? digitalocean_ssh_key.default[0].name : var.existing_ssh_key_name
}

output "ssh_key_fingerprint" {
  description = "Fingerprint of the SSH key"
  value       = var.create_ssh_key ? digitalocean_ssh_key.default[0].fingerprint : null
}

# Floating IP information
output "floating_ip_addresses" {
  description = "Floating IP addresses"
  value       = var.create_floating_ip ? digitalocean_floating_ip.main[*].ip_address : []
}

output "floating_ip_urns" {
  description = "URNs of floating IPs"
  value       = var.create_floating_ip ? digitalocean_floating_ip.main[*].urn : []
}

# Volume information
output "volume_ids" {
  description = "IDs of the created volumes"
  value       = var.create_volume ? digitalocean_volume.main[*].id : []
}

output "volume_names" {
  description = "Names of the created volumes"
  value       = var.create_volume ? digitalocean_volume.main[*].name : []
}

output "volume_sizes" {
  description = "Sizes of the volumes in GB"
  value       = var.create_volume ? digitalocean_volume.main[*].size : []
}

output "volume_filesystem_types" {
  description = "Filesystem types of the volumes"
  value       = var.create_volume ? digitalocean_volume.main[*].filesystem_type : []
}

output "volume_droplet_ids" {
  description = "Droplet IDs that volumes are attached to"
  value       = var.create_volume ? digitalocean_volume_attachment.main[*].droplet_id : []
}

# Firewall information
output "firewall_id" {
  description = "ID of the droplet firewall"
  value       = var.create_droplet_firewall ? digitalocean_firewall.droplet_firewall[0].id : null
}

output "firewall_name" {
  description = "Name of the droplet firewall"
  value       = var.create_droplet_firewall ? digitalocean_firewall.droplet_firewall[0].name : null
}

output "firewall_status" {
  description = "Status of the droplet firewall"
  value       = var.create_droplet_firewall ? digitalocean_firewall.droplet_firewall[0].status : null
}

# Database information
output "database_id" {
  description = "ID of the database cluster"
  value       = var.create_database ? digitalocean_database_cluster.main[0].id : null
}

output "database_name" {
  description = "Name of the database cluster"
  value       = var.create_database ? digitalocean_database_cluster.main[0].name : null
}

output "database_urn" {
  description = "URN of the database cluster"
  value       = var.create_database ? digitalocean_database_cluster.main[0].urn : null
}

output "database_engine" {
  description = "Database engine"
  value       = var.create_database ? digitalocean_database_cluster.main[0].engine : null
}

output "database_version" {
  description = "Database version"
  value       = var.create_database ? digitalocean_database_cluster.main[0].version : null
}

output "database_host" {
  description = "Database host"
  value       = var.create_database ? digitalocean_database_cluster.main[0].host : null
}

output "database_port" {
  description = "Database port"
  value       = var.create_database ? digitalocean_database_cluster.main[0].port : null
}

output "database_user" {
  description = "Database user"
  value       = var.create_database ? digitalocean_database_cluster.main[0].user : null
}

output "database_password" {
  description = "Database password"
  value       = var.create_database ? digitalocean_database_cluster.main[0].password : null
  sensitive   = true
}

output "database_database" {
  description = "Database name"
  value       = var.create_database ? digitalocean_database_cluster.main[0].database : null
}

output "database_uri" {
  description = "Database connection URI"
  value       = var.create_database ? digitalocean_database_cluster.main[0].uri : null
  sensitive   = true
}

output "database_private_uri" {
  description = "Database private connection URI"
  value       = var.create_database ? digitalocean_database_cluster.main[0].private_uri : null
  sensitive   = true
}

# Connection information
output "connection_info" {
  description = "Connection information for the droplets"
  value = {
    for i, droplet in digitalocean_droplet.main : droplet.name => {
      public_ip    = droplet.ipv4_address
      private_ip   = droplet.ipv4_address_private
      floating_ip  = var.create_floating_ip ? digitalocean_floating_ip.main[i].ip_address : null
      ssh_command  = "ssh ${var.ssh_user}@${var.create_floating_ip ? digitalocean_floating_ip.main[i].ip_address : droplet.ipv4_address}"
      region       = droplet.region
      size         = droplet.size
      status       = droplet.status
    }
  }
}

# Cost estimation
output "estimated_monthly_cost" {
  description = "Estimated monthly cost for droplets and resources"
  value = {
    droplets     = "~$${var.droplet_count * (var.droplet_size == "s-1vcpu-1gb" ? 6 : var.droplet_size == "s-1vcpu-2gb" ? 12 : var.droplet_size == "s-2vcpu-2gb" ? 18 : var.droplet_size == "s-2vcpu-4gb" ? 24 : 50)} (${var.droplet_count} x ${var.droplet_size})"
    backups      = var.enable_backups ? "~$${var.droplet_count * 2} (20% of droplet cost)" : "$0 (disabled)"
    floating_ips = var.create_floating_ip ? "~$${var.droplet_count * 4} (${var.droplet_count} floating IPs)" : "$0 (none)"
    volumes      = var.create_volume ? "~$${var.droplet_count * var.volume_size * 0.10} (${var.droplet_count} x ${var.volume_size}GB)" : "$0 (none)"
    database     = var.create_database ? "~$15+ (depends on size: ${var.database_size})" : "$0 (none)"
  }
}