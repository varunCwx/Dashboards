# GCP Dashboard Accelerators

A Terraform module for deploying pre-built GCP monitoring dashboards with comprehensive metrics for Compute Engine and GKE resources.

## What This Provides

Ready-to-use monitoring dashboards for:
- **Compute Engine**: CPU, disk I/O, network traffic, uptime monitoring
- **GKE Clusters**: Node resources, container utilization, pod metrics, storage usage

## Quick Start

1. **Prerequisites**
   ```bash
   # Ensure Terraform and gcloud are installed
   terraform --version
   gcloud auth application-default login
   ```

2. **Deploy**
   ```bash
   # Set your project
   export TF_VAR_project_id="your-gcp-project-id"
   
   # Deploy with defaults (compute + gke dashboards)
   terraform init
   terraform apply
   ```

3. **Custom Selection**
   ```hcl
   # terraform.tfvars
   project_id = "your-project-id"
   enabled_dashboards = ["compute"]  # Deploy only compute dashboard
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
