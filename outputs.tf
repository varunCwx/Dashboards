
output "project_id" {
  description = "The GCP project ID used"
  value       = var.project_id
}

output "dashboard_summary" {
  description = "Summary of all created dashboards"
  value = {
    for k, v in google_monitoring_dashboard.dashboards : k => {
      id           = v.id
      display_name = jsondecode(v.dashboard_json).displayName
      console_url  = "https://console.cloud.google.com/monitoring/dashboards/custom/${v.id}?project=${var.project_id}"
    }
  }
}

output "total_dashboards_created" {
  description = "Total number of dashboards created"
  value       = length(google_monitoring_dashboard.dashboards)
}

output "dashboard_urls_list" {
  description = "List of all dashboard URLs for easy access"
  value = [
    for k, v in google_monitoring_dashboard.dashboards : 
    "https://console.cloud.google.com/monitoring/dashboards/custom/${v.id}?project=${var.project_id}"
  ]
}