provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

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

data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = "credible"
    key    = "env:/shared/non-prod/terraform.tfstate"
    region = var.aws_region
    access_key = var.access_key
    secret_key = var.secret_key
  }
}
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${var.stage}.credible-platform.com"
  description = "group of credible services that share same domain name"
  vpc         = data.aws_vpc.default.id
}

module "backend" {
  source          = "./services"
  stage           = var.stage
  aws_region      = var.aws_region
  db_username     = var.db_username
  db_password     = var.db_password
  shared          = data.terraform_remote_state.shared
  sd_namespace_id = aws_service_discovery_private_dns_namespace.main.id
}


/*module "frontend" {
  source          = "./frontend"
  depends_on      = [module.backend]
  stage           = var.stage
  aws_region      = var.aws_region
  vpc_id          = data.aws_vpc.default.id
  sd_namespace_id = aws_service_discovery_private_dns_namespace.main.id
  az              = data.aws_availability_zones.available.names
}*/

