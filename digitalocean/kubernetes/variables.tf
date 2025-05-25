


# Basic cluster configuration
variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "my-k8s-cluster"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.32.2-do.1"
}

variable "vpc_id" {
  description = "VPC UUID"
  type        = string
  default     = null
}

# High availability and upgrade settings
variable "enable_ha" {
  description = "Enable high availability control plane"
  type        = bool
  default     = false
}

variable "auto_upgrade" {
  description = "Enable auto-upgrade for the cluster"
  type        = bool
  default     = false
}

variable "surge_upgrade" {
  description = "Enable surge upgrade"
  type        = bool
  default     = false
}

# Main node pool configuration
variable "pool_name" {
  description = "Name of the main node pool"
  type        = string
  default     = "main-pool"
}

variable "node_size" {
  description = "Size of the nodes (droplet size)"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "node_count" {
  description = "Number of nodes in the main pool"
  type        = number
  default     = 2
}

# Auto-scaling configuration
variable "enable_autoscale" {
  description = "Enable auto-scaling for the main node pool"
  type        = bool
  default     = false
}

variable "min_nodes" {
  description = "Minimum number of nodes when auto-scaling is enabled"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of nodes when auto-scaling is enabled"
  type        = number
  default     = 5
}

# Node labeling and tagging
variable "node_labels" {
  description = "Labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Tags to apply to nodes"
  type        = list(string)
  default     = []
}

variable "cluster_tags" {
  description = "Tags to apply to the cluster"
  type        = list(string)
  default     = []
}

# Maintenance window
variable "maintenance_start_time" {
  description = "Start time for maintenance window (HH:MM format)"
  type        = string
  default     = "04:00"
}

variable "maintenance_day" {
  description = "Day of the week for maintenance (monday, tuesday, etc.)"
  type        = string
  default     = "sunday"
}

# Additional node pool configuration
variable "create_additional_pool" {
  description = "Whether to create an additional node pool"
  type        = bool
  default     = false
}

variable "additional_pool_name" {
  description = "Name of the additional node pool"
  type        = string
  default     = "additional-pool"
}

variable "additional_pool_size" {
  description = "Size of nodes in the additional pool"
  type        = string
  default     = "s-4vcpu-8gb"
}

variable "additional_pool_count" {
  description = "Number of nodes in the additional pool"
  type        = number
  default     = 1
}

variable "additional_pool_autoscale" {
  description = "Enable auto-scaling for additional pool"
  type        = bool
  default     = false
}

variable "additional_pool_min_nodes" {
  description = "Minimum nodes for additional pool auto-scaling"
  type        = number
  default     = 1
}

variable "additional_pool_max_nodes" {
  description = "Maximum nodes for additional pool auto-scaling"
  type        = number
  default     = 3
}

variable "additional_pool_labels" {
  description = "Labels for additional pool nodes"
  type        = map(string)
  default     = {}
}

variable "additional_pool_tags" {
  description = "Tags for additional pool nodes"
  type        = list(string)
  default     = []
}