module "eks" {
  # manage_aws_auth_configmap = true
  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:sts::160071257600:assumed-role/AWSReservedSSO_PowerUserPlusRole_db88d920cf78a35f/neil.price@thoughtworks.com"
  #     username = "admin"
  #     groups   = ["system:masters"]
  #   }
  # ]
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.prefix}-eks-fargate"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["45.118.67.137/32"]

  enable_irsa = false

  cloudwatch_log_group_kms_key_id = aws_kms_key.eks_logs.arn

  fargate_profiles = {
    default = {
      selectors = [
        {
          namespace = "default"
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
