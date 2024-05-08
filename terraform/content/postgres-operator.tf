resource "kubernetes_namespace_v1" "postgres" {
  metadata {
    name = "postgres"
  }
}

resource "helm_release" "postgres-operator" {
  name       = "postgres-operator"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator"
  namespace  = kubernetes_namespace_v1.postgres.metadata.0.name

  chart = "postgres-operator"
}

resource "helm_release" "postgres-operator-ui" {
  name       = "postgres-operator-ui"
  repository = "https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui"
  namespace  = kubernetes_namespace_v1.postgres.metadata.0.name

  chart = "postgres-operator-ui"

  # Ingress
  set {
    name  = "ingress.enabled"
    value = "true"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "postgres-operator-ui.${var.cluster_dns}"
    type  = "string"
  }

  set {
    name  = "ingress.hosts[0].paths[0]"
    value = "/"
    type  = "string"
  }

  set {
    name  = "ingress.tls[0].hosts[0]"
    value = "postgres-operator-ui.${var.cluster_dns}"
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "postgres-operator-ui-tls"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = module.cert_manager.cluster_issuer_name
    type  = "string"
  }

  set {
    name  = "ingress.annotations.ingress\\.kubernetes\\.io/auth-realm"
    value = "traefik"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.ingress\\.kubernetes\\.io/auth-secret"
    value = kubernetes_secret.traefik_basic_auth.metadata.0.name
    type  = "string"
  }

  # Traefik basic auth middleware
  set {
    name  = "ingress.annotations.spec\\.ingressClassName"
    value = "traefik"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.traefik\\.ingress\\.kubernetes\\.io/router\\.middlewares"
    value = "${var.traefik_namespace}-${kubernetes_secret.traefik_basic_auth.metadata.0.name}@kubernetescrd"
    type  = "string"
  }

  set {
    name  = "ingress.annotations.ingress\\.kubernetes\\.io/auth-type"
    value = "basic"
    type  = "string"
  }

  depends_on = [
    helm_release.postgres-operator,
    kubernetes_secret.traefik_basic_auth,
  ]
}
