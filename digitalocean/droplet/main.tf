terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.24"
    }
  }
}

# Data source to get existing SSH key
data "digitalocean_ssh_key" "existing" {
  count = var.existing_ssh_key_name != "" ? 1 : 0
  name  = var.existing_ssh_key_name
}

# Combine SSH keys
locals {
  ssh_key_ids = concat(
    length(data.digitalocean_ssh_key.existing) > 0 ? [data.digitalocean_ssh_key.existing[0].id] : [],
    var.additional_ssh_keys
  )
}

# Droplet
resource "digitalocean_droplet" "main" {
  count = var.droplet_count
  
  name   = var.droplet_count > 1 ? "${var.droplet_name}-${count.index + 1}" : var.droplet_name
  image  = var.droplet_image
  size   = var.droplet_size
  region = var.region
  
  vpc_uuid = var.vpc_id
  ssh_keys = local.ssh_key_ids
  
  monitoring        = var.enable_monitoring
  backups           = var.enable_backups
  ipv6              = var.enable_ipv6
  droplet_agent     = true
  graceful_shutdown = true

  user_data = var.user_data != "" ? var.user_data : null
  tags      = concat(var.droplet_tags, var.common_tags)
  
  lifecycle {
    create_before_destroy = true
  }
}

# Floating IP (optional)
resource "digitalocean_floating_ip" "main" {
  count  = var.create_floating_ip ? var.droplet_count : 0
  region = var.region
}

resource "digitalocean_floating_ip_assignment" "main" {
  count      = var.create_floating_ip ? var.droplet_count : 0
  ip_address = digitalocean_floating_ip.main[count.index].ip_address
  droplet_id = digitalocean_droplet.main[count.index].id
}

# Volume (optional)
resource "digitalocean_volume" "main" {
  count = var.create_volume ? var.droplet_count : 0
  
  name                    = var.droplet_count > 1 ? "${var.volume_name}-${count.index + 1}" : var.volume_name
  region                  = var.region
  size                    = var.volume_size
  description             = var.volume_description
  initial_filesystem_type = "ext4"
  tags                    = concat(var.volume_tags, var.common_tags)
}

resource "digitalocean_volume_attachment" "main" {
  count      = var.create_volume ? var.droplet_count : 0
  droplet_id = digitalocean_droplet.main[count.index].id
  volume_id  = digitalocean_volume.main[count.index].id
}

# Firewall
resource "digitalocean_firewall" "droplet_firewall" {
  count = var.create_firewall ? 1 : 0
  
  name        = "${var.droplet_name}-firewall"
  droplet_ids = digitalocean_droplet.main[*].id
  
  # SSH - Restrict to your IP!
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_allowed_ips
  }
  
  # HTTP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = var.http_allowed_ips
  }
  
  # HTTPS
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = var.https_allowed_ips
  }
  
  # Custom rules
  dynamic "inbound_rule" {
    for_each = var.custom_inbound_rules
    content {
      protocol         = inbound_rule.value.protocol
      port_range       = inbound_rule.value.port_range
      source_addresses = inbound_rule.value.source_addresses
    }
  }
  
  # Outbound - Allow all
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
  
  tags = concat(var.firewall_tags, var.common_tags)
}
