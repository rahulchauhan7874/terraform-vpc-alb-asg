resource "aws_security_group" "sg-vpc-aws-project" {
  vpc_id = aws_vpc.vpc-aws-project.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }

}

resource "aws_launch_template" "aws-project-asg-template" {
  name_prefix            = "aws-project-asg-template"
  image_id               = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = "my_ubuntu"
  vpc_security_group_ids = [aws_security_group.sg-vpc-aws-project.id]

  lifecycle {
    create_before_destroy = true
  }
  /*
Note that the ASG uses a reference to fill in the launch configuration name.
This leads to a problem: launch configurations are immutable, so if you
change any parameter of your launch configuration, Terraform will try to
replace it. Normally, when replacing a resource, Terraform would delete the
old resource first and then creates its replacement, but because your ASG
now has a reference to the old resource, Terraform won’t be able to delete
it.
To solve this problem, you can use a lifecycle setting.
*/
  tags = {
    Name = "asg-template"
  }
}

resource "aws_autoscaling_group" "aws-project-asg" {
  name = "aws-new-asg"
  #   count            = length(var.cidr_private_subnet)
  desired_capacity = 2
  max_size         = 4
  min_size         = 1
  # availability_zones = element(aws_subnet.vpc-aws-project-private-subnets[*].id, count.index)
  vpc_zone_identifier = [for subnet in aws_subnet.vpc-aws-project-private-subnets : subnet.id]


  launch_template {
    id      = aws_launch_template.aws-project-asg-template.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
      auto_rollback          = true
    }
  }

}

