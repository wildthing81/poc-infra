variable "app_port" {
  default = 3000
}

variable "aws_region" {}

variable "stage" {}

variable "app_count" {
  default = "3"
}

variable "sd_namespace_id" {}

variable "vpc_id" {
  default = ""
}

variable "az" {
  default = ""
}