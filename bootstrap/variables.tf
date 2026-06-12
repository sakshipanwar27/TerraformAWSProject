variable "aws_region" {
  description = "AWS region for the state bucket and lock table"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name — used as a prefix for the bucket and table names"
  type        = string
  default     = "terraformawsproject"
}

variable "environment" {
  description = "Environment label appended to resource names"
  type        = string
  default     = "shared"
}
