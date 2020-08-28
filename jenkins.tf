resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins-deployment"
    labels = {
      App = "jenkins-server"
    }
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "jenkins-server"
      }
    }
    template {
      metadata {
        labels = {
          App = "jenkins-server"
        }
      }
      spec {
        service_account_name = "jenkins-kubectl-sa"
        security_context {
          fs_group = "1000"
        }
        container {
          image = "jenkins/jenkins:alpine"
          name = "jenkins-container"
          port {
            name = "http-port"
            container_port = 8080
          }
          port {
            name = "jnlp-port"
            container_port = 50000
          }
          volume_mount{
              name = "jenkins-storage"
              mount_path = "/var/jenkins_home"
          }
        }
        init_container {
          name = "kubectl"
          image = "bitnami/kubectl:latest"
          command = ["sh","-c","kubectl proxy"]
        }
        volume{
            name = "jenkins-storage"
            persistent_volume_claim{
                claim_name = "jenkins-claim"
            }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins-svc" {
  metadata {
    name = "jenkins-service"
    namespace = kubernetes_namespace.build-namespace.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.jenkins.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "NodePort"
  }
}