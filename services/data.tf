/*data "aws_ecr_repository" "main" {
  name = "${var.stage}-${var.backend}"
}*/

/*data "aws_ecr_repository" "second" {
  name = "${var.stage}-${var.eventsourcing}"
}*/

data "template_file" "backend" {
  template = file("${path.module}/templates/container_definitions.json.tpl")

  vars = {
    environment    = var.stage
    name           = var.backend
    app_image      = aws_ecr_repository.main.repository_url
    app_port       = var.backend_port
    fargate_cpu    = 1024
    fargate_memory = 2048
    aws_region     = var.aws_region
  }
}

data "template_file" "eventsourcing" {
  template = file("${path.module}/templates/container_definitions.json.tpl")

  vars = {
    environment    = var.stage
    name           = var.eventsourcing
    app_image      = aws_ecr_repository.second.repository_url
    app_port       = var.eventsourcing_port
    fargate_cpu    = 1024
    fargate_memory = 2048
    aws_region     = var.aws_region
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = local.vpc_id
}

data "aws_route_table" "main" {
  subnet_id = aws_default_subnet.public.*.id[0]
}

locals {
  vpc_id = data.aws_vpc.default.id
  az = data.aws_availability_zones.available.names
}
