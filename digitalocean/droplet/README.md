# DigitalOcean Droplet Module

Clean, secure droplet deployment module.

## Features

-  Droplet creation with SSH key
-  VPC integration
-  Firewall with SSH, HTTP, HTTPS
-  Optional floating IP
-  Optional block storage
-  Monitoring enabled by default

## Usage

```hcl
module "droplet" {
  source = "./digitalocean/droplet"
  
  droplet_name = "my-server"
  droplet_size = "s-2vcpu-2gb"
  region       = "nyc1"
  vpc_id       = "vpc-12345..."
  
  existing_ssh_key_name = "my-ssh-key"
  
  # Security: Restrict SSH to your IP!
  ssh_allowed_ips = ["YOUR_IP/32"]
  
  # Custom ports
  custom_inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "5678"
      source_addresses = ["0.0.0.0/0"]
    }
  ]
  
  common_tags = ["production", "web"]
}
```

## Security

 **IMPORTANT**: Always restrict SSH access!

```hcl
ssh_allowed_ips = ["YOUR_IP/32"]  # Not 0.0.0.0/0!
```

## After Deployment

SSH into your droplet and install packages manually:

```bash
ssh root@<DROPLET_IP>

# Update system
apt update && apt upgrade -y

# Install what you need
apt install -y docker.io
```

## Outputs

- `droplet_ipv4_addresses` - Public IPs
- `droplet_ipv4_addresses_private` - Private IPs
- `firewall_id` - Firewall ID
