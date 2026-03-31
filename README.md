#  Cloud Migration & Disaster Recovery using Terraform

##  Project Overview

This project demonstrates an end-to-end AWS infrastructure setup using **Terraform (Infrastructure as Code)**. It includes high availability, disaster recovery, monitoring, and cost optimization strategies.

---

##  Tech Stack

* **Cloud:** AWS (EC2, VPC, S3, ALB, Auto Scaling, CloudWatch, SNS)
* **IaC:** Terraform
* **OS:** Linux (Amazon Linux)
* **Monitoring:** CloudWatch + SNS Alerts

---

##  Architecture

* Custom VPC with public subnets across multiple Availability Zones
* Internet Gateway and Route Tables for external access
* EC2 instances deployed via Launch Template
* Application Load Balancer (ALB) for traffic distribution
* Auto Scaling Group for high availability
* S3 bucket with versioning for backup
* EBS snapshot lifecycle for disaster recovery
* CloudWatch alarms with SNS notifications

---

##  Features

* Infrastructure provisioning using Terraform
* Automated EC2 configuration using user_data
* High availability using ALB + Auto Scaling
* Disaster recovery using:

  * S3 versioning
  * EBS snapshot automation
* Monitoring & alerting using CloudWatch + SNS
* Remote Terraform state management (S3 backend)
* Cost optimization using lifecycle policies

---

##  Terraform Workflow

```
terraform init
terraform plan
terraform apply
terraform destroy
```

---

##  Disaster Recovery Validation

* Simulated EC2 failure
* Auto Scaling replaced instance automatically
* Application remained accessible via Load Balancer
* Data integrity maintained using S3 backups and snapshots

---

##  Project Structure

```
.
├── main.tf
├── variables.tf
├── vpc.tf
├── alb.tf
├── s3.tf
├── dr.tf
├── monitoring.tf
├── .gitignore
└── README.md
```

---

##  Key Learnings

* Designed scalable and fault-tolerant AWS architecture
* Implemented Infrastructure as Code using Terraform
* Built Disaster Recovery strategy using AWS services
* Gained hands-on experience with monitoring and alerting systems

---

##  Outcome

Built a **production-ready, scalable, and highly available cloud infrastructure** with automated disaster recovery and monitoring.

---
