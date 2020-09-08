# resource "kubernetes_persistent_volume" "jenkins-pv" {
#   metadata {
#     name = "jenkins-pv"
#   }
#   spec {
#     capacity = {
#       storage = "5Gi"
#     }
    
#     storage_class_name = "manual"
#     access_modes = ["ReadWriteOnce"]
#     persistent_volume_source {
#       host_path {
#         path = "/jenkins-host"
#         type = "DirectoryOrCreate"
#       }
#     }
#   }
# }

# resource "kubernetes_persistent_volume" "nexus-pv" {
#   metadata {
#     name = "nexus-pv"
#   }
#   spec {
#     capacity = {
#       storage = "1Gi"
#     }
    
#     storage_class_name = "manual"
#     access_modes = ["ReadWriteOnce"]
#     persistent_volume_source {
#       host_path {
#         path = "/nexus-data"
#         type = "DirectoryOrCreate"
#       }
#     }
#   }
# }