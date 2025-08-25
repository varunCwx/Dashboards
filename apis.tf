# ==========================================
# apis.tf - Enable Required GCP APIs
# ==========================================

resource "google_project_service" "monitoring_api" {
  count   = var.enable_apis ? 1 : 0
  project = var.project_id
  service = "monitoring.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "compute_api" {
  count   = var.enable_apis ? 1 : 0
  project = var.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}

resource "google_project_service" "logging_api" {
  count   = var.enable_apis ? 1 : 0
  project = var.project_id
  service = "logging.googleapis.com"

  disable_dependent_services = false
  disable_on_destroy         = false
}