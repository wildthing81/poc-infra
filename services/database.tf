resource "aws_db_subnet_group" "main" {
  name       = "${var.stage}-${var.backend}-db-sg"
  subnet_ids = var.shared.outputs.private_subnet_ids
  tags = {
    Name = "${var.stage}-${var.app_name}-database-subnetgroup"
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.stage}-${var.backend}-db"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  engine                  = "aurora-postgresql"
  availability_zones      = local.az
  database_name           = "foo"
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 10
  preferred_backup_window = "07:00-09:00"
  deletion_protection     = false
  skip_final_snapshot     = true
  vpc_security_group_ids  = [module.ecs_cluster.db_sg_id]
}

resource "aws_rds_cluster_instance" "primary" {
  identifier           = "${var.stage}-${var.backend}-instance"
  cluster_identifier   = aws_rds_cluster.main.id
  instance_class       = "db.t3.medium"
  db_subnet_group_name = aws_rds_cluster.main.db_subnet_group_name
  publicly_accessible  = false
  engine               = aws_rds_cluster.main.engine

  /*lifecycle {
    ignore_changes = [
      "identifier",
      "cluster_identifier"
    ]
  }*/
}

