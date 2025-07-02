# Terraform AWS VPC for EKS (Sydney)

This module creates a cost-efficient, multi-AZ VPC in the Sydney region (`ap-southeast-2`) using the official terraform-aws-modules/vpc/aws module. It is configured for best practices with only one NAT gateway to minimize cost.

## Features
- Multi-AZ (3 Availability Zones)
- 1 NAT Gateway (cost-efficient)
- Public and private subnets
- Best-practice tagging

## Usage
```hcl
terraform init
terraform apply
```

Variables can be customized in `variables.tf` or via CLI.
