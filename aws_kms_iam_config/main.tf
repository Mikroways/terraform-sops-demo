provider "aws" {
  region = "us-east-1" 
}

resource "aws_kms_key" "sops_key" {
  description             = "KMS key for SOPS"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_iam_role" "sops_role" {
  name = "SOPSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "sops_kms_permissions" {
  name = "SOPSKMSPermissions"
  role = aws_iam_role.sops_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.sops_key.arn,
        Effect   = "Allow"
      }
    ]
  })
}

