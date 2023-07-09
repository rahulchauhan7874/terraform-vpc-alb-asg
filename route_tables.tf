resource "aws_route_table" "aws-project-public-route-table" {
  vpc_id = aws_vpc.vpc-aws-project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }
  tags = {
    Name = "RT Public: for aws-project- "
  }
}

resource "aws_route_table" "aws-project-private-route-table" {
  count      = length(var.cidr_private_subnet)
  vpc_id     = aws_vpc.vpc-aws-project.id
  depends_on = [aws_nat_gateway.nat_gateway]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  tags = {
    Name = "RT Private: for aws-project"
  }
}