terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "vault" {
  address = "http://localhost:8200"
  token   = ""
}

data "vault_generic_secret" "aws_creds" {
  path = "aws-creds/credentials"
}


provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_generic_secret.aws_creds.data["AWS_ACCESS_KEY_ID"]
  secret_key = data.vault_generic_secret.aws_creds.data["AWS_SECRET_ACCESS_KEY"]
}


data "vault_generic_secret" "ssh_key" {
  path = "ssh/private-key"
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = data.vault_generic_secret.ssh_key.data["key"]
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow traffic from the Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]  # Allow traffic from the Load Balancer's security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-011899242bb902164"  # Use the appropriate AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.ec2_sg.name]
}


output "public_ip" {
  value = aws_instance.example.public_ip
}
