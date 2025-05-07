variable "vpc_id" {}
variable "region" {}
variable "cluster_name" {}
variable "kubernetes_version" {}
variable "high_availability" {}
variable "node_size" {}
variable "min_nodes" {}
variable "max_nodes" {}
variable "spaces_bucket_name" {}
variable "spaces_access_key" {}
variable "spaces_secret_key" {}
variable "application_namespaces" {
  type = list(string)
}
variable "enable_ssl" {}
variable "domain_name" {}
variable "admin_email" {}
