variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used as a prefix for all resource names"
  type        = string
  default     = "terraformawsproject"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = <<-EOT
    VPC ID where EC2 and Security Group will be created.
    Leave empty ("") to automatically use the account's default VPC.
  EOT
  type        = string
  default     = "" # empty = use default VPC
}

variable "subnet_id" {
  description = <<-EOT
    Subnet ID where the EC2 instance will be launched.
    Leave empty ("") to automatically pick the first subnet of the default VPC.
  EOT
  type        = string
  default     = "" # empty = use first subnet of default VPC
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2 in us-east-1 by default)"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 Key Pair to enable SSH access (leave empty to skip)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH into the EC2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this in production
}
