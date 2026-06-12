
# ── Default VPC / Subnet fallback ─────────────────────────────────────────────
#
# These data sources are only queried when vpc_id / subnet_id are left empty.
# If your account has no default VPC, provide explicit IDs in terraform.tfvars.

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # Pick only subnets that auto-assign a public IP (default VPC subnets do this)
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

locals {
  # Use the provided VPC/subnet ID, or fall back to the default VPC/subnet
  resolved_vpc_id    = var.vpc_id    != "" ? var.vpc_id    : data.aws_vpc.default.id
  resolved_subnet_id = var.subnet_id != "" ? var.subnet_id : data.aws_subnets.default.ids[0]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ── IAM Role ──────────────────────────────────────────────────────────────────
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags
}

# ── Security Group ────────────────────────────────────────────────────────────
module "security_group" {
  source = "./modules/security_group"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = local.resolved_vpc_id   # uses default VPC if not provided
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  tags              = local.common_tags
}

# ── EC2 Instance ──────────────────────────────────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = local.resolved_subnet_id  # uses default subnet if not provided
  key_name             = var.key_name
  security_group_id    = module.security_group.security_group_id
  iam_instance_profile = module.iam.instance_profile_name
  tags                 = local.common_tags
}
