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
      "eks:UpdateClusterConfig",
      "eks:DescribeCluster",
      "eks:DescribeUpdate",
      "eks:ListUpdates",
      "iam:Get*",
      "iam:List*",
      "sts:GetCallerIdentity",
      "kms:DescribeKey",
      "kms:CreateKey",
      "kms:EnableKeyRotation",
      "kms:CreateAlias",
      "kms:ListAliases",
      "kms:TagResource",
      "kms:PutKeyPolicy",
      "logs:AssociateKmsKey",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "logs:CreateLogGroup",
      "logs:TagResource",
      "logs:PutRetentionPolicy",
      "kms:ScheduleKeyDeletion",
      "iam:DetachRolePolicy",
      "iam:DeletePolicy",
      "iam:DeleteRole",
      "ec2:DisassociateRouteTable",
      "ec2:DeleteRoute",
      "ec2:DeleteTags",
      "ec2:DeleteRouteTable",
      "ec2:DeleteNatGateway",
      "eks:DeleteFargateProfile",
      "eks:DeleteCluster",
      "kms:DeleteAlias",
      "iam:DeleteRolePolicy",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSubnet",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteNatGateway",
      "ec2:DeleteVpc",
      "logs:DeleteLogGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:ReleaseAddress",
      "iam:CreateRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:PassRole",
      "ec2:CreateVpc",
      "ec2:CreateSubnet",
      "ec2:CreateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:AllocateAddress",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateTags",
      "eks:CreateCluster",
      "eks:CreateFargateProfile",
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy",
      "kms:CreateAlias",
      "iam:TagRole",
      "ec2:ModifyVpcAttribute",
      "eks:TagResource",
      "ec2:AssociateRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteNetworkAclEntry",
      "iam:CreatePolicy",
      "ec2:CreateNetworkAclEntry",
      "iam:TagPolicy",
      "ec2:DisassociateAddress",
      # ECR permissions for CI/CD
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:CreateRepository",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:DescribeImages",
      "ecr:BatchDeleteImage",
      "ecr:ListTagsForResource",
      "eks:ListFargateProfiles",
      "eks:DescribeNodegroup",
      "eks:ListNodegroups",
      "eks:ListUpdates",
      "eks:AccessKubernetesApi",
      "eks:ListAddons",
      "eks:DescribeCluster",
      "eks:DescribeAddonVersions",
      "eks:ListClusters",
      "eks:ListIdentityProviderConfigs",
      "iam:ListRoles",
      "iam:TagOpenIDConnectProvider",
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions" {
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions.json
}
