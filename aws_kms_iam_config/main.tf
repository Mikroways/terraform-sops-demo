provider "aws" {
  region = var.AWS_REGION
}

resource "aws_kms_key" "sops_key" {
  description             = "clave KMS para  SOPS"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "sops_key_alias" {
  name          = "alias/sops-key"
  target_key_id = aws_kms_key.sops_key.key_id
}

resource "aws_iam_role" "sops_role" {
  name = "SOPSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          AWS = var.AWS_ARN
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

