variable "application" {
  type = string
}
variable "cost-center" {
  type = string
}
variable "deployed-by" {
  type = string
}
variable "environment" {
  type = string
}
variable "region" {
  type = string
}
variable "backup_restore_bucket" {
  type = string
}
variable "cidr_blocks" {
  default = ["10.195.0.0/16"]
  type = list(string)
}
variable "db_az" {
  type = string
}
variable "db_subnet_group_name" {
  type = string
}
variable "db_storage" {
  type = string
}
variable "db_storage_type" {
  default = "gp2"
  type = string
}
variable "db_instance_class" {
  type = string
}
variable "db_admin_user" {
  default = "admin"
  type = string
}
variable "db_port" {
  default = "1433"
  type = string
}
variable "db_engine" {
  type = string
}
variable "db_family" {
  type = string
}
variable "db_engine_version" {
  type = string
}
variable "db_major_engine_version" {
  type = string
}
variable "db_character_set" {
  type = string
}
variable "db_timezone" {
  default = "GMT Standard Time"
  type = string
}
variable "db_maintenance_window" {
  default = "sat:06:00-sat:07:00"
  type = string
}
variable "db_bkp_retention" {
  default = 15
  type = string
}
variable "db_bkp_window" {
  default = "03:00-05:00"
  type = string
}
variable "db_encrypt"{
  default = true
  type= bool
}
variable "vpc_id" {
  type = string
}
variable "db_final_snapshot" {
  default = "false"
  type = string
}
variable "publicly_accessible" {
  default = false
  type = bool
}
variable "sns_topic_arn"{
    type = string
}