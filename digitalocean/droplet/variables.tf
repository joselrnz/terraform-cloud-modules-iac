# Basic droplet configuration
variable "droplet_name" {
  description = "Name of the droplet(s)"
  type        = string
  default     = "web-server"
}

variable "droplet_count" {
  description = "Number of droplets to create"
  type        = number
  default     = 1
  
  validation {
    condition     = var.droplet_count > 0 && var.droplet_count <= 100
    error_message = "Droplet count must be between 1 and 100."
  }
}

variable "droplet_image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "droplet_size" {
  description = "Size of the droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "vpc_id" {
  description = "VPC UUID to place the droplet in"
  type        = string
}

variable "vpc_ip_range" {
  description = "IP range of the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

# SSH Configuration
variable "create_ssh_key" {
  description = "Whether to create a new SSH key"
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "Name for the SSH key"
  type        = string
  default     = "terraform-key"
}

variable "ssh_public_key" {
  description = "Public SSH key content"
  type        = string
  default     = ""
}

variable "existing_ssh_key_name" {
  description = "Name of existing SSH key in DigitalOcean"
  type        = string
  default     = ""
}

variable "additional_ssh_keys" {
  description = "List of additional SSH key IDs"
  type        = list(string)
  default     = []
}

variable "ssh_user" {
  description = "SSH user for remote provisioning"
  type        = string
  default     = "root"
}

variable "ssh_private_key" {
  description = "Private SSH key for remote provisioning"
  type        = string
  default     = ""
  sensitive   = true
}

# Droplet features
variable "enable_monitoring" {
  description = "Enable DigitalOcean monitoring"
  type        = bool
  default     = true
}

variable "enable_backups" {
  description = "Enable automatic backups"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6"
  type        = bool
  default     = false
}

variable "resize_disk" {
  description = "Allow disk resizing"
  type        = bool
  default     = true
}

variable "enable_droplet_agent" {
  description = "Enable DigitalOcean droplet agent"
  type        = bool
  default     = true
}

variable "graceful_shutdown" {
  description = "Enable graceful shutdown"
  type        = bool
  default     = true
}

# User data and provisioning
variable "user_data" {
  description = "Custom user data script"
  type        = string
  default     = ""
}

variable "install_packages" {
  description = "List of packages to install"
  type        = list(string)
  default     = ["curl", "wget", "git", "htop", "nano"]
}

variable "install_docker" {
  description = "Install Docker"
  type        = bool
  default     = false
}

variable "install_kubectl" {
  description = "Install kubectl"
  type        = bool
  default     = false
}

# Floating IP
variable "create_floating_ip" {
  description = "Create floating IP for droplet(s)"
  type        = bool
  default     = false
}

# Volume configuration
variable "create_volume" {
  description = "Create additional volume"
  type        = bool
  default     = false
}

variable "volume_name" {
  description = "Name of the volume"
  type        = string
  default     = "data-volume"
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
  default     = 20
  
  validation {
    condition     = var.volume_size >= 1 && var.volume_size <= 16384
    error_message = "Volume size must be between 1 and 16384 GB."
  }
}

variable "volume_description" {
  description = "Description of the volume"
  type        = string
  default     = "Additional storage volume"
}

variable "volume_tags" {
  description = "Tags for the volume"
  type        = list(string)
  default     = ["storage"]
}

# Firewall configuration
variable "create_droplet_firewall" {
  description = "Create firewall for droplets"
  type        = bool
  default     = true
}

variable "ssh_allowed_ips" {
  description = "IPs allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_allowed_ips" {
  description = "IPs allowed HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "https_allowed_ips" {
  description = "IPs allowed HTTPS access"
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

variable "firewall_tags" {
  description = "Tags for firewall"
  type        = list(string)
  default     = ["droplet-firewall"]
}

# Database configuration (optional)
variable "create_database" {
  description = "Create managed database"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name of the database cluster"
  type        = string
  default     = "main-db"
}

variable "database_engine" {
  description = "Database engine (postgresql, mysql, redis, mongodb)"
  type        = string
  default     = "postgresql"
  
  validation {
    condition     = contains(["postgresql", "mysql", "redis", "mongodb"], var.database_engine)
    error_message = "Database engine must be one of: postgresql, mysql, redis, mongodb."
  }
}

variable "database_version" {
  description = "Database version"
  type        = string
  default     = "15"
}

variable "database_size" {
  description = "Database node size"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "database_node_count" {
  description = "Number of database nodes"
  type        = number
  default     = 1
}

variable "database_allowed_ips" {
  description = "IPs allowed to access database"
  type        = list(string)
  default     = []
}

variable "database_tags" {
  description = "Tags for database"
  type        = list(string)
  default     = ["database"]
}

# Tagging
variable "droplet_tags" {
  description = "Tags for droplets"
  type        = list(string)
  default     = ["web-server"]
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = list(string)
  default     = ["terraform"]
}