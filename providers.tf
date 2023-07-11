terraform {
  required_version = ">= 1.1.2"
  

  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.7.2"
    }

    aws = {
       source = "hashicorp/aws"
       version = ">= 4.6"
    }
  }
}
provider "aws" {
    region = "us-east-1"
  }
provider "sops" {}
