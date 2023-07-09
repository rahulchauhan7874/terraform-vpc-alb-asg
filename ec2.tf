####BASTION HOST
######################################################################

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Subnet-Public : Public Subnet 1"]
  }

  depends_on = [
    aws_route_table_association.public_subnet_association
  ]
}



resource "aws_instance" "bastion-host" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = "my_ubuntu"
  subnet_id                   = data.aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.bastion-host-sg.id]
  associate_public_ip_address = true

  depends_on = [aws_security_group.bastion-host-sg]

  tags = {
    Name = "EC2 Public bastion host"
  }
}

locals {
  ingress_rule = [
    {
      port        = 22
      description = "Ingress rule for port 22"
    },

    {
      port        = 8080
      description = "Ingress rule for port 8080"
    }

  ]

}


resource "aws_security_group" "bastion-host-sg" {

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rule

    content {
      description = ""
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

  }

  # ingress = [
  #   {
  #     cidr_blocks      = ["0.0.0.0/0", ]
  #     description      = ""
  #     from_port        = 22
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     protocol         = "tcp"
  #     security_groups  = []
  #     self             = false
  #     to_port          = 22
  #   },

  #   {
  #     cidr_blocks      = ["0.0.0.0/0", ]
  #     description      = ""
  #     from_port        = 8080
  #     ipv6_cidr_blocks = []
  #     prefix_list_ids  = []
  #     protocol         = "tcp"
  #     security_groups  = []
  #     self             = false
  #     to_port          = 8080
  #   }
  # ]

  vpc_id     = aws_vpc.vpc-aws-project.id
  depends_on = [aws_vpc.vpc-aws-project]

  tags = {
    Name = "SG : bastion-host-sg"
  }
}
