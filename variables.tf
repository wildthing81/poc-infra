variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-southeast-2"
}

variable "stage" {
  default = "dev"
}

variable "access_key" {
  description = "AWS user access key"
}

variable "secret_key" {
  description = "AWS secret key"
}

variable "db_username" {
  default = ""
}
variable "db_password" {
  default = ""
}

variable "target" {
  default = ""
}
