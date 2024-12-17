# To create an output.tf file, expand the folder task_10097_rds and click on the New File icon to add the file.

# Name the file as output.tf and press Enter to save it.

# Paste the below content into the output.tf file.

output "security_group_id" {
  value       = aws_security_group.rds_sg.id            
}
output "db_instance_endpoint" {
  value       = aws_db_instance.myinstance.endpoint         
}