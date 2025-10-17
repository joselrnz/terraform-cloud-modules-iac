# Database Cluster Outputs
output "database_id" {
  description = "ID of the database cluster"
  value       = digitalocean_database_cluster.main.id
}

output "database_urn" {
  description = "URN of the database cluster"
  value       = digitalocean_database_cluster.main.urn
}

output "database_name" {
  description = "Name of the database cluster"
  value       = digitalocean_database_cluster.main.name
}

output "database_engine" {
  description = "Database engine"
  value       = digitalocean_database_cluster.main.engine
}

output "database_version" {
  description = "Database version"
  value       = digitalocean_database_cluster.main.version
}

output "database_host" {
  description = "Database host"
  value       = digitalocean_database_cluster.main.host
  sensitive   = true
}

output "database_private_host" {
  description = "Database private host (VPC)"
  value       = digitalocean_database_cluster.main.private_host
  sensitive   = true
}

output "database_port" {
  description = "Database port"
  value       = digitalocean_database_cluster.main.port
}

output "database_user" {
  description = "Default database user"
  value       = digitalocean_database_cluster.main.user
  sensitive   = true
}

output "database_password" {
  description = "Default database password"
  value       = digitalocean_database_cluster.main.password
  sensitive   = true
}

output "database_default_db" {
  description = "Default database name"
  value       = digitalocean_database_cluster.main.database
}

output "database_uri" {
  description = "Database connection URI"
  value       = digitalocean_database_cluster.main.uri
  sensitive   = true
}

output "database_private_uri" {
  description = "Database private connection URI (VPC)"
  value       = digitalocean_database_cluster.main.private_uri
  sensitive   = true
}

# Connection Pool Outputs
output "connection_pool_id" {
  description = "ID of the connection pool"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].id : null
}

output "connection_pool_name" {
  description = "Name of the connection pool"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].name : null
}

output "connection_pool_host" {
  description = "Connection pool host"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].host : null
  sensitive   = true
}

output "connection_pool_private_host" {
  description = "Connection pool private host (VPC)"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].private_host : null
  sensitive   = true
}

output "connection_pool_port" {
  description = "Connection pool port"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].port : null
}

output "connection_pool_uri" {
  description = "Connection pool URI"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].uri : null
  sensitive   = true
}

output "connection_pool_private_uri" {
  description = "Connection pool private URI (VPC)"
  value       = var.create_connection_pool && var.database_engine == "pg" ? digitalocean_database_connection_pool.pool[0].private_uri : null
  sensitive   = true
}

# Read Replica Outputs
output "replica_id" {
  description = "ID of the read replica"
  value       = var.create_read_replica ? digitalocean_database_replica.read_replica[0].id : null
}

output "replica_host" {
  description = "Read replica host"
  value       = var.create_read_replica ? digitalocean_database_replica.read_replica[0].host : null
  sensitive   = true
}

output "replica_private_host" {
  description = "Read replica private host (VPC)"
  value       = var.create_read_replica ? digitalocean_database_replica.read_replica[0].private_host : null
  sensitive   = true
}

output "replica_uri" {
  description = "Read replica connection URI"
  value       = var.create_read_replica ? digitalocean_database_replica.read_replica[0].uri : null
  sensitive   = true
}

output "replica_private_uri" {
  description = "Read replica private connection URI (VPC)"
  value       = var.create_read_replica ? digitalocean_database_replica.read_replica[0].private_uri : null
  sensitive   = true
}

# Convenience Outputs
output "connection_info" {
  description = "Database connection information"
  value = {
    host         = digitalocean_database_cluster.main.private_host
    port         = digitalocean_database_cluster.main.port
    database     = digitalocean_database_cluster.main.database
    user         = digitalocean_database_cluster.main.user
    password     = digitalocean_database_cluster.main.password
    uri          = digitalocean_database_cluster.main.private_uri
    engine       = digitalocean_database_cluster.main.engine
    version      = digitalocean_database_cluster.main.version
  }
  sensitive = true
}

