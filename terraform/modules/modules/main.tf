resource "aws_instance" "example" {
  ami             = "ami-011899242bb902164"
  instance_type   = "t2.micro"
#  key_name        = aws_key_pair.ansible.key_name
  security_groups = [aws_security_group.instances.name]

  tags = {
    Name = "${var.environment_name}-web-server"
  }

#  provisioner "local-exec" {
#    command = "echo ubuntu@${self.public_dns} > /root/Devops-Project/ansible/inventory"
#  }
}

resource "aws_security_group" "instances" {
  name        = "${var.environment_name}-sg"
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
