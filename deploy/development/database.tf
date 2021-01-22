resource "aws_db_subnet_group" "main" {
  name = "${local.project}-${local.prefix}-main"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-main")
  )
}

######################################################
# postgres - only accessible by bastion server
######################################################
resource "aws_security_group" "rds-postgres" {
  description = "allow access to the rds postgres database instance"
  name        = "${local.project}-${local.prefix}-rds-postgres-inbound-access"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol  = "tcp"
    from_port = 5432
    to_port   = 5432

    security_groups = [
      aws_security_group.bastion.id,
      # aws_security_group.ecs_service.id
    ]
  }

  tags = local.common_tags
}

resource "aws_db_instance" "lilac_postgres" {
  identifier              = "${local.project}-${local.prefix}-db"
  name                    = "education"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "11.4"
  instance_class          = "db.t2.micro"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  password                = var.postgres_db_password
  username                = var.postgres_db_username
  backup_retention_period = 0
  multi_az                = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds-postgres.id]

  tags = merge(
    local.common_tags,
    map("Name", "${local.prefix}-main")
  )
}
