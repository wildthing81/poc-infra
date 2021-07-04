data "aws_ecr_repository" "app" {
  name = var.app_name
}

data "template_file" "app" {
  template = file("${path.module}/templates/container_definitions.json.tpl")

  vars = {
    environment    = var.stage
    name           = var.app_name
    app_image      = data.aws_ecr_repository.app.repository_url
    app_port       = var.app_port
    fargate_cpu    = 1024
    fargate_memory = 2048
    aws_region     = var.aws_region
  }
}
