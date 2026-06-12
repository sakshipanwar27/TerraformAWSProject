terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — S3 bucket and DynamoDB table are created by the
  # bootstrap/ directory. Run bootstrap ONCE before using this config.
  #
  # Bucket name format: {project_name}-{environment}-tfstate
  # Table name format:  {project_name}-{environment}-tfstate-lock
  #
  # If you changed project_name or environment in bootstrap/variables.tf,
  # update the values below accordingly.
  backend "s3" {
    bucket         = "terraformawsproject-shared-tfstate"
    key            = "main/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraformawsproject-shared-tfstate-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
