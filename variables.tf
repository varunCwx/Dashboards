variable "project_id" {
  description = "The GCP project ID where dashboards will be created"
  type        = string
}

variable "region" {
  description = "The GCP region for resources "
  type        = string
  default     = "us-central1"
}


variable "enabled_dashboards" {
  description = "List of dashboards to enable (choices: compute, network, gke, cloudrun, etc.)"
  type        = list(string)
  default     = ["compute", "gke"] 
}



variable "enable_apis" {
  description = "Whether to automatically enable required GCP APIs (monitoring.googleapis.com)"
  type        = bool
  default     = true
}