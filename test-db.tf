resource "kubernetes_deployment" "database-test" {
  metadata {
    name = "database-test-deployment"
    labels = {
      App = "database-test-server"
    }
    namespace = kubernetes_namespace.test-namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "db-test-server"
      }
    }
    template {
      metadata {
        labels = {
          App = "db-test-server"
        }
      }
      spec {
        security_context {
          fs_group = "1000"
        }
        container {
          image = "mysql:latest"
          name = "db-test-container"
          port {
            container_port = 3306
          }
          env {
            name = "MYSQL_DATABASE"
            value = "vodafone-test-db"
          }
          env {
            name = "MYSQL_USER"
            value = "test"
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
                secret_key_ref {
                    name = "mysql-test-auth"
                    key = "MYSQL_PASSWORD"
                }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
                secret_key_ref {
                    name = "mysql-test-auth"
                    key = "MYSQL_ROOT_PASSWORD"
                }
            }
          }
          volume_mount{
              name = "mysql-test-storage"
              mount_path = "/var/lib/mysql"
          }
        }
        volume{
            name = "mysql-test-storage"
            persistent_volume_claim{
                claim_name = "mysql-test-claim"
            }
        }
      }
    }
  }
}

resource "kubernetes_service" "db-test-svc" {
  metadata {
    name = "db-test-service"
    namespace = kubernetes_namespace.test-namespace.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.database-test.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
}