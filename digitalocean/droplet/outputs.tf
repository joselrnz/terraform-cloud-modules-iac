# Droplet Outputs
output "droplet_ids" {
  description = "IDs of the droplets"
  value       = digitalocean_droplet.main[*].id
}

output "droplet_names" {
  description = "Names of the droplets"
  value       = digitalocean_droplet.main[*].name
}

output "droplet_ipv4_addresses" {
  description = "Public IPv4 addresses"
  value       = digitalocean_droplet.main[*].ipv4_address
}

output "droplet_ipv4_addresses_private" {
  description = "Private IPv4 addresses"
  value       = digitalocean_droplet.main[*].ipv4_address_private
}

output "droplet_urns" {
  description = "URNs of the droplets"
  value       = digitalocean_droplet.main[*].urn
}

# Floating IP Outputs
output "floating_ip_addresses" {
  description = "Floating IP addresses"
  value       = var.create_floating_ip ? digitalocean_floating_ip.main[*].ip_address : []
}

# Volume Outputs
output "volume_ids" {
  description = "Volume IDs"
  value       = var.create_volume ? digitalocean_volume.main[*].id : []
}

# Firewall Outputs
output "firewall_id" {
  description = "Firewall ID"
  value       = var.create_firewall ? digitalocean_firewall.droplet_firewall[0].id : null
}

output "firewall_name" {
  description = "Firewall name"
  value       = var.create_firewall ? digitalocean_firewall.droplet_firewall[0].name : null
}

