output "instance_id" {
  description = "EC2 instance id"
  value       = aws_instance.demo.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.demo.public_ip
}

output "website_url" {
  description = "The URL to access the web server"
  value       = "http://${aws_instance.demo.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/id_ed25519 ec2-user@${aws_instance.demo.public_ip}"
}
