# AMI Data Block
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

#aws default vpc

resource "aws_default_vpc" "default" {
  
}

# Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow SSH, HTTP, HTTPS, and custom ports"

  tags = {
    Name = "allow_tls"
  }
}

# Allowed Ports
locals {
  ingress_ports = ["22", "80", "443", "8888", "30080"]
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  for_each = toset(local.ingress_ports)

  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"

  from_port   = each.value
  to_port     = each.value
  ip_protocol = "tcp"
}

# Egress Rule - Allow All Outbound Traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/../ec2-hackathon.pub")
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = "Web-Server"
  }
}

# Elastic IP
resource "aws_eip" "web" {
  domain   = "vpc"
  instance = aws_instance.web.id

  depends_on = [aws_instance.web]

  tags = {
    Name = "Web-Server-EIP"
  }
}