output "db_host" {
  value = trim(aws_db_instance.db_instance.endpoint, ":1433")
}
output "db_username" {
  value = aws_db_instance.db_instance.username
}
output "db_password" {
  value = aws_db_instance.db_instance.password
  sensitive = true
}
output "db_port" {
  value = aws_db_instance.db_instance.port
}
output "db_storage" {
  value = aws_db_instance.db_instance.allocated_storage
}
output "db_character_set" {
  value = aws_db_instance.db_instance.character_set_name
}
output "db_timezone" {
  value = aws_db_instance.db_instance.timezone
}
output "db_engine" {
  value = aws_db_instance.db_instance.engine
}
output "db_engine_version" {
  value = aws_db_instance.db_instance.engine_version
}
output "db_instance_class" {
  value = aws_db_instance.db_instance.instance_class
}