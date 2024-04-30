# ------------------------
# Hetzner
# ------------------------
hcloud_token="<token>"

# ------------------------
# SSH
# ------------------------
ssh_key_private_path="~/.ssh/hetzner-k3s"
ssh_key_public_path="~/.ssh/hetzner-k3s.pub"

# ------------------------
# Cloudflare variables
# ------------------------
cloudflare_api_token = "<token>"        # Cloudflare API Token for updating the DNS records
cloudflare_dns       = "<dns>" # The domain name to use for the DNS records

# ------------------------
# Generic information
# ------------------------
cluster_dns = "<dns>" # The domain name to use for the DNS records
email = "<email>" # Email to use for the ACME certificate

# ----------------------
# ArgoCD configuration
# ----------------------
argocd_admin_password = "<password>" # The password for the ArgoCD admin user