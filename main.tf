resource "random_id" "id" {
  byte_length = 4
}

locals {
  identifier    = lower("db-${var.application}-${var.environment}-${random_id.id.hex}")
  param_group   = lower("param-group-${var.application}-${var.environment}-${random_id.id.hex}")
  option_group  = lower("option-group-${var.application}-${var.environment}-${random_id.id.hex}")
  sec_group     = lower("$secgroup-${var.application}-${var.environment}-${random_id.id.hex}")
  rds_s3_policy = lower("policy-rds-s3-${var.application}-${var.environment}-${random_id.id.hex}")
  rds_s3_role   = lower("role-rds-s3-${var.application}-${var.environment}-${random_id.id.hex}")
  monitor_role  = lower("role-all-rds-monitor-${var.application}-${var.environment}-${random_id.id.hex}")
}