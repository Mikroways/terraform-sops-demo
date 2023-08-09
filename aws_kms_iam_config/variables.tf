variable "aws_region" {
  description = "La region AWS donde los recursos serán creados."
  type        = string
  default     = "us-east-1" 
}

variable "aws_account_arn" {
  description = "ARN de tu cuenta AWS."
  type        = string
}

