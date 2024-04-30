data "cloudflare_zones" "domain_name_zone" {
  filter {
    name = var.cloudflare_dns
  }
}

# Create DNS A record
resource "cloudflare_record" "domain_name" {
  zone_id = data.cloudflare_zones.domain_name_zone.zones.0.id
  name    = var.cluster_dns
  value   = module.kube-hetzner.ingress_public_ipv4
  type    = "A"
  ttl     = 1

  depends_on = [
    data.cloudflare_zones.domain_name_zone,
    module.kube-hetzner
  ]
}

# Create DNS A wildcard record
resource "cloudflare_record" "wildcard_domain_name" {
  zone_id = data.cloudflare_zones.domain_name_zone.zones.0.id
  name    = "*.${var.cluster_dns}"
  value   = var.cluster_dns
  type    = "CNAME"
  ttl     = 1

  depends_on = [
    data.cloudflare_zones.domain_name_zone,
    module.kube-hetzner
  ]
}

resource "kubernetes_secret" "cloudflare_api_key_secret" {
  metadata {
    name      = "cloudflare-api-key-secret"
    namespace = "cert-manager"
  }

  data = {
    API = var.cloudflare_api_token
  }

  depends_on = [
    module.kube-hetzner
  ]
}

# Create tls ingress provider
resource "kubernetes_manifest" "cluster_issuer" {
	manifest = {
		"apiVersion" = "cert-manager.io/v1"
		"kind" = "ClusterIssuer"
		"metadata" = {
			"name" = "letsencrypt-prod"
		}
		"spec" = {
		"acme" = {
			"email" = "${var.email}"
			"privateKeySecretRef" = {
			"name" = "letsencrypt-prod"
			}
			"server" = "https://acme-v02.api.letsencrypt.org/directory"
			"solvers" = [
			{
				dns01 = {
					cloudflare = {
						email = var.email
						apiTokenSecretRef = {
							name = "${kubernetes_secret.cloudflare_api_key_secret.metadata.0.name}"
							key  = "API"
						}
					},
				},
				selector = {
					dnsZones = [
						var.cloudflare_dns
					]
				}
			},
			]
		}
		}
  }
}
