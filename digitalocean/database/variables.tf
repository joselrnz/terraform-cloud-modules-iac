# Database Cluster Configuration
variable "database_name" {
  description = "Name of the database cluster"
  type        = string
}

variable "database_engine" {
  description = "Database engine (pg, mysql, redis, mongodb, kafka, opensearch)"
  type        = string
  default     = "pg"
  
  validation {
    condition     = contains(["pg", "mysql", "redis", "mongodb", "kafka", "opensearch"], var.database_engine)
    error_message = "Database engine must be one of: pg, mysql, redis, mongodb, kafka, opensearch"
  }
}

variable "database_version" {
  description = "Database engine version"
  type        = string
  default     = "15"
}

variable "database_size" {
  description = "Database droplet size slug"
  type        = string
  default     = "db-s-1vcpu-1gb"
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "node_count" {
  description = "Number of nodes in the database cluster (1, 2, or 3)"
  type        = number
  default     = 1
  
  validation {
    condition     = contains([1, 2, 3], var.node_count)
    error_message = "Node count must be 1, 2, or 3"
  }
}

variable "vpc_id" {
  description = "VPC UUID to place the database in"
  type        = string
}

# Maintenance Window
variable "maintenance_window_day" {
  description = "Day of week for maintenance (monday, tuesday, etc.)"
  type        = string
  default     = "sunday"
}

variable "maintenance_window_hour" {
  description = "Hour of day for maintenance (0-23, UTC)"
  type        = string
  default     = "02:00"
}

# Firewall Rules
variable "allowed_droplet_ids" {
  description = "List of droplet IDs allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allowed_k8s_cluster_ids" {
  description = "List of Kubernetes cluster IDs allowed to access the database"
  type        = list(string)
  default     = []
}

# Additional Users
variable "additional_users" {
  description = "List of additional database users to create"
  type        = list(string)
  default     = []
}

# Additional Databases
variable "additional_databases" {
  description = "List of additional databases to create (PostgreSQL/MySQL only)"
  type        = list(string)
  default     = []
}

# Connection Pool (PostgreSQL only)
variable "create_connection_pool" {
  description = "Create a connection pool (PostgreSQL only)"
  type        = bool
  default     = false
}

variable "connection_pool_name" {
  description = "Name of the connection pool"
  type        = string
  default     = "pool"
}

variable "connection_pool_mode" {
  description = "Connection pool mode (session, transaction, statement)"
  type        = string
  default     = "transaction"
}

variable "connection_pool_size" {
  description = "Size of the connection pool"
  type        = number
  default     = 10
}

variable "connection_pool_db_name" {
  description = "Database name for connection pool (defaults to cluster database)"
  type        = string
  default     = ""
}

variable "connection_pool_user" {
  description = "User for connection pool (defaults to cluster user)"
  type        = string
  default     = ""
}

# Read Replica
variable "create_read_replica" {
  description = "Create a read replica"
  type        = bool
  default     = false
}

variable "replica_size" {
  description = "Size of the read replica (defaults to same as primary)"
  type        = string
  default     = ""
}

variable "replica_region" {
  description = "Region for read replica (defaults to same as primary)"
  type        = string
  default     = ""
}

# Tags
variable "database_tags" {
  description = "Tags specific to the database"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = list(string)
  default     = []
}

