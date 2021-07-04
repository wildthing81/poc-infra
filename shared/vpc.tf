/* Create private subnets */
resource "aws_subnet" "private" {
  count  = length(local.az)
  vpc_id = local.vpc_id
  //cidr_block        = var.cidr_block[count.index]
  cidr_block        = cidrsubnet(data.aws_vpc.default.cidr_block, 4, count.index + 3)
  availability_zone = local.az[count.index]

  tags = {
    Name = "Private Subnet"
  }
}

/// NAT gateway routing table  for each private subnet.
resource "aws_route_table" "private" {
  // count = length(var.az)
  vpc_id = local.vpc_id
  // remove the below block to have single table & make all subnets fully isolated.
  /*route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }*/
  tags = {
    Name = "Private-subnet-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.az)
  subnet_id      = element(aws_subnet.private.*.id,count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


//// new security group for VPC endpoints. default group can be used ??
resource "aws_security_group" "vpce" {
  name   = "vpce-security-group"
  vpc_id = local.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
  tags = {
    Name = "vpce-sg"
  }
}

/// endpoints to other services from VPC
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpce.id]
  subnet_ids          = aws_subnet.private.*.id
  private_dns_enabled = true
  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  //count = length(var.az)
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpce.id]
  subnet_ids          = aws_subnet.private.*.id
  private_dns_enabled = true
  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  // this should be table with internet gateway route else doesn't work
  // route_table_ids   = aws_route_table.private.*.id
  route_table_ids = [data.aws_route_table.main.id]

  tags = {
    Name = "s3-endpoint"
  }
}

# CloudWatch...maybe later ????

resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true
  tags = {
    Name = "cloudwatch-endpoint"
  }
}

/*resource "aws_eip" "nat_gw_eip" {
  count          = length(var.az)
  vpc            = true
}*/

/*resource "aws_nat_gateway" "nat_gw" {
  count          = length(var.az)
  allocation_id = element(aws_eip.nat_gw_eip.*.id, count.index)
  subnet_id     = element(aws_default_subnet.public.*.id, count.index)
  depends_on    = [aws_default_subnet.public]
  tags = {
    "Name" = "${var.stage} NATGateway"
  }
}*/


