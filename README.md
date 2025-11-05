# Terraform AWS Web Server - Infrastructure as Code Project

A comprehensive demonstration of Infrastructure as Code (IaC) principles using Terraform to deploy a secure AWS web server. This project showcases modern DevOps practices including cloud automation, security scanning, and best practices for managing cloud infrastructure programmatically.

---

## Table of Contents

- [What is Infrastructure as Code (IaC)?](#what-is-infrastructure-as-code-iac)
- [IaC Principles](#iac-principles)
- [Project Overview](#project-overview)
- [Terraform Essentials](#terraform-essentials)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [IaC Security with tfsec](#iac-security-with-tfsec)
- [Security Findings and Remediation](#security-findings-and-remediation)
- [Usage](#usage)
- [Clean Up](#clean-up)
- [References](#references)

---

## What is Infrastructure as Code (IaC)?

Infrastructure as Code is a modern approach to managing and provisioning computing infrastructure through machine-readable configuration files rather than manual processes or interactive configuration tools. Instead of manually clicking through cloud console interfaces or running shell scripts, IaC allows teams to define infrastructure declaratively using code.

### Benefits of IaC

- **Version Control**: Track infrastructure changes like you would code changes
- **Reproducibility**: Consistently deploy identical infrastructure across environments
- **Automation**: Reduce manual errors and accelerate deployment processes
- **Scalability**: Easily replicate infrastructure at scale
- **Documentation**: Code serves as self-documenting infrastructure specifications
- **Collaboration**: Team members can review, discuss, and approve infrastructure changes
- **Disaster Recovery**: Quickly recreate infrastructure if needed
- **Cost Efficiency**: Avoid manual configuration mistakes that lead to wasted resources

---

## IaC Principles

Effective Infrastructure as Code follows several core principles:

**1. Declarative Configuration**
Define the desired state of infrastructure without specifying step-by-step procedures. Tools determine how to achieve that state.

**2. Version Control Everything**
Store all infrastructure code in version control systems (Git) to maintain history, enable rollbacks, and facilitate collaboration.

**3. Idempotency**
Running the same configuration multiple times produces the same result. Infrastructure definitions should be repeatable and reliable.

**4. Modularity**
Organize infrastructure into reusable, composable modules that can be shared across projects and teams.

**5. Testing and Validation**
Treat infrastructure code with the same rigor as application code—write tests, run linters, and validate configurations before deployment.

**6. Security First**
Embed security practices into infrastructure code. Use policy as code, scan for vulnerabilities, and follow least-privilege principles.

**7. Documentation**
Keep infrastructure code readable and well-commented so team members understand the reasoning behind configurations.

**8. Infrastructure Immutability**
Prefer creating new infrastructure rather than modifying existing resources, reducing configuration drift.

---

## Project Overview

This project demonstrates a practical implementation of IaC by deploying an Apache web server on AWS using Terraform. It includes:

- **EC2 Instance**: Automatically provisioned with the latest Amazon Linux 2 AMI
- **Security Group**: Configured with ingress rules for SSH and HTTP, plus egress rules
- **SSH Key Pair**: Automated key management for secure access
- **Web Server**: Apache HTTP Server automatically installed and started
- **Custom Landing Page**: A styled HTML page served by the web server
- **Security Scanning**: Comprehensive vulnerability scanning with tfsec

---

## Terraform Essentials

Terraform is an open-source IaC tool developed by HashiCorp that uses declarative configuration language (HCL - HashiCorp Configuration Language) to define infrastructure.

### What is Terraform?

Terraform allows you to define infrastructure resources in configuration files, maintain those resources as code, and manage their lifecycle through commands. It works with multiple cloud providers including AWS, Azure, Google Cloud, and many others.

### Key Terraform Concepts

**Providers**: Plugins that enable Terraform to interact with cloud platforms. Example: `hashicorp/aws`

**Resources**: Infrastructure components you want to create (EC2 instances, security groups, etc.)

**Variables**: Input values for your configuration, allowing parameterization and reusability

**Outputs**: Values exported from your configuration (useful for retrieving instance IPs, URLs, etc.)

**State**: Terraform tracks the current state of your infrastructure in `terraform.tfstate` file

**Modules**: Collections of resources organized together for reusability

### Essential Terraform Commands

```bash
# Initialize Terraform working directory (required first step)
terraform init

# Validate syntax and configuration correctness
terraform validate

# Plan infrastructure changes without applying them
terraform plan

# Apply planned changes to create/modify infrastructure
terraform apply

# Show current state of resources
terraform show

# Destroy all infrastructure managed by this configuration
terraform destroy

# Format Terraform files according to style conventions
terraform fmt

# List all resources in current state
terraform state list

# Show details of a specific resource
terraform state show aws_instance.demo
```

### Terraform File Structure

- **main.tf**: Primary configuration file containing resource definitions
- **variables.tf**: Input variable declarations with defaults
- **outputs.tf**: Output value definitions
- **terraform.tfstate**: Current state file (auto-generated, do not edit manually)
- **terraform.tfstate.backup**: Backup of previous state

---

## Project Structure

```
Terraform-aws-webserver/
├── main.tf                      # Core infrastructure configuration
├── variables.tf                 # Variable definitions and defaults
├── outputs.tf                   # Output values
├── terraform.tfstate            # Current state file
├── terraform.tfstate.backup     # Backup state file
├── tfsec_results.json          # Security scan results
└── README.md                    # Documentation
```

---

## Prerequisites

Before deploying this project, ensure you have:

1. **AWS Account**: An active AWS account with appropriate permissions
2. **AWS Credentials**: Configured locally using AWS CLI or environment variables
3. **Terraform**: Version 1.3.0 or higher installed on your system
4. **SSH Key Pair**: Generated SSH keys (if not present, generate with `ssh-keygen -t ed25519`)
5. **tfsec**: Installed for security scanning (optional but recommended)

### Installation

**Install Terraform** (macOS with Homebrew):
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Install AWS CLI**:
```bash
pip install awscli
```

**Install tfsec** (macOS with Homebrew):
```bash
brew install tfsec
```

**Configure AWS Credentials**:
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region (e.g., eu-north-1)
```

---

## Getting Started

### Step 1: Clone or Copy Project Files

Ensure you have all three configuration files in your project directory.

### Step 2: Customize Variables

Edit `variables.tf` to match your environment:

```hcl
variable "public_key_path" {
  description = "Absolute path to your SSH public key file"
  type        = string
  default     = "/home/your_user/.ssh/id_ed25519.pub"  # Update this path
}

variable "my_ip_cidr" {
  description = "Your public IP with /32 suffix for SSH access"
  type        = string
  default     = "YOUR_PUBLIC_IP/32"  # Replace with your IP
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"  # Change if desired
}
```

### Step 3: Initialize Terraform

```bash
terraform init
```

This command downloads necessary plugins and initializes the working directory.

### Step 4: Validate Configuration

```bash
terraform validate
```

Ensures your configuration is syntactically correct.

### Step 5: Review Plan

```bash
terraform plan
```

Shows exactly what resources will be created. Review carefully before proceeding.

### Step 6: Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to create the infrastructure.

### Step 7: Access Your Web Server

After deployment, Terraform outputs useful information:

```
instance_public_ip = "123.45.67.89"
website_url = "http://123.45.67.89"
ssh_command = "ssh -i ~/.ssh/id_ed25519 ec2-user@123.45.67.89"
```

Visit the website URL in your browser or use the SSH command to connect to the instance.

---

## IaC Security with tfsec

Security should be embedded throughout the Infrastructure as Code process. tfsec is a static analysis security scanner for Terraform code that identifies misconfigurations, compliance violations, and security risks.

### What is tfsec?

tfsec is an open-source security scanning tool developed by Aqua Security that analyzes Terraform files and reports findings based on AWS, Azure, Google Cloud, and other cloud provider security best practices. It helps teams identify vulnerabilities before resources are deployed.

### Why tfsec Matters in IaC

1. **Shift-Left Security**: Catch security issues during development, not in production
2. **Prevention Over Detection**: Prevent insecure resources from being created
3. **Policy Enforcement**: Automatically enforce security policies across infrastructure
4. **Cost Savings**: Avoid security incidents, compliance violations, and remediation costs
5. **Team Education**: Security findings teach teams about cloud security best practices

### Running tfsec

```bash
# Scan current directory for security issues
tfsec .

# Generate JSON output
tfsec . -f json > tfsec_results.json

# Scan with detailed output
tfsec . -v
```

---

## Security Findings and Remediation

This project's tfsec scan identified several security issues. Below are the findings and recommended remediations:

### Critical Issues

**1. AVD-AWS-0104: No Public Egress Security Group Rule**
- **Severity**: CRITICAL
- **Issue**: Security group allows unrestricted egress to the internet (0.0.0.0/0)
- **Impact**: Any EC2 instance can transmit data to any internet destination
- **Remediation**: Restrict egress to only necessary destinations

```hcl
egress {
  description      = "Allow HTTPS to package repositories"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]  # Consider restricting further
}
```

**2. AVD-AWS-0107: Public Ingress Security Group Rules**
- **Severity**: CRITICAL
- **Issue**: HTTP port (80) open to public internet (0.0.0.0/0)
- **Impact**: Web server is exposed to potential attacks from anywhere
- **Remediation**: For a public web server, this may be intentional, but SSH should be restricted

```hcl
ingress {
  description = "SSH access"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["YOUR_IP/32"]  # Restrict to your IP only
}
```

### High Severity Issues

**3. AVD-AWS-0131: Instance with Unencrypted Block Device**
- **Severity**: HIGH
- **Issue**: EC2 instance root volume is not encrypted
- **Impact**: Stored data is vulnerable if storage is compromised
- **Remediation**: Enable EBS encryption

```hcl
root_block_device {
  volume_type           = "gp3"
  volume_size           = 20
  delete_on_termination = true
  encrypted             = true  # Enable encryption
}
```

**4. AVD-AWS-0028: Enforce HTTP Token for IMDS**
- **Severity**: HIGH
- **Issue**: Instance Metadata Service (IMDS) doesn't require session tokens
- **Impact**: Vulnerable to SSRF attacks that could expose credentials
- **Remediation**: Enable IMDSv2

```hcl
metadata_options {
  http_endpoint               = "enabled"
  http_tokens                 = "required"  # Require session tokens
  http_put_response_hop_limit = 1
}
```

### Low Severity Issues

**5. AVD-AWS-0124: Missing Security Group Rule Descriptions**
- **Severity**: LOW
- **Issue**: Egress rule lacks a descriptive comment
- **Impact**: Reduced clarity on the purpose of the rule
- **Remediation**: Add descriptions to all rules (already present in current configuration)

```hcl
egress {
  description = "Allow all outbound traffic for package updates"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

### Remediated Configuration Example

```hcl
resource "aws_instance" "demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.deployer.key_name

  # Enable EBS encryption
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }

  # Enable IMDSv2
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              # ... rest of user data
              EOF
  )

  tags = {
    Name = "terraform-web-server"
  }
}
```

---

## Usage

### Deploy Infrastructure

```bash
# Initialize, plan, and apply
terraform init
terraform plan
terraform apply

# Access outputs
terraform output
```

### Access Web Server

```bash
# Get the public IP
terraform output instance_public_ip

# SSH into the instance
ssh -i ~/.ssh/id_ed25519 ec2-user@<PUBLIC_IP>

# Or use the generated SSH command
terraform output ssh_command | bash
```

### Update Infrastructure

Modify configuration files and run:

```bash
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Run Security Scan

```bash
# Install tfsec if not already installed
brew install tfsec

# Run security scan
tfsec .

# Generate report
tfsec . -f json > tfsec_results.json
```

---

## Clean Up

When you're finished, destroy all infrastructure to avoid unnecessary AWS charges:

```bash
terraform destroy
```

Type `yes` to confirm. This will:
- Terminate the EC2 instance
- Delete the security group
- Remove the key pair
- Release associated resources

---

## Best Practices Applied

✅ **Version Control**: All configuration tracked in Git  
✅ **Variables**: Externalized configuration for flexibility  
✅ **Outputs**: Useful information exposed for users  
✅ **Descriptions**: Clear documentation of resources and variables  
✅ **Security Scanning**: tfsec integration for vulnerability detection  
✅ **Modularity**: Organized, reusable configuration structure  
✅ **Naming Conventions**: Consistent, descriptive resource names  
✅ **State Management**: Secure handling of Terraform state  

---

## References

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider for Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [tfsec Documentation](https://aquasecurity.github.io/tfsec/)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [Infrastructure as Code Best Practices](https://www.terraform.io/cloud-docs/state)

---

## License

This project is provided as-is for educational and demonstration purposes.

## Support

For issues or questions, please refer to the official Terraform and AWS documentation, or consult your cloud security team for environment-specific guidance.

---

## Index

# Project Images
Below are the images from the project.The images shows terraform and the web server hosted in aws.

![Alt text](/Images/terraform.png)

![Alt text](/Images/terraform2.png)

![Alt text](/Images/terraform5.png)

![Alt text](/Images/terraform8.png)






