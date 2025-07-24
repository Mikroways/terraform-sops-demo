output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.sops_key.arn
}

output "kms_key_alias_name" {
  description = "The alias of the KMS key"
  value       = aws_kms_alias.sops_key_alias.name
}

output "kms_key_alias_arn" {
  description = "The ARN of the KMS key alias"
  value       = aws_kms_alias.sops_key_alias.arn
}

