
resource "aws_db_instance" "demo-arch" {
  identifier = "demo-arch"
  lifecycle {
    prevent_destroy = true
  }

  ## CONSTANTS
  engine               = "postgres"
  multi_az             = true
  publicly_accessible  = false
  //required unless snapshot_indentifier is used. Setup CI or cronjob to change this after creation
  //or update infra to use a snapshot_identifier
  username             = "root"
  password             = "changelater"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_groups.name
  vpc_security_group_ids = [
    aws_security_group.private_rds.id,
  ]

  ## No Interruption Tunable
  monitoring_interval                 = 60 # Enhanced monitoring
  //need to create monitoring role
  monitoring_role_arn                 = data.aws_iam_role.monitoring_role.arn
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true
  performance_insights_enabled        = true
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
  ]

  ## Some Interruption Tunable
  instance_class             = "db.t3.micro"
  auto_minor_version_upgrade = false
  copy_tags_to_snapshot      = true
  backup_retention_period    = 30
  storage_encrypted          = true
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value = aws_db_instance.demo-arch.endpoint
}