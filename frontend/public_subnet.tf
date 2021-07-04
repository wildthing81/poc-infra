resource "aws_default_subnet" "public" {
  count             = length(var.az)
  availability_zone = var.az[count.index]
  tags = {
    Name = "Public"
  }
}
