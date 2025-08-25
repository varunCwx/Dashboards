



locals {
  all_dashboards = {
    compute = {
      dashboard_json = file("${path.module}/dashboards/compute.json")
    }

    # This is a placeholder -> network = {
    #   dashboard_json = file("${path.module}/dashboards/network.json")
    # }

    gke = {
      dashboard_json = file("${path.module}/dashboards/gke.json")
    }

    # This is a placeholder -> cloudrun = {
    #   dashboard_json = file("${path.module}/dashboards/cloudrun.json")
    # }
  }

  # filter only what’s in var.enabled_dashboards
  dashboards = {
    for k, v in local.all_dashboards : k => v
    if contains(var.enabled_dashboards, k)
  }
}


resource "google_monitoring_dashboard" "dashboards" {
  for_each       = local.dashboards
  project        = var.project_id
  dashboard_json = each.value.dashboard_json
  
}




