GCP Dashboard Terraform Module
A modular Terraform configuration for creating custom GCP monitoring dashboards by providing complete dashboard JSON configurations.

File Structure
.
├── main.tf                    # Main dashboard resource and outputs
├── variables.tf               # Input variable definitions
├── providers.tf              # Terraform and provider configuration
├── apis.tf                   # GCP API enablement
├── outputs.tf                # Output definitions
├── versions.tf               # Version constraints and backend config
├── terraform.tfvars.example  # Example dashboard configurations
└── README.md                 # This file
Features
Pure JSON Configuration: Complete dashboard JSON dumping without abstraction
Modular File Structure: Organized, maintainable Terraform files
Automatic API Enablement: Enables required GCP APIs automatically
Multiple Dashboard Support: Create multiple dashboards in one deployment
Proper Dependencies: Correct resource referencing and dependencies
Comprehensive Outputs: Dashboard URLs, IDs, and summaries
Quick Start
1. Prerequisites
bash
# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Install and configure Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
gcloud auth application-default login
2. Setup Project
bash
mkdir gcp-dashboards && cd gcp-dashboards

# Copy all the .tf files from the artifacts above
# Copy terraform.tfvars.example to terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
3. Configure Your Dashboards
Edit terraform.tfvars:

hcl
project_id = "your-actual-gcp-project-id"
region     = "us-central1"

dashboards = {
  "my-dashboard" = {
    display_name = "My Custom Dashboard"
    dashboard_json = jsonencode({
      # Your complete dashboard JSON configuration here
    })
    labels = {
      team = "your-team"
    }
  }
}
4. Deploy
bash
terraform init
terraform plan
terraform apply
Usage
Single Dashboard
hcl
dashboards = {
  "app-monitoring" = {
    display_name = "Application Monitoring"
    dashboard_json = jsonencode({
      displayName = "Application Monitoring"
      gridLayout = {
        widgets = [
          {
            width  = 12
            height = 4
            xPos   = 0
            yPos   = 0
            widget = {
              title = "Request Rate"
              xyChart = {
                # Your complete widget JSON here
              }
            }
          }
        ]
      }
    })
  }
}
Multiple Dashboards
hcl
dashboards = {
  "frontend-metrics" = {
    display_name = "Frontend Application Metrics"
    dashboard_json = jsonencode({
      # Complete frontend dashboard JSON
    })
    labels = { tier = "frontend" }
  }
  
  "backend-metrics" = {
    display_name = "Backend Service Metrics"
    dashboard_json = jsonencode({
      # Complete backend dashboard JSON
    })
    labels = { tier = "backend" }
  }
  
  "infrastructure" = {
    display_name = "Infrastructure Overview"
    dashboard_json = jsonencode({
      # Complete infrastructure dashboard JSON
    })
    labels = { tier = "infrastructure" }
  }
}
Dashboard JSON Structure
Your dashboard JSON should follow the GCP Monitoring Dashboard API format:

json
{
  "displayName": "Dashboard Name",
  "labels": {
    "key": "value"
  },
  "gridLayout": {
    "widgets": [
      {
        "width": 6,
        "height": 4,
        "xPos": 0,
        "yPos": 0,
        "widget": {
          "title": "Widget Title",
          "xyChart": {
            // Widget configuration
          }
        }
      }
    ]
  }
}
Common Widget Types
XY Chart (Time Series)
json
{
  "title": "Metric Over Time",
  "xyChart": {
    "dataSets": [{
      "timeSeriesQuery": {
        "timeSeriesFilter": {
          "filter": "resource.type=\"gce_instance\"",
          "aggregation": {
            "alignmentPeriod": "60s",
            "perSeriesAligner": "ALIGN_MEAN"
          }
        }
      },
      "targetAxis": "Y1"
    }],
    "axes": {
      "y": { "label": "Value", "scale": "LINEAR" }
    }
  }
}
Scorecard (Single Value)
json
{
  "title": "Current Value",
  "scorecard": {
    "timeSeriesQuery": {
      "timeSeriesFilter": {
        "filter": "your_metric_filter",
        "aggregation": {
          "alignmentPeriod": "300s",
          "crossSeriesReducer": "REDUCE_SUM"
        }
      }
    },
    "sparkChartView": {
      "sparkChartType": "SPARK_LINE"
    }
  }
}
Table
json
{
  "title": "Data Table",
  "table": {
    "dataSets": [{
      "timeSeriesQuery": {
        "timeSeriesFilter": {
          "filter": "your_metric_filter",
          "aggregation": {
            "groupByFields": ["resource.label.instance_id"]
          }
        }
      }
    }]
  }
}
Text Widget
json
{
  "title": "Information",
  "text": {
    "content": "# Dashboard Info\n\nThis dashboard shows **important metrics**.",
    "format": "MARKDOWN"
  }
}
Widget Positioning
Grid System: 12 columns × unlimited rows
Width: 1-12 (columns)
Height: 1-16 (rows typically)
xPos: 0-11 (horizontal position)
yPos: 0+ (vertical position)
Variables Reference
Variable	Type	Description	Default
project_id	string	GCP Project ID	Required
region	string	GCP Region	us-central1
dashboards	map(object)	Dashboard configurations	{}
enable_apis	bool	Enable required APIs	true
Outputs Reference
Output	Description
dashboard_summary	Complete dashboard information
dashboard_urls_list	List of all dashboard URLs
total_dashboards_created	Count of created dashboards
project_id	Project ID used
File Responsibilities
main.tf: Dashboard resources and main outputs
variables.tf: All input variable definitions with validation
providers.tf: Terraform and Google provider configuration
apis.tf: GCP API enablement resources
outputs.tf: All output definitions
versions.tf: Version constraints and optional backend config
terraform.tfvars: Your actual dashboard configurations (not in repo)
Getting Dashboard JSON
Method 1: GCP Console
Create a dashboard manually in GCP Console
Use gcloud CLI: gcloud monitoring dashboards list
Get dashboard: gcloud monitoring dashboards describe DASHBOARD_ID
Method 2: Export Existing
bash
gcloud monitoring dashboards describe DASHBOARD_ID --format="value(dashboard_json)" > my-dashboard.json
Method 3: Monitoring API
Use the Cloud Monitoring API to retrieve existing dashboard configurations.

Troubleshooting
Common Issues
Invalid JSON: Validate your JSON before applying
bash
terraform validate
API Not Enabled: Ensure enable_apis = true or manually enable:
bash
gcloud services enable monitoring.googleapis.com
Permissions: Ensure your account has Monitoring Editor role
Metric Filters: Verify your metric filters in GCP Metrics Explorer first
Debugging
bash
# Check dashboard JSON formatting
terraform show -json | jq '.values.root_module.resources[].values.dashboard_json'

# Validate Terraform configuration
terraform validate

# Plan without applying
terraform plan
Best Practices
Organize by Environment: Use separate tfvars files for dev/staging/prod
Use Labels: Add meaningful labels to dashboards for organization
Validate Metrics: Test metric queries in GCP Console before adding to Terraform
Version Control: Keep dashboard JSON in version control
State Management: Use remote state for team collaboration
Security
Store sensitive data in environment variables
Use least-privilege IAM roles
Consider using Workload Identity for CI/CD
Review dashboard access permissions regularly
References
GCP Monitoring Dashboard API
Terraform Google Provider
GCP Metrics Reference
