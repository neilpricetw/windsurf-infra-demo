# OIDC provider for GitHub Actions
#resource "aws_iam_openid_connect_provider" "github" {
#  url = "https://token.actions.githubusercontent.com"
#  client_id_list = [
#    "sts.amazonaws.com"
#  ]
#  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's OIDC thumbprint
#}

data "aws_caller_identity" "current" {}

# IAM role for GitHub Actions OIDC
resource "aws_iam_role" "github_actions" {
  name = "github-actions-terraform"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = format("arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com", data.aws_caller_identity.current.id)
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            # Restrict to your repo and main branch
            "token.actions.githubusercontent.com:sub" = "repo:neilpricetw/windsurf-infra-demo:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name = "github-actions-terraform"
  }
}

# IAM policy for Terraform plan/apply (read-only for plan, broader for apply)
data "aws_iam_policy_document" "github_actions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Describe*",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::np-tfstate5",
      "arn:aws:s3:::np-tfstate5/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "eks:Describe*",
      "eks:List*",
      "iam:Get*",
      "iam:List*",
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions" {
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions.json
}
