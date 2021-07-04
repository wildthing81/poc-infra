# variables.tf
variable "stage" {
  description = "AWS environment profile"
  default     = "dev"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "credibleEcsTaskExecutionRole"
}

variable "ecs_auto_scale_role_name" {
  description = "ECS auto scale role Name"
  default     = "credibleEcsAutoScaleRole"
}

variable "app_name" {
  default     = ""
}

variable "cluster_id" {
  default = ""
}

variable "service1" {
  default = ""
}

variable "service2" {
  default = ""
}

variable "service1_port" {
  default     = 8080
}

variable "service2_port" {
  default     = 8085
}

variable "service1_definitions" {
  description = "Docker container definitions for service 1"
  default     = ""
}

variable "service2_definitions" {
  description = "Docker container definitions for service 2"
  default     = ""
}

variable "service_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "vpc_id" {
  default = ""
}

variable "sd_namespace_id" {
  default = ""
}

variable "alb_subnets" {
  default = ""
}

variable "s3_prefix_list" {
  default = ""
}

variable "database_port" {
  description = "I/O port for Postgres database"
  default     = "5432"
}

variable "alb_port" {
  description = "application load balancer listener port"
  default     = 3000
}

variable "https_port" {
  description = "https listener port"
  default     = 443
}
