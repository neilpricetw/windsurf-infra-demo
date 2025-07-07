module "eks" {
  manage_aws_auth_configmap = false
  source                    = "terraform-aws-modules/eks/aws"
  version                   = "19.21.0"

  cluster_name    = "${var.prefix}-eks-fargate"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  enable_irsa = true

  cloudwatch_log_group_kms_key_id = aws_kms_key.eks_logs.arn

  fargate_profiles = {
    default = {
      selectors = [
        {
          namespace = "default"
        },
        {
          namespace = "kube-system"
        }
      ]
    }
    coredns = {
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            "k8s-app" = "kube-dns"
          }
        }
      ]
    }
  }

  tags = merge(var.tags, { Name = "${var.prefix}-eks-fargate" })

  self_managed_node_groups = {}
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = module.eks.cluster_name
  fargate_profile_name   = "${var.prefix}-fargate-profile-eks-fargate"
  pod_execution_role_arn = aws_iam_role.fargate_iam_role.arn
  subnet_ids             = module.vpc.private_subnets

  selector {
    namespace = "default"
  }

  depends_on = [module.eks]
}

resource "aws_iam_role" "fargate_iam_role" {
  name                  = "${var.prefix}-fargate-role-eks-fargate"
  force_detach_policies = true
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate_pod_execution" {
  role       = aws_iam_role.fargate_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}