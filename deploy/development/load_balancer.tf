###########################################
# colleges load balancer                     #
###########################################
resource "aws_lb" "colleges" {
  name               = "${local.project}-${local.prefix}-colleges-lb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  security_groups = [aws_security_group.colleges-lb.id]

  tags = local.common_tags
}

resource "aws_lb_target_group" "colleges" {
  name        = "${local.project}-${local.prefix}-colleges"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  port        = 8080

  health_check {
    path = "/ping"
  }
}

resource "aws_lb_listener" "colleges" {
  load_balancer_arn = aws_lb.colleges.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.colleges.arn
  }
}

resource "aws_security_group" "colleges-lb" {
  description = "allow access to application load balancer"
  name        = "${local.project}-${local.prefix}-colleges-lb"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}