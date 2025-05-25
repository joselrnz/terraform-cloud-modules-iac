output "cluster_id" {
  description = "ID of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.id
}

output "cluster_name" {
  description = "Name of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.name
}

output "cluster_urn" {
  description = "URN of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.urn
}

output "cluster_endpoint" {
  description = "Endpoint of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.endpoint
}

output "cluster_version" {
  description = "Version of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.version
}

output "cluster_region" {
  description = "Region of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.region
}

output "cluster_vpc_uuid" {
  description = "VPC UUID of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.vpc_uuid
}

output "cluster_status" {
  description = "Status of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.status
}

output "cluster_ipv4" {
  description = "Public IPv4 address of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.ipv4_address
}

output "cluster_created_at" {
  description = "Creation timestamp of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.created_at
}

output "cluster_updated_at" {
  description = "Last update timestamp of the Kubernetes cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.updated_at
}

output "kube_config" {
  description = "Kubernetes configuration for connecting to the cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.raw_config
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.cluster_ca_certificate
  sensitive   = true
}

output "client_certificate" {
  description = "Client certificate for cluster access"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Client key for cluster access"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.client_key
  sensitive   = true
}

output "token" {
  description = "Access token for the cluster"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.kube_config.0.token
  sensitive   = true
}

output "node_pool_id" {
  description = "ID of the main node pool"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.node_pool.0.id
}

output "node_pool_nodes" {
  description = "List of nodes in the main pool"
  value       = digitalocean_kubernetes_cluster.k8s_cluster.node_pool.0.nodes
}

output "additional_node_pool_id" {
  description = "ID of the additional node pool"
  value       = var.create_additional_pool ? digitalocean_kubernetes_node_pool.additional_pool[0].id : null
}

output "additional_node_pool_nodes" {
  description = "List of nodes in the additional pool"
  value       = var.create_additional_pool ? digitalocean_kubernetes_node_pool.additional_pool[0].nodes : null
}

