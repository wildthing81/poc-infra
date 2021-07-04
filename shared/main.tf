/*
 Resources shared between all non-prod environments will be provisioned in this workspace
 e.g. subnets, routetables, service discovery namespaces, vpc-endpoints
*/
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "credible"
    key = "infra/terraform.tfstate"
    region = "ap-southeast-2"
    encrypt = true
    access_key = var.access_key
    secret_key = var.secret_key
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-southeast-2"
}

variable "access_key" {
  description = "AWS user access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

locals {
  vpc_id = data.aws_vpc.default.id
  az = data.aws_availability_zones.available.names
}

//public subnets
resource "aws_default_subnet" "public" {
  count             = length(local.az)
  availability_zone = local.az[count.index]
  tags = {
    Name = "Public"
  }
}

