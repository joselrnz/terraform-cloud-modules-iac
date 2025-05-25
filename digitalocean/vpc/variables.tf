# Basic VPC configuration
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "vpc_description" {
  description = "Description of the VPC"
  type        = string
  default     = "Main VPC for infrastructure"
}

variable "ip_range" {
  description = "IP range for the VPC in CIDR notation"
  type        = string
  default     = "10.10.0.0/16"
  
  validation {
    condition = can(cidrhost(var.ip_range, 0))
    error_message = "IP range must be a valid CIDR notation."
  }
}

# Firewall configuration
variable "create_firewall" {
  description = "Whether to create a firewall for the VPC"
  type        = bool
  default     = true
}

variable "ssh_allowed_ips" {
  description = "List of IP addresses allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your specific IPs for security
}

variable "k8s_api_allowed_ips" {
  description = "List of IP addresses allowed to access Kubernetes API"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your specific IPs for security
}

variable "firewall_tags" {
  description = "Tags to apply to the firewall"
  type        = list(string)
  default     = ["vpc-firewall", "kubernetes"]
}

# Load Balancer configuration
variable "create_load_balancer" {
  description = "Whether to create a load balancer"
  type        = bool
  default     = false
}

variable "ssl_certificate_name" {
  description = "Name of the SSL certificate for HTTPS"
  type        = string
  default     = ""
}

variable "healthcheck_path" {
  description = "Path for load balancer health checks"
  type        = string
  default     = "/"
}

variable "lb_droplet_tag" {
  description = "Tag to identify droplets for load balancer"
  type        = string
  default     = "k8s-worker"
}

variable "redirect_http_to_https" {
  description = "Whether to redirect HTTP traffic to HTTPS"
  type        = bool
  default     = true
}

variable "enable_proxy_protocol" {
  description = "Whether to enable proxy protocol"
  type        = bool
  default     = false
}

variable "lb_tags" {
  description = "Tags to apply to the load balancer"
  type        = list(string)
  default     = ["kubernetes", "load-balancer"]
}

# Reserved IP configuration
variable "create_reserved_ip" {
  description = "Whether to create a reserved IP for the load balancer"
  type        = bool
  default     = false
}

# Staging environment
variable "create_staging_vpc" {
  description = "Whether to create a separate staging VPC"
  type        = bool
  default     = false
}

variable "staging_ip_range" {
  description = "IP range for staging VPC"
  type        = string
  default     = "10.20.0.0/16"
  
  validation {
    condition = can(cidrhost(var.staging_ip_range, 0))
    error_message = "Staging IP range must be a valid CIDR notation."
  }
}

# Common tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = list(string)
  default     = ["terraform", "infrastructure"]
}