resource "kubernetes_role" "jenkins-dev-role" {
  metadata {
    name = "jenkins-dev-role"
    namespace = kubernetes_namespace.dev-namespace.metadata[0].name
  }

  rule {
    api_groups     = ["*"]
    resources      = ["*"]
    verbs          = ["*"]
  }
}

resource "kubernetes_role_binding" "jenkins-dev-binding" {
  metadata {
    name      = "jenkins-dev-binding"
    namespace = kubernetes_namespace.dev-namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins-dev-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-kubectl-sa"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
}

resource "kubernetes_role" "jenkins-test-role" {
  metadata {
    name = "jenkins-test-role"
    namespace = kubernetes_namespace.test-namespace.metadata[0].name
  }

  rule {
    api_groups     = ["*"]
    resources      = ["*"]
    verbs          = ["*"]
  }
}

resource "kubernetes_role_binding" "jenkins-test-binding" {
  metadata {
    name      = "jenkins-dev-binding"
    namespace = kubernetes_namespace.test-namespace.metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "jenkins-test-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins-kubectl-sa"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
}