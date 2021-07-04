# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${var.stage}-${var.app_name}-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.https_port
    to_port     = var.https_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "cluster" {
  name        = "${var.stage}-${var.app_name}-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "inbound access from ALB"
    protocol        = "tcp"
    from_port       = var.service1_port
    to_port         = var.service1_port
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    description     = "inbound access from seeder lambda"
    protocol        = "tcp"
    from_port       = var.service1_port
    to_port         = var.service1_port
    security_groups = [data.aws_security_group.default.id]
  }

  egress {
    description = "outbound access to ECR"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    //security_groups = [var.vpce_sg_id]
  }

  egress {
    description     = "outbound traffic to S3 privatelink to pull docker image"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = [var.s3_prefix_list]
  }

  egress {
    description     = "outbound traffic to RDS"
    from_port       = var.database_port
    to_port         = var.database_port
    protocol        = "tcp"
    security_groups = [aws_security_group.database.id]
  }
}

resource "aws_security_group" "database" {
  name_prefix = "${var.stage}-${var.app_name}-aurora-sg"
  vpc_id      = var.vpc_id
}

output "db_sg_id" {
  value = aws_security_group.database.id
}

//allow RDS inbound traffic from ECS. separate rule to avoid cyclic dependency
resource "aws_security_group_rule" "db_ingress_ecs_rule" {
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = aws_security_group.cluster.id
}

//Allow RDS inbound traffic from seeder lambda for non-prod environments
resource "aws_security_group_rule" "db_ingress_lambda_rule" {
  count                    = contains(["dev","stag"],var.stage) ? 1 : 0
  type                     = "ingress"
  from_port                = var.database_port
  to_port                  = var.database_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.database.id
  source_security_group_id = data.aws_security_group.default.id
}
