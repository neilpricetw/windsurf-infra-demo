resource "aws_kms_key" "eks_logs" {
  description         = "KMS key for EKS CloudWatch log group encryption"
  enable_key_rotation = true

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Principal" : { "AWS" : "arn:aws:iam::160071257600:role/github-actions-terraform" },
        "Action" : [
          "kms:DescribeKey",
          "kms:List*",
          "kms:Get*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = merge(var.tags, { Name = "${var.prefix}-eks-logs-kms" })
}

resource "aws_kms_alias" "eks_logs" {
  name          = "alias/${var.prefix}-eks-logs"
  target_key_id = aws_kms_key.eks_logs.id
}

