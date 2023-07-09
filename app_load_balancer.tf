# resource "aws_security_group" "lb_sg" {
#   description = "lb sg"
#   vpc_id      = aws_vpc.vpc-aws-project.id

#   ingress {
#     from_port   = 80
#     to_port     = 8000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0", ]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }

# }


# resource "aws_lb" "aws-project-lb" {
#   name               = "aws-project-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [for subnet in aws_subnet.aws-project-public-subnets : subnet.id]

#   #   enable_deletion_protection = true

# }


# resource "aws_lb_target_group" "aws-project-target-group" {
#   name     = "aws-project-lb-tg"
#   port     = 8000
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc-aws-project.id
# }

# data "aws_instances" "aws-project-asg-instances" {

#   filter {
#     name   = "subnet-id"
#     values = aws_subnet.vpc-aws-project-private-subnets[*].id
#   }

#   depends_on = ["aws_autoscaling_group.aws-project-asg"]
# }

# resource "aws_lb_target_group_attachment" "aws-project-target-group-attach" {
#   count            = length(data.aws_instances.aws-project-asg-instances.ids)
#   target_group_arn = aws_lb_target_group.aws-project-target-group.arn
#   target_id        = data.aws_instances.aws-project-asg-instances.ids[count.index]
#   #   target_id = [for subnet in aws_subnet.vpc-aws-project-private-subnets : subnet.id]
#   port = 8000

#   depends_on = [aws_autoscaling_group.aws-project-asg ]

# }

# resource "aws_lb_listener" "aws-project-lb-listener" {
#   load_balancer_arn = aws_lb.aws-project-lb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.aws-project-target-group.arn
#   }
# }