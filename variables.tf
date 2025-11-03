variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "public_key_path" {
  description = "Absolute path to your SSH public key file (used by aws_key_pair). Example: /home/youruser/.ssh/id_rsa.pub"
  type        = string
  default     = "/home/kali/.ssh/id_ed25519.pub"

}

variable "my_ip_cidr" {
  description = "CIDR allowed to SSH. Use your public IP with /32 to restrict access (e.g. 203.0.113.45/32). Default is open for demo only."
  type        = string
  default     = "0.0.0.0/0"
}

