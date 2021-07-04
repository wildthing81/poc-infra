data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = var.vpc_id
}

# To find latest ACTIVE revision in credible backend definition
data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.main.family
}

# To find latest ACTIVE revision in credible eventsourcing definition
data "aws_ecs_task_definition" "second" {
  task_definition = aws_ecs_task_definition.second.family
}
