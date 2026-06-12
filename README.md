# TerraformAWSProject

Terraform project that provisions an **EC2 instance** with an attached **Security Group** and **IAM Role** on AWS, with a full **GitHub Actions CI/CD pipeline**.

---

## Project Structure

```
TerraformAWSProject/
├── main.tf                  # Root module — wires up all child modules
├── variables.tf             # Input variable declarations
├── outputs.tf               # Root-level outputs
├── terraform.tfvars         # Variable values (edit before running)
├── backend.tf               # Terraform version, provider, and remote state config
├── .gitignore
├── modules/
│   ├── ec2/                 # EC2 instance resource
│   ├── security_group/      # Security Group (SSH, HTTP, HTTPS)
│   └── iam/                 # IAM Role + Instance Profile
└── .github/workflows/
    ├── terraform-plan.yml   # Runs on Pull Request → posts plan as PR comment
    └── terraform-apply.yml  # Runs on merge to main → applies changes
```

---

## Prerequisites

- Terraform >= 1.5.0
- An AWS account with permissions to create EC2, IAM, and VPC resources
- An existing VPC and Subnet

---

## Setup

### 1. Bootstrap remote state (run once)

The `bootstrap/` directory creates the S3 bucket and DynamoDB table that store Terraform state. This is a one-time manual step.

```bash
cd bootstrap
terraform init
terraform apply
# Note the outputs: state_bucket_name and dynamodb_table_name
cd ..
```

The bucket and table names are already pre-filled in `backend.tf` using the default variable values. If you changed `project_name` or `environment` in `bootstrap/variables.tf`, update `backend.tf` to match.

### 2. Configure `terraform.tfvars`

Open `terraform.tfvars` and set your VPC ID and Subnet ID:

```hcl
vpc_id    = "vpc-xxxxxxxxxxxxxxxxx"
subnet_id = "subnet-xxxxxxxxxxxxxxxxx"
```

### 3. Set GitHub Secrets

Go to **Settings → Secrets and variables → Actions** in your GitHub repo and add:

| Secret name           | Value                                      |
|-----------------------|--------------------------------------------|
| `AWS_ACCESS_KEY_ID`   | IAM user access key with deploy permissions |
| `AWS_SECRET_ACCESS_KEY` | Corresponding secret key                 |
| `TF_VAR_VPC_ID`       | Your VPC ID                                |
| `TF_VAR_SUBNET_ID`    | Your Subnet ID                             |

> **Production recommendation:** Replace static credentials with [OIDC federation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) so no long-lived keys are stored.

---

## CI/CD Pipeline Flow

```
Developer pushes branch
        │
        ▼
  Opens Pull Request
        │
        ▼
[GitHub Actions] terraform-plan.yml
  - fmt check
  - init
  - validate
  - plan  ──► plan output posted as PR comment
        │
        ▼
  Code review + approval
        │
        ▼
  PR merged to main
        │
        ▼
[GitHub Actions] terraform-apply.yml
  - init
  - plan (re-run)
  - apply ──► AWS resources created/updated
```

---

## Running Locally

```bash
# Install dependencies
terraform init

# Preview changes
terraform plan -var-file=terraform.tfvars

# Apply changes
terraform apply -var-file=terraform.tfvars

# Destroy all resources
terraform destroy -var-file=terraform.tfvars
```

---

## Resources Created

| Resource | Name pattern |
|---|---|
| EC2 Instance | `{project}-{env}-ec2` |
| Security Group | `{project}-{env}-ec2-sg` |
| IAM Role | `{project}-{env}-ec2-role` |
| IAM Instance Profile | `{project}-{env}-ec2-profile` |

---

## Security Notes

- EC2 uses **IMDSv2** (token-required) to prevent SSRF metadata attacks.
- Root EBS volume is **encrypted at rest**.
- IAM Role uses **least-privilege** — only SSM Session Manager and S3 read-only are attached by default.
- Restrict `allowed_ssh_cidrs` to your IP in production.
