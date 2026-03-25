resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${var.account_name}"
  subnet_ids = data.aws_subnets.default.ids

  tags = {
    Name = "rds-subnet-group-${var.account_name}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.account_name}"
  description = "Allow MySQL from EC2 only"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL depuis EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-${var.account_name}"
  }
}

resource "aws_db_instance" "mysql" {
  identifier        = "rds-${var.account_name}"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = var.rds_db_name
  username = var.rds_username
  password = var.rds_password

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  backup_retention_period = 0
  storage_encrypted       = true

  # Fenêtre de maintenance : samedi 01h00-03h00
  maintenance_window = "sat:01:00-sat:03:00"

  skip_final_snapshot = true

  tags = {
    Name = "rds-${var.account_name}"
  }
}
