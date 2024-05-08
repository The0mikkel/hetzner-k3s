resource "helm_release" "prometheus" {
  name = "prometheus"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}

resource "kubernetes_ingress_v1" "grafana-ingress" {
  metadata {
    name      = "grafana-ingress"
    namespace = "default"

    annotations = {
      "cert-manager.io/cluster-issuer" = module.cert_manager.cluster_issuer_name
    }
  }

  spec {
    default_backend {
      service {
        name = "prometheus-grafana"
        port {
          number = 80
        }
      }
    }

    rule {
      host = "grafana.${var.cluster_dns}"
      http {
        path {
          backend {
            service {
              name = "prometheus-grafana"
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
        "grafana.${var.cluster_dns}"
      ]
      secret_name = "grafana-ingress-tls-cert"
    }
  }
}
