# AWS Serverless Resource Monitor & CI/CD Pipeline
A production-grade, automated AWS infrastructure and observability stack that monitors resource usage, tracks execution performance, and provides real-time visualization through Grafana.

🏗️ Architecture Overview
This project implements a fully automated, event-driven serverless monitoring pattern on AWS, provisioned via Terraform and deployed through a GitHub Actions CI/CD pipeline.

<img width="1257" height="753" alt="image" src="https://github.com/user-attachments/assets/e10a502c-05a2-46ba-a88d-46d15a91ebea" />


                                        
💡 Engineering Rationale & Architectural Decisions
1. Serverless AWS Lambda vs. Traditional 24/7 EC2 Instance
The Problem with EC2: Running a traditional EC2 instance 24/7 solely to execute scheduled monitoring scripts introduces unnecessary idle compute costs, constant operating system patch management, security surface area risks, and wasted resources when tasks only run periodically.

The Serverless Solution: Migrating to AWS Lambda completely eliminates idle infrastructure costs. The compute engine scales down to zero when inactive and provisions instantly only when triggered. This shifts infrastructure from an active operational burden to a pure pay-as-you-go model.

2. Event-Driven Architecture (Amazon EventBridge)
Instead of relying on internal OS task schedulers (like cron inside an EC2 instance) which fail if the server restarts or crashes, this architecture decouples scheduling via Amazon EventBridge. EventBridge emits native triggers every 10 minutes, ensuring reliable, decoupled, and fault-tolerant execution without maintaining persistent infrastructure.

3. Python & Boto3 vs. Bash Scripting & AWS CLI
The Limitations of Bash & CLI: While Bash and raw AWS CLI commands work for simple linear commands, they become brittle, hard to maintain, and difficult to test when handling complex data parsing, exception handling, error logging, and structured JSON outputs at scale.

The Power of Python & Boto3: Using Python with the Boto3 SDK provides robust object-oriented API interactions, native exception handling, clean data structures, and advanced programmatic control. This allows the monitoring logic to securely query, parse, and structure cloud resource telemetry reliably.

🛠️ Tech Stack & Components
Cloud Provider: Amazon Web Services (AWS)

Infrastructure as Code (IaC): Terraform (with S3 Remote Backend)

CI/CD Automation: GitHub Actions (Workflow automation & deployment management)

Serverless Compute: AWS Lambda (Python runtime utilizing boto3)

Trigger Engine: Amazon EventBridge (Cron scheduler)

Observability & Monitoring: Amazon CloudWatch (Logs & Metrics) integrated with Grafana Cloud

🚀 Key Features & Business Problem Solving
Solving Manual Bottlenecks: Manual infrastructure auditing and script execution are prone to human error, lack historical tracking, and consume valuable engineering hours. This pipeline automates audits entirely.

Infrastructure Automation: Complete provisioning of Lambda functions, IAM execution roles, and EventBridge trigger schedules using modular Terraform configurations.

Automated CI/CD Deployment: Seamless git-triggered deployment pipeline via GitHub Actions managing state authentication and resource application.

Real-Time Observability Dashboard: Custom-configured Grafana Cloud dashboard tracking core telemetry metrics:

Invocations: Execution volume mapping automated cron triggers.

Duration: Latency tracking per execution cycle.

Errors: Reliability index ensuring zero-failure operations.

⚙️ GitHub Actions CI/CD Workflow Setup
The repository utilizes a fully automated CI/CD pipeline built with GitHub Actions. Here is how it manages the end-to-end lifecycle:

Trigger: Any push or merge to the main branch automatically initiates the workflow runner.

Environment & Credentials Setup: The runner securely authenticates with AWS using GitHub Repository Secrets (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY).

Terraform Initialization & Planning (terraform init & terraform plan): Validates the Terraform configuration files, sets up the remote S3 backend state, and computes the infrastructure delta.

Automated Application (terraform apply -auto-approve): Provisions or updates all required AWS resources—including the IAM execution role, Lambda function code package, CloudWatch log groups, and EventBridge cron rules—without manual intervention.

📁 Repository Structure
Plaintext
├── .github/
│   └── workflows/        # GitHub Actions CI/CD deployment pipeline (main.yml)
├── terraform/            # Terraform configuration files (main.tf, iam.tf, variables.tf)
├── src/                  # Lambda Python script (boto3 resource monitor)
├── grafana/              # Exported Dashboard JSON model for Dashboard-as-Code
└── README.md             # Project documentation
📊 Observability & Monitoring
The monitoring dashboard tracks core performance metrics utilizing precise metric queries mapped from CloudWatch to Grafana:
  Metric Tracking: Exact-match filtering targeting the aws_resource_monitor Lambda function.
  Dashboard-as-Code: The dashboard configuration is version-controlled via grafana/dashboard.json, allowing reproducible workspace deployments.
  [View Live Grafana Monitoring Snapshot](https://mintwombat2640.grafana.net/dashboard/snapshot/UW5rjniLVp2ne56WuwyeuuFWTn791xVp)

👨‍💻 Author
Prajwal Raj Malpe
Cloud Infrastructure & DevOps Engineer
LinkedIn | GitHub
