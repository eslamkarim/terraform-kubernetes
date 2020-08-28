resource "kubernetes_service_account" "build-sa" {
  metadata {
    name = "jenkins-kubectl-sa"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  } 
}