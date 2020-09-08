resource "kubernetes_persistent_volume_claim" "jenkins-pv-claim" {
  metadata {
    name = "jenkins-claim"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "nexus-pv-claim" {
  metadata {
    name = "nexus-claim"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
# resource "kubernetes_persistent_volume_claim" "mysql-test-pv-claim" {
#   metadata {
#     name = "mysql-test-claim"
#     namespace = kubernetes_namespace.test-namespace.metadata[0].name
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "0.5Gi"
#       }
#     }
#   }
# }
# resource "kubernetes_persistent_volume_claim" "mysql-dev-pv-claim" {
#   metadata {
#     name = "mysql-dev-claim"
#     namespace = kubernetes_namespace.dev-namespace.metadata[0].name
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "0.5Gi"
#       }
#     }
#   }
# }