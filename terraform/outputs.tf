# Outputs the Public IP of an EC2 instance
output "instance_public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.web.public_ip
}

output "environment" {
  value       = terraform.workspace
}