resource "kubernetes_deployment" "nexus" {
  metadata {
    name = "nexus-deployment"
    labels = {
      App = "nexus-server"
    }
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "nexus-server"
      }
    }
    template {
      metadata {
        labels = {
          App = "nexus-server"
        }
      }
      spec {
        security_context {
          fs_group = "1000"
        }
        container {
          image = "sonatype/nexus3:latest"
          name = "nexus-container"
          port {
            name = "nexus-port"
            container_port = 8081
          }
          port {
            container_port = 8433
          }
          volume_mount{
              name = "nexus-storage"
              mount_path = "/nexus-data"
          }
        }
        volume{
            name = "nexus-storage"
            persistent_volume_claim{
                claim_name = "nexus-claim"
            }
        }
      }
    }
  }
}

resource "kubernetes_service" "nexus-svc" {
  metadata {
    name = "nexus-service"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nexus.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8081
      target_port = 8081
    }
    type = "NodePort"
  }
}
resource "kubernetes_service" "nexus-https" {
  metadata {
    name = "nexus-https"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nexus.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8443
      target_port = 8443
    }
    type = "NodePort"
  }
}