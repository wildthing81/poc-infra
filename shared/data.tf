data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = local.vpc_id
}


//main route table with internet gateway
data "aws_route_table" "main" {
  subnet_id = aws_default_subnet.public.*.id[0]
}
