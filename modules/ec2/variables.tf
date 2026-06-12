variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH (optional)"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "Security Group ID to attach to the instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile name to attach to the instance"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
