# AWS Resource Usage Monitoring Script

##  Overview
This project is a Bash script that monitors and reports AWS resource usage using the AWS CLI.  
It provides a structured summary and detailed view of key AWS services in a simple, readable format.

---

##  Features
- Tracks usage of multiple AWS services:
  - EC2 Instances
  - S3 Buckets
  - Lambda Functions
  - IAM Users
- Displays both:
  - Summary (total count)
  - Detailed list of resources
- Generates a timestamped report
- Uses AWS CLI and query filtering for efficient data extraction

---

## 🛠️ Technologies Used
- Bash Scripting
- AWS CLI
- Linux (EC2 instance environment)

---

## 📂 Project Structure
aws-resource-monitoring/
├── script.sh
├── report.txt
└── README.md

---

## ⚙️ Prerequisites
- AWS CLI installed and configured (`aws configure`)
- Appropriate IAM permissions to access:
  - EC2
  - S3
  - Lambda
  - IAM

---

## ▶️ How to Run

```bash
chmod +x script.sh
./script.sh > report.txt

OUTPUT:

============= AWS RESOURCE USAGE REPORT ===========
Report generated on: Tue Apr 21 09:49:28 IST 2026

1. S3 Buckets
Total Count: 1
Bucket List:
 - mybucket775

2. EC2 Instances
Total Instances: 1
Instance Id:
 i-07bbc142706b99046

3. Lambda Functions
Total Functions: 0

4. IAM Users
Number of IAM users: 1
IAM Usernames:
 test-user

## 📈 Key Learnings
- Used AWS CLI to fetch resource data
- Applied query filtering for precise output
- Converted raw data into readable reports
- Automated tasks using Bash scripting

## 🔮 Future Improvements
- Schedule execution using cron
- Send reports via email
- Store reports in S3
- Extend monitoring to more AWS services
