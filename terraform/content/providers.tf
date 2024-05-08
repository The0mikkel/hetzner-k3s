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

    htpasswd = {
      source = "loafoe/htpasswd"
    }

    http = {
      source = "hashicorp/http"
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
  config_path = "../cluster/k3s_kubeconfig.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "../cluster/k3s_kubeconfig.yaml"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "http" {
}

provider "htpasswd" {
}

resource "random_password" "salt" {
  length  = 8
  special = true
}

# ------------------------
# Variables
# ------------------------

variable "email" {
  description = "Email to use for the ACME certificate"
}

variable "hcloud_token" {
  sensitive   = true
  description = "Hetzner Cloud API Token"
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

variable "traefik_namespace" {
  type    = string
  default = "traefik"
}

variable "traefik_basic_auth" {
  type = map(string)
  default = {
    "user"     = "admin"
    "password" = "admin"
  }
}
