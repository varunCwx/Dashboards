# GCP Dashboard Accelerators

A Terraform module for deploying pre-built GCP monitoring dashboards with comprehensive metrics for Compute Engine and GKE resources.

## What This Provides

Ready-to-use monitoring dashboards for:
- **Compute Engine**: CPU, disk I/O, network traffic, uptime monitoring
- **GKE Clusters**: Node resources, container utilization, pod metrics, storage usage

## Prerequisites

### Required Tools
```bash
# Terraform (>= 1.0)
terraform --version

# Google Cloud SDK
gcloud --version
```

### GCP Setup

1. **Enable Required APIs**
   ```bash
   # Enable APIs manually (or set enable_apis = true in terraform.tfvars)
   gcloud services enable monitoring.googleapis.com
   gcloud services enable compute.googleapis.com  
   gcloud services enable logging.googleapis.com
   ```

2. **Service Account & Permissions**

   **Option A: Using Application Default Credentials (Recommended for development)**
   ```bash
   gcloud auth application-default login
   ```
   Your user account needs these roles:
   - `roles/monitoring.editor` - Create and manage dashboards
   - `roles/serviceusage.serviceUsageAdmin` - Enable APIs (if using `enable_apis = true`)

   **Option B: Using Service Account (Recommended for production)**
   ```bash
   # Create service account
   gcloud iam service-accounts create dashboard-terraform \
     --display-name="Dashboard Terraform Service Account"

   # Grant required roles
   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:dashboard-terraform@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/monitoring.editor"

   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:dashboard-terraform@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/serviceusage.serviceUsageAdmin"

   # Create and download key
   gcloud iam service-accounts keys create dashboard-key.json \
     --iam-account=dashboard-terraform@YOUR_PROJECT_ID.iam.gserviceaccount.com

   # Set environment variable
   export GOOGLE_APPLICATION_CREDENTIALS="./dashboard-key.json"
   ```

3. **Verify Access**
   ```bash
   # Test API access
   gcloud monitoring dashboards list --project=YOUR_PROJECT_ID
   ```

## Quick Start

1. **Deploy with Defaults**
   ```bash
   # Set your project
   export TF_VAR_project_id="your-gcp-project-id"
   
   # Deploy with defaults (compute + gke dashboards)
   terraform init
   terraform apply
   ```

2. **Custom Configuration**
   ```hcl
   # terraform.tfvars
   project_id = "your-project-id"
   enabled_dashboards = ["compute"]  # Deploy only compute dashboard
   enable_apis = false              # If APIs already enabled
   ```

## Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_id` | GCP Project ID | Required |
| `enabled_dashboards` | Dashboards to deploy | `["compute", "gke"]` |
| `region` | GCP region | `us-central1` |
| `enable_apis` | Auto-enable monitoring APIs | `true` |

### Available Dashboards

- **compute**: GCE VM monitoring (CPU, disk, network, uptime)
- **gke**: Kubernetes cluster monitoring (nodes, containers, pods)

## Dashboard Details

### Compute Dashboard
Monitors GCE instances with widgets for:
- CPU utilization and uptime
- Disk read/write operations and bytes
- Network packets and bytes (sent/received)

### GKE Dashboard
Monitors Kubernetes clusters with widgets for:
- Node CPU cores (total, request, allocatable)
- Node memory usage and allocation
- Container CPU/memory limits and utilization
- Pod network traffic and volume usage
- Container restart counts

## Outputs

Access your dashboards via:
```bash
terraform output dashboard_urls_list
```

## File Structure
```
├── main.tf           # Dashboard resources
├── variables.tf      # Input variables
├── providers.tf      # Provider configuration
├── apis.tf          # API enablement
├── outputs.tf       # Output definitions
└── dashboards/      # Pre-built dashboard JSON
    ├── compute.json # GCE monitoring
    └── gke.json     # GKE monitoring
```

## Extending

To add custom dashboards:
1. Create JSON file in `dashboards/` directory
2. Add entry to `all_dashboards` in `main.tf`
3. Update `enabled_dashboards` variable options
