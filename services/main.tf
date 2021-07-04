//public subnets
resource "aws_default_subnet" "public" {
  count             = length(local.az)
  availability_zone = local.az[count.index]
  tags = {
    Name = "Public"
  }
}

resource "aws_ecs_cluster" "app" {
  name = "${var.stage}-${var.app_name}-cluster"
}

resource "aws_ecr_repository" "main" {
  name = "${var.stage}-${var.backend}"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "second" {
  name = "${var.stage}-${var.eventsourcing}"
  image_scanning_configuration {
    scan_on_push = true
  }
}

module "ecs_cluster" {
  source                = "../modules"
  stage                 = var.stage
  app_name              = var.app_name
  cluster_id            = aws_ecs_cluster.app.id
  service1              = var.backend
  service2              = var.eventsourcing
  service_count         = var.service_count
  service1_definitions   = data.template_file.backend.rendered
  service2_definitions   = data.template_file.eventsourcing.rendered
  vpc_id                = local.vpc_id
  alb_subnets           = aws_default_subnet.public.*.id
  sd_namespace_id       = var.sd_namespace_id
  s3_prefix_list        = var.shared.outputs.s3_prefix_list
  // vpce_sg_id            = aws_security_group.vpce.id
}

