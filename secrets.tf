resource "kubernetes_secret" "db-dev-secrets" {
  metadata {
    name = "mysql-dev-auth"
    namespace = kubernetes_namespace.dev-namespace.metadata[0].name
  }

  data = {
    MYSQL_PASSWORD = "123456"
    MYSQL_ROOT_PASSWORD = "123456a"
  }

  type = "kubernetes.io/generic"
}
resource "kubernetes_secret" "db-test-secrets" {
  metadata {
    name = "mysql-test-auth"
    namespace = kubernetes_namespace.test-namespace.metadata[0].name

  }

  data = {
    MYSQL_PASSWORD = "123456"
    MYSQL_ROOT_PASSWORD = "123456a"
  }

  type = "kubernetes.io/generic"
}