# Kubernetes Droplet Cluster Module (Alternative)

**Note:** This module is an alternative Kubernetes cluster configuration. It has the same functionality as the `../kubernetes/` module.

## Purpose

This module creates a managed DigitalOcean Kubernetes cluster. It's functionally identical to the `../kubernetes/` module and was originally named `droplet/` but has been renamed to avoid confusion with the standalone droplet (VM) module.

## Recommendation

**Use `../kubernetes/` module instead** - it's the primary Kubernetes module with the same features.

This module is kept for reference or if you need to deploy multiple Kubernetes clusters with different configurations.

## Features

- Managed Kubernetes cluster
- Auto-scaling node pools
- High availability control plane option
- Auto-upgrade configuration
- Maintenance window scheduling

## Quick Start

```bash
cd ../vpc
terraform apply
terraform output vpc_id  # Save this

cd ../kubernetes-droplet-cluster
cp terraform.tfvars.example terraform.tfvars
# Edit with VPC UUID

terraform init
terraform plan
terraform apply
```

## Related Modules

- **VPC** (`../vpc/`) - Deploy first
- **Kubernetes** (`../kubernetes/`) - Primary K8s module (recommended)
- **Droplet** (`../droplet/`) - For standalone VMs

