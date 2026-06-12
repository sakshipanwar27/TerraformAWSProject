resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_instance_profile

  # Only attach key pair if one is provided
  key_name = var.key_name != "" ? var.key_name : null

  # Assign a public IP so you can reach the instance directly
  associate_public_ip_address = true

  # Enable detailed monitoring
  monitoring = true

  # Root EBS volume — encrypted at rest
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    # IMDSv2 only — prevents SSRF-based metadata abuse
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2"
  })
}
