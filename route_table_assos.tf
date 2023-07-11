
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.cidr_public_subnet)
  depends_on     = [aws_subnet.aws-project-public-subnets, aws_route_table.aws-project-public-route-table]
  subnet_id      = element(aws_subnet.aws-project-public-subnets[*].id, count.index)
  route_table_id = aws_route_table.aws-project-public-route-table.id
}


resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.cidr_private_subnet)
  depends_on     = [aws_subnet.vpc-aws-project-private-subnets, aws_route_table.aws-project-private-route-table]
  subnet_id      = element(aws_subnet.vpc-aws-project-private-subnets[*].id, count.index)
  route_table_id = aws_route_table.aws-project-private-route-table[count.index].id
}
