# EC2 Nginx Automated Monitoring & Infrastructure

An automated Infrastructure-as-Code (IaC) and CI/CD pipeline project that provisions an AWS EC2 instance, bootstraps an Nginx web server with a custom system health monitoring script via cloud-init, validates the deployment via GitHub Actions, extracts server metrics, archives the report, and tears down the infrastructure to prevent cloud costs.

---

## Architecture & Tech Stack

* **Cloud Provider:** Amazon Web Services (AWS) — EC2, Security Groups, VPC
* **Infrastructure as Code:** Terraform
* **Automation & CI/CD:** GitHub Actions
* **Web Server & Monitoring:** Nginx, Bash Scripting (`cloud-init`)

---

## Project Structure

aws_devops_projects/
├── .github/
│   └── workflows/
│       └── terraform.yml     # CI/CD pipeline configuration
└── ec2-nginx-monitoring/
    └── terraform/
        ├── modules/
        │   └── ec2_instance/
        │       ├── main.tf       # EC2 instance & Security Group resources
        │       ├── variables.tf  # Input variables (AMI, instance type, region)
        │       └── outputs.tf    # Exports public IP and instance details
        ├── main.tf               # Root Terraform configuration calling the module
        ├── user-data.sh          # Cloud-init script: installs Nginx & health report
        └── backend.tf            # Terraform state configuration
---

## How It Works

1. **Trigger:** A push to the `main` branch inside the project directory triggers the GitHub Actions workflow.
2. **Provisioning:** The runner initializes Terraform and executes `terraform apply`, spinning up an Ubuntu EC2 instance.
3. **Bootstrapping (`user-data.sh`):**
* Updates package lists and installs Nginx.
* Generates a system health report script (`monitor.sh`) capturing disk space (`df -h`), memory usage (`free -h`), and CPU cores (`nproc`).
* Saves the output directly to `/var/www/html/report.txt`.


4. **Validation & Polling:** The workflow polls the instance's public IP using a resilient `curl` retry loop to ensure Nginx and the generated report are live.
5. **Artifact Storage:** The node health report is downloaded to the runner and saved as a GitHub Actions artifact (`ec2-node-health-report`).
6. **Cost Optimization (Teardown):** Runs `terraform destroy -auto-approve` immediately after reporting, ensuring zero lingering AWS resource billing.

---

## Setup & Prerequisites

### 1. GitHub Secrets Configuration

To allow GitHub Actions to authenticate with your AWS account, configure the following repository secrets under **Settings > Secrets and variables > Actions**:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

### 2. Manual Execution (Local Alternative)

If you prefer running Terraform locally rather than through GitHub Actions:

```bash
cd ec2-nginx-monitoring/terraform
terraform init
terraform plan
terraform apply -var="region=us-east-1"

```