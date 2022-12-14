variable "prefix" {
  description = "common tag indicating environment prefix (eg: development)"
  # set in terraform.tfvars
}

variable "project" {
  description = "common tag indicating project (eg: lilac)"
  # set in terraform.tfvars
}

variable "contact" {
  description = "common tag indicating author email address"
  # set in terraform.tfvars
}

variable "key_name" {
  description = "aws key pair"
  # set in terraform.tfvars
}

variable "public_key_path" {
  description = "path to ssh public key"
  # set in terraform.tfvars
}

variable "aws_region" {
  description = "aws region"
  # set in terraform.tfvars
}

# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}

variable "bastion_key_name" {
  description = "bastion key"
  # set in terraform.tfvars
}

variable "postgres_db_password" {
  description = "rds password"
  # set in terraform.tfvars
}

variable "postgres_db_username" {
  description = "rds username"
  # set in terraform.tfvars
}

variable "ecr_image_colleges" {
  description = "colleges ecr image"
  # set in terraform.tfvars
}

variable "private_key_path" {
  description = "key for ssh sql file to bastion"
  type        = string
}