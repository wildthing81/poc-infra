resource "aws_cloudwatch_log_group" "main_logs" {
  name              = "/fargate/${var.stage}-${var.service1}"
  retention_in_days = "7"
  tags = {
    Type = "${var.service1}-log"
  }
}

resource "aws_cloudwatch_log_group" "second_logs" {
  name              = "/fargate/${var.stage}-${var.service2}"
  retention_in_days = "7"
  tags = {
    Type = "${var.service2}-log"
  }
}
