resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.vpc-aws-project.id

  tags = {
    Name = "IGW: for vpc-aws-project"
  }
}