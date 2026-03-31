# Define all variables your config uses. Centralizes config.

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "dev, staging, or prod"
  type        = string
  default     = "prod"
}

variable "my_ip" {
  description = "Your home/office IP for SSH access"
  type        = string
  # ^ No default — must be set in terraform.tfvars
}
