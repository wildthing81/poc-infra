variable "app_name" {
  default = "credible-ui"
}

module "fe_cluster" {
  source                = "../modules"
  stage                 = var.stage
  app_name              = var.app_name
  service_count             = var.app_count
  container_definitions = data.template_file.app.rendered
  vpc_id                = var.vpc_id
  //public subnet
  alb_subnets     = aws_default_subnet.public.*.id
  sd_namespace_id = var.sd_namespace_id
}

