terraform {
  backend "s3" {
    bucket         = "jft-lilac-tfstate"
    key            = "development.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "jft-lilac-develop-tf-state-lock"
  }

  required_providers {
    aws = "~> 3.24.0"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = merge(
    local.common_tags,
    map("Name", "${local.project}-${local.prefix}-kp")
  )
}

locals {
  prefix  = var.prefix
  project = var.project
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
