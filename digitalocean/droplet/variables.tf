# Droplet Configuration
variable "droplet_name" {
  description = "Name of the droplet"
  type        = string
}

variable "droplet_count" {
  description = "Number of droplets to create"
  type        = number
  default     = 1
}

variable "droplet_image" {
  description = "Droplet image (e.g., ubuntu-22-04-x64)"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-2vcpu-2gb"  # $18/month: 2GB RAM, 2 CPUs, 60GB SSD, 3TB transfer
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "vpc_id" {
  description = "VPC UUID"
  type        = string
}

# SSH Configuration
variable "existing_ssh_key_name" {
  description = "Name of existing SSH key in DigitalOcean"
  type        = string
  default     = ""
}

variable "additional_ssh_keys" {
  description = "Additional SSH key IDs"
  type        = list(string)
  default     = []
}

# Droplet Features
variable "enable_monitoring" {
  description = "Enable monitoring (free)"
  type        = bool
  default     = true
}

variable "enable_backups" {
  description = "Enable backups (+20% cost)"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6"
  type        = bool
  default     = false
}

# User Data
variable "user_data" {
  description = "User data script for initialization"
  type        = string
  default     = ""
}

# Floating IP
variable "create_floating_ip" {
  description = "Create floating IP"
  type        = bool
  default     = false
}

# Volume
variable "create_volume" {
  description = "Create additional volume"
  type        = bool
  default     = false
}

variable "volume_name" {
  description = "Name of the volume"
  type        = string
  default     = "data"
}

variable "volume_size" {
  description = "Size of volume in GB"
  type        = number
  default     = 20
}

variable "volume_description" {
  description = "Volume description"
  type        = string
  default     = "Additional storage"
}

# Firewall
variable "create_firewall" {
  description = "Create firewall"
  type        = bool
  default     = true
}

variable "ssh_allowed_ips" {
  description = "IPs allowed for SSH (CHANGE THIS!)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_ips" {
  description = "IPs allowed for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "https_allowed_ips" {
  description = "IPs allowed for HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "custom_inbound_rules" {
  description = "Custom inbound firewall rules"
  type = list(object({
    protocol         = string
    port_range       = string
    source_addresses = list(string)
  }))
  default = []
}

# Tags
variable "droplet_tags" {
  description = "Tags for droplets"
  type        = list(string)
  default     = []
}

variable "firewall_tags" {
  description = "Tags for firewall"
  type        = list(string)
  default     = []
}

variable "volume_tags" {
  description = "Tags for volumes"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = list(string)
  default     = []
}

