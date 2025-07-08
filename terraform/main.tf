provider "google" {
  project = var.project_id
  region  = var.region
}
 
resource "google_cloud_run_service" "demo" {
  name     = "demo-service"
  location = var.region
 
  template {
    spec {
      containers {
        image = "titoalexsta/demo-app1:latest"
        ports {
          container_port = 8081
        }
      }
    }
 
    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "3"
      }
    }
  }
 
  traffic {
    percent         = 100
    latest_revision = true
  }
}
 
resource "google_cloud_run_service_iam_member" "noauth" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_service.demo.name
 
  role   = "roles/run.invoker"
  member = "allUsers"
}