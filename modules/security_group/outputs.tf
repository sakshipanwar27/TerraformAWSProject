output "security_group_id" {
  description = "ID of the Security Group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "Name of the Security Group"
  value       = aws_security_group.ec2_sg.name
}
