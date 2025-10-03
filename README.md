🚀 Chatbot AI Deployment on AWS

This project demonstrates how to deploy a production-ready Chatbot AI application on AWS using ECS Fargate, RDS MySQL, and a complete CI/CD pipeline. The deployment is secured with IAM roles, Route53, ACM, and a Load Balancer, with automated scans, monitoring, and scaling.

🏗 Architecture Overview 🔹 Source Control & CI/CD

GitHub → source code hosting

GitHub Actions → CI/CD pipeline

SonarCloud → static code analysis

Docker → containerization

Trivy → image vulnerability scanning

Amazon ECR → final image registry

🔹 Application Infrastructure

VPC → with both public and private subnets

ECS Fargate → cluster in private subnets

RDS MySQL → database in private subnet

NAT Gateway → ECS tasks access internet securely

IAM Roles → secure ECS ↔ RDS communication

🔹 Networking & Security

Route53 → hosted zone for domain name

ACM → SSL/TLS certificate management

Application Load Balancer (ALB) → TLS termination in public subnets

Domain Name → points to ALB for browser access

🔹 Scaling & Monitoring

ECS Service Auto Scaling → exponential scaling via CloudWatch metrics

RDS Scaling → Python + Lambda function for DB scaling automation

CloudWatch → metrics, logs, dashboards

SNS → notifications (alerts via email/SMS)

Load Testing → validate scaling under stress

⚙️ Setup Instructions 1️⃣ Prerequisites

AWS Account (IAM admin access)

Domain managed in Route53

Local tools installed:

Docker

AWS CLI

Terraform or CloudFormation

SonarCloud Account

Trivy

2️⃣ CI/CD Pipeline

Push code to GitHub.

GitHub Actions workflow:

✅ Run Tests

✅ SonarCloud Scan

✅ Build Docker Image

✅ Run Trivy Scan

✅ Push to Amazon ECR

✅ Deploy to ECS Fargate

3️⃣ Infrastructure Setup (Terraform)

This project uses Terraform to provision all AWS resources. The repo is organized into modules for clarity and reusability:

infrastructure/ │── main.tf # Root configuration, providers, backend │── variables.tf # Global variables │── outputs.tf # Global outputs

modules/ │── vpc/ # VPC, subnets, IGW, NAT Gateway │── ecs/ # ECS cluster, task definitions, services │── ecr/ # Elastic Container Registry │── rds/ # RDS MySQL instance & subnet groups │── iam/ # IAM roles & policies for ECS & RDS │── alb/ # Application Load Balancer, target groups, listeners │── route53/ # Hosted zone & DNS records │── acm/ # SSL/TLS certificate │── scaling/ # ECS scaling policies, Lambda for RDS scaling

✅ Highlights:

ecs/ecs.tf → ECS Cluster & Fargate Service with Auto Scaling

rds/rds.tf → MySQL with private subnets + scaling Lambda

alb/alb.tf → ALB with ACM cert attached + Route53 record

iam/iam.tf → IAM roles for ECS tasks to connect securely to RDS

scaling/scaling.tf → CloudWatch alarms + ECS/RDS scaling policies

4️⃣ Monitoring & Scaling

CloudWatch → dashboards, alarms, metrics

SNS → subscribe email/SMS alerts

Auto Scaling:

ECS → CPU/Memory metrics

RDS → Python Lambda scaling handler

5️⃣ Load Testing

Use k6, Locust, or JMeter

Target ALB domain

Observe scaling + CloudWatch metrics

🌟 Project Highlights

🔒 End-to-end secure deployment pipeline with SonarCloud + Trivy

🐳 ECS Fargate for containerized workloads

🗄 RDS MySQL in private subnets

🌐 NAT Gateway for controlled internet egress

🔐 Route53 + ACM + ALB → HTTPS public access

📈 Exponential scaling for ECS & RDS (via CloudWatch + Lambda)

📢 Monitoring & Alerts integrated with CloudWatch + SNS

🛠 Infrastructure as Code → Terraform modular setup

🔮 Future Enhancements

🌍 Multi-region failover

🛡 Replace ALB with API Gateway + WAF

🔎 Add Service Mesh (App Mesh / Istio)

📜 License

This project is for educational & portfolio purposes. You are free to customize, extend, and adapt as needed.
