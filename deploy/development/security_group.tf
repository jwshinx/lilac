# A security group for the bastion server
#   allow ssh access in
#   allow http/https access out (to download packages)
#   allow postgres access in
resource "aws_security_group" "bastion" {
  description = "control bastion inbound and outbound access"
  name        = "${local.project}-${local.prefix}-bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.private_a.cidr_block,
      aws_subnet.private_b.cidr_block,
    ]
  }

  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.private_a.cidr_block,
      aws_subnet.private_b.cidr_block,
    ]
  }

  tags = local.common_tags
}

resource "aws_security_group" "ecs_service" {
  description = "access for the ecs service"
  name        = "${local.prefix}-ecs-service"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = [
      aws_subnet.private_a.cidr_block,
      aws_subnet.private_b.cidr_block,
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.colleges-lb.id
    ]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [
      aws_security_group.colleges-lb.id
    ]
  }

  tags = local.common_tags
}
