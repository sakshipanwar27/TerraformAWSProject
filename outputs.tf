output "resolved_vpc_id" {
  description = "VPC ID actually used (explicit or default)"
  value       = local.resolved_vpc_id
}

output "resolved_subnet_id" {
  description = "Subnet ID actually used (explicit or default)"
  value       = local.resolved_subnet_id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2.private_ip
}

output "security_group_id" {
  description = "ID of the Security Group attached to EC2"
  value       = module.security_group.security_group_id
}

output "iam_role_name" {
  description = "Name of the IAM Role attached to EC2"
  value       = module.iam.role_name
}

output "iam_instance_profile_name" {
  description = "Name of the IAM Instance Profile"
  value       = module.iam.instance_profile_name
}
