resource "aws_ecs_task_definition" "main" {
  family                   = "${var.stage}-${var.service1}-fargate-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = var.service1_definitions
}

resource "aws_ecs_task_definition" "second" {
  family                   = "${var.stage}-${var.service2}-fargate-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = var.service2_definitions
}

resource "aws_service_discovery_service" "main" {
  name = "${var.stage}-${split("-",var.service1)[1]}"
  dns_config {
    namespace_id = var.sd_namespace_id
    dns_records {
      ttl = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "second" {
  name = "${var.stage}-${split("-",var.service2)[1]}"
  dns_config {
    namespace_id = var.sd_namespace_id
    dns_records {
      ttl = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "main" {
  name                = "${var.stage}-${var.service1}-service"
  cluster             = var.cluster_id
  task_definition     = "${aws_ecs_task_definition.main.family}:${max(aws_ecs_task_definition.main.revision, data
  .aws_ecs_task_definition.main.revision)}"
  desired_count       = var.service_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"


  network_configuration {
    security_groups  = [aws_security_group.cluster.id]
    subnets          = var.alb_subnets
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.main.arn
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.service1}-container"
    container_port   = var.service1_port
  }
  depends_on = [aws_alb_listener.main, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_service" "second" {
  name                = "${var.stage}-${var.service2}-service"
  cluster             = var.cluster_id
  task_definition     = "${aws_ecs_task_definition.second.family}:${max(aws_ecs_task_definition.second.revision, data
  .aws_ecs_task_definition.second.revision)}"
  desired_count       = var.service_count
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"


  network_configuration {
    security_groups  = [aws_security_group.cluster.id]
    subnets          = var.alb_subnets
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.second.arn
  }

  /*load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "${var.service2}-container"
    container_port   = var.service2_port
  }*/

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_role]
}
