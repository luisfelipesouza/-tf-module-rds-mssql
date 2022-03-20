resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+"
}

resource "aws_db_instance" "db_instance" {
  availability_zone         = var.db_az
  allocated_storage         = var.db_storage
  publicly_accessible       = var.publicly_accessible
  storage_type              = var.db_storage_type
  db_subnet_group_name      = var.db_subnet_group_name
  option_group_name         = aws_db_option_group.mssql_group.name
  character_set_name        = var.db_character_set
  port                      = var.db_port
  timezone                  = var.db_timezone
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_instance_class
  identifier                = local.identifier
  username                  = var.db_admin_user
  password                  = random_password.password.result
  kms_key_id                = var.db_encrypt == "true" ? aws_kms_key.kms[0].arn : null
  storage_encrypted         = var.db_encrypt
  enabled_cloudwatch_logs_exports = ["error"]
  backup_retention_period   = var.db_bkp_retention
  backup_window             = var.db_bkp_window
  maintenance_window        = var.db_maintenance_window
  monitoring_interval       = "60"
  monitoring_role_arn       = aws_iam_role.rds_role_monitoring.arn
  copy_tags_to_snapshot     = true
  skip_final_snapshot       = var.db_final_snapshot == "true" ? "false" : "true"
  final_snapshot_identifier = "${local.identifier}-final"
  vpc_security_group_ids    = ["${aws_security_group.sec_group_rds.id}"]
  parameter_group_name      = aws_db_parameter_group.default.name
  apply_immediately         = true
  
  tags = {
    environment   = lower(var.environment)
    application   = lower(var.application)
    cost-center   = lower(var.cost-center)
    deployed-by   = lower(var.deployed-by)
  }

  depends_on = [aws_kms_key.kms]

}

resource "aws_db_instance_role_association" "db_role" {
  db_instance_identifier = aws_db_instance.db_instance.id
  feature_name           = "S3_INTEGRATION"
  role_arn               = aws_iam_role.rds_role.arn
}

resource "aws_security_group" "sec_group_rds" {
  name        = local.sec_group
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    cidr_blocks     = var.cidr_blocks
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
    environment   = lower(var.environment)
    application   = lower(var.application)
    cost-center   = lower(var.cost-center)
    deployed-by   = lower(var.deployed-by)
  }
}

resource "aws_db_option_group" "mssql_group" {
  name                     = local.option_group
  option_group_description = "Group create for native MSSQL backup"
  engine_name              = var.db_engine
  major_engine_version     = var.db_major_engine_version

  option {
    option_name = "SQLSERVER_BACKUP_RESTORE"

    option_settings {
      name  = "IAM_ROLE_ARN"
      value = aws_iam_role.rds_role.arn
    }
  }
}

resource "aws_db_parameter_group" "default" {
  name   = local.param_group
  family = var.db_family

  parameter {
    name  = "optimize for ad hoc workloads"
    value = "1"
  }
  parameter {
    name  = "ad hoc distributed queries"
    value = "1"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "rds.force_ssl"
    value = 1
  }
}

resource "aws_db_event_subscription" "default" {
  name      = "event-${local.identifier}"
  sns_topic = var.sns_topic_arn

  source_type = "db-instance"
  source_ids  = [aws_db_instance.db_instance.id]

  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
}
