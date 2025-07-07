resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:sts::160071257600:assumed-role/AWSReservedSSO_PowerUserPlusRole_db88d920cf78a35f/neil.price@thoughtworks.com"
        username = "admin"
        groups   = ["system:masters"]
      }
    ])
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::160071257600:role/github-actions-terraform"
        username = "github-actions"
        groups   = ["system:masters"]
      }
    ])
  }

}
