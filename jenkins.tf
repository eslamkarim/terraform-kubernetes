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
        automount_service_account_token = "true"
        security_context {
          fs_group = "1000"
        }
        container {
          image = "eslamkarim/jenkins-ansible-kubectl:latest"
          name = "jenkins-container"
          port {
            container_port = 8080
          }
          port {
            name = "http-port"
            container_port = 8000
          }
          port {
            name = "jnlp-port"
            container_port = 50000
          }
          env {
            name = "JENKINS_OPTS"
            value = "--httpPort=8000"
          }
          volume_mount{
              name = "jenkins-storage"
              mount_path = "/var/jenkins_home"
          }
          volume_mount{
              name = "docker-sock"
              mount_path = "/var/run"
          }
        }
        volume{
            name = "jenkins-storage"
            persistent_volume_claim{
                claim_name = "jenkins-claim"
            }
        }
        volume{ 
          name= "docker-sock" 
          host_path{
              path = "/var/run"
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
      port        = 8000
      target_port = 8000
    }
    type = "NodePort"
  }
}