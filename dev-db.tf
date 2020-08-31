resource "kubernetes_deployment" "database-dev" {
  metadata {
    name = "database-dev-deployment"
    labels = {
      App = "database-dev-server"
    }
    namespace = kubernetes_namespace.dev-namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "db-dev-server"
      }
    }
    template {
      metadata {
        labels = {
          App = "db-dev-server"
        }
      }
      spec {
        security_context {
          fs_group = "1000"
        }
        container {
          image = "mysql:latest"
          name = "db-dev-container"
          port {
            container_port = 3306
          }
          env {
            name = "MYSQL_DATABASE"
            value = "vodafone-dev-db"
          }
          env {
            name = "MYSQL_USER"
            value = "dev"
          }
          env {
            name = "MYSQL_PASSWORD"
            value_from {
                secret_key_ref {
                    name = "mysql-dev-auth"
                    key = "MYSQL_PASSWORD"
                }
            }
          }
          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
                secret_key_ref {
                    name = "mysql-dev-auth"
                    key = "MYSQL_ROOT_PASSWORD"
                }
            }
          }
          volume_mount{
              name = "mysql-dev-storage"
              mount_path = "/var/lib/mysql"
          }
        }
        volume{
            name = "mysql-dev-storage"
            persistent_volume_claim{
                claim_name = "mysql-dev-claim"
            }
        }
      }
    }
  }
}

resource "kubernetes_service" "db-dev-svc" {
  metadata {
    name = "db-dev-service"
    namespace = kubernetes_namespace.dev-namespace.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.database-dev.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "ClusterIP"
  }
}