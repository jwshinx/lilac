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
  region  = var.aws_region
}
