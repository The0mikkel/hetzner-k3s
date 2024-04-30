# ----------------------
# Terraform Configuration
# ----------------------

terraform {
  required_version = ">= 1.6"

  required_providers {
	kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.29.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=4.18"
    }

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.43.0"
    }
  }
}

# ----------------------
# Providers
# ----------------------

provider "hcloud" {
  token = var.hcloud_token
}

provider "kubernetes" {
	config_path = "./k3s_kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "./k3s_kubeconfig.yaml"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# ------------------------
# Variables
# ------------------------

variable "email" {
  description = "Email to use for the ACME certificate"
}

variable "hcloud_token" {
  sensitive = true
  description = "Hetzner Cloud API Token"
}

variable "ssh_key_private_path" {
  description = "SSH Key to use for the servers"
}

variable "ssh_key_public_path" {
  description = "SSH Key to use for the servers"
}

variable "ssh_extra_keys_path" {
  description = "Additional public keys to add to the servers"
  type = list(string)
  default = [ ]
}

variable "ssh_extra_keys_label" {
  description = "Label for the additional public keys to add to the servers"
  type = string
  default = "type=hetzner-k3s"
}

variable "cloudflare_api_token" {
  sensitive = true # Requires terraform >= 0.14
  type      = string
}

variable "cloudflare_dns" {
  type = string
}

variable "cluster_dns" {
  type = string
}
