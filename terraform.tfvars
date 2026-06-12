# -------------------------------------------------------
# All values below have sensible defaults.
# The minimum you MUST change: nothing — defaults work out of the box
# using your account's default VPC and subnet.
#
# To use a specific VPC/subnet, fill in the IDs below.
# Leave them as "" to auto-use the default VPC.
# -------------------------------------------------------

aws_region   = "us-east-1"
project_name = "terraformawsproject"
environment  = "dev"

# Leave as "" to auto-detect the account's default VPC and subnet.
# Set explicit IDs to target a specific VPC/subnet.
vpc_id    = ""
subnet_id = ""

# AMI: Amazon Linux 2 (us-east-1). Update if you change region.
ami_id        = "ami-0c02fb55956c7d316"
instance_type = "t3.micro"

# Optional: set to an existing key pair name to enable SSH
key_name = ""

# Restrict SSH access to your IP in production, e.g. ["203.0.113.10/32"]
allowed_ssh_cidrs = ["0.0.0.0/0"]
