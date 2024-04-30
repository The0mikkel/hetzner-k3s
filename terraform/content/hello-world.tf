# ----------------------
# Hello world example
# ----------------------

# Namespace
resource "kubernetes_namespace" "hello-world" {
  metadata {
    name = "hello-world"
  }
}

# Ingress
resource "kubernetes_ingress_v1" "hello-world" {
  metadata {
    name      = "hello-world-ingress"
    namespace = kubernetes_namespace.hello-world.metadata.0.name

    annotations = {
      "cert-manager.io/cluster-issuer" = module.cert_manager.cluster_issuer_name
    }
  }

  spec {
    default_backend {
      service {
        name = kubernetes_service_v1.hello-world.metadata.0.name
        port {
          number = 80
        }
      }
    }

    rule {
      host = "demo.${var.cluster_dns}"
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service_v1.hello-world.metadata.0.name
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
        "demo.${var.cluster_dns}"
      ]

      secret_name = "hello-world-cert"
    }
  }

  depends_on = [
    kubernetes_namespace.hello-world,
    kubernetes_service_v1.hello-world,
    module.cert_manager,
  ]
}

# Service
resource "kubernetes_service_v1" "hello-world" {
  metadata {
    name      = "hello-world"
    namespace = kubernetes_namespace.hello-world.metadata.0.name
  }

  spec {
    selector = {
      app = "hello-world"
    }

    port {
      port        = 80
      target_port = 5678
    }
  }

  depends_on = [
    kubernetes_deployment_v1.hello-world
  ]
}

# Deployment
resource "kubernetes_deployment_v1" "hello-world" {
  metadata {
    name      = "hello-world"
    namespace = kubernetes_namespace.hello-world.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello-world"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-world"
        }
      }

      spec {
        container {
          name  = "hello-world"
          image = "hashicorp/http-echo"
          args = [
            "-text=Hello, World!"
          ]

          port {
            container_port = 5678
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.hello-world
  ]
}
