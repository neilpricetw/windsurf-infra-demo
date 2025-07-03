# OIDC provider for your EKS cluster (if not already created)
data "aws_eks_cluster" "this" {
  name = "np-eks-fargate"
}

data "aws_eks_cluster_auth" "this" {
  name = "np-eks-fargate"
}

data "aws_iam_openid_connect_provider" "eks" {
  url = "https://oidc.eks.ap-southeast-2.amazonaws.com/id/9151556A4C90AC777ADD8DF490ED7D2F"
}

# resource "aws_iam_openid_connect_provider" "eks" {
#  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd6c6e1"] # (example, check your OIDC thumbprint)
#}

data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.eks.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = "arn:aws:iam::160071257600:policy/AWSLoadBalancerControllerIAMPolicy"
}