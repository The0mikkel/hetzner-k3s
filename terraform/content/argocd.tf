variable "argocd_admin_password" {
  sensitive = true
  type      = string
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

module "argocd-kubernetes" {
  source         = "aigisuk/argocd/kubernetes"
  version        = ">=0.2.7"
  insecure       = true
  admin_password = var.argocd_admin_password
  namespace      = kubernetes_namespace_v1.argocd.metadata.0.name

  depends_on = [
    kubernetes_namespace_v1.argocd,
  ]
}


resource "kubernetes_ingress_v1" "argocd-ingress" {
  metadata {
    name      = "argocd-ingress"
    namespace = kubernetes_namespace_v1.argocd.metadata.0.name

    annotations = {
      "cert-manager.io/cluster-issuer" = module.cert_manager.cluster_issuer_name
    }
  }

  spec {
    default_backend {
      service {
        name = "argocd-server"
        port {
          number = 80
        }
      }
    }

    rule {
      host = "argocd.${var.cluster_dns}"
      http {
        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts = [
        "argocd.${var.cluster_dns}"
      ]

      secret_name = "argocd-cert"
    }
  }

  depends_on = [
    kubernetes_namespace_v1.argocd,
    module.argocd-kubernetes,
    module.cert_manager,
  ]
}
