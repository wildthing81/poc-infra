variable "app_name" {
  description = "cluster name"
  default = "cuba"
}

variable "backend" {
  description = "Service name for cuba backend"
  default     = "cuba-bff"
}

variable "eventsourcing" {
  description = "Service name for poc eventsourcing"
  default     = "poc-es"
}

variable "backend_port" {
  description = "Port exposed by backend container for http traffic"
  default     = 8080
}

variable "eventsourcing_port" {
  description = "Port exposed by eventsourcing application container for http traffic"
  default     = 8085
}

variable "aws_region" {}

variable "stage" {}

variable "db_username" {}

variable "db_password" {}

variable "service_count" {
  default = "1"
}

variable "shared" {}

variable "sd_namespace_id" {}
