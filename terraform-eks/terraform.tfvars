region          = "ap-southeast-2"
prefix          = "np"
vpc_name        = "eks-vpc"
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
tags = {
  Terraform   = "true"
  Environment = "dev"
}
eks_cluster_name    = "np-eks-fargate"
eks_cluster_version = "1.29"
