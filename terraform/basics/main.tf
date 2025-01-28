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
  public_key = data.vault_generic_secret.ssh_key.data["private_key"]
}

resource "aws_instance" "example" {
  ami             = "ami-011899242bb902164"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]
 
  tags = {
    Name = "WebServer"
  }

  provisioner "local-exec" {
    command = "echo ubuntu@${self.public_dns} > /root/devops-project/ansible/inventory"
  }
}

resource "aws_security_group" "instances" {
  name        = "instances"
  description = "Sec grp for web server with multiple ports"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_server_sg"
  }
}

output "public_ip" {
  value = aws_instance.example.public_dns
}
